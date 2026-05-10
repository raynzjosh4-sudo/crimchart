#include "video_decoder.h"
#include <aaudio/AAudio.h>
#include <android/log.h>
#include <iostream>
#include <unistd.h>

#define LOGI(...)                                                              \
  __android_log_print(ANDROID_LOG_INFO, "VideoEngine", __VA_ARGS__)
#define LOGE(...)                                                              \
  __android_log_print(ANDROID_LOG_ERROR, "VideoEngine", __VA_ARGS__)

double get_current_time_sec() {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC, &now);
  return now.tv_sec + now.tv_nsec / 1e9;
}

VideoDecoder::VideoDecoder(int id) : id(id) {}

VideoDecoder::~VideoDecoder() {
  stop();
  if (nativeWindow) {
    ANativeWindow_release(nativeWindow);
    nativeWindow = nullptr;
  }
}

void VideoDecoder::setWindow(ANativeWindow *window) {
  if (this->nativeWindow) {
    ANativeWindow_release(this->nativeWindow);
  }
  this->nativeWindow = window;
}

void VideoDecoder::play(const std::string &url) {
  stop();
  this->url = url;
  this->isRunning = true;
  this->isPaused = false;
  this->decoderThread = new std::thread(&VideoDecoder::decodeLoop, this);
}

void VideoDecoder::pause() { isPaused = true; }

void VideoDecoder::resume() { isPaused = false; }

void VideoDecoder::stop() {
  isRunning = false;
  if (decoderThread && decoderThread->joinable()) {
    decoderThread->join();
    delete decoderThread;
    decoderThread = nullptr;
  }
}

double VideoDecoder::getPosition() { return currentPosition.load(); }
double VideoDecoder::getDuration() { return duration.load(); }

// Callback to force MediaCodec to output software-readable pixels (NV12)
// instead of opaque hardware buffers
static enum AVPixelFormat get_hw_format(AVCodecContext *ctx,
                                        const enum AVPixelFormat *pix_fmts) {
  for (const enum AVPixelFormat *p = pix_fmts; *p != AV_PIX_FMT_NONE; p++) {
    // We want CPU-readable frames so our sws_scale works. Ignore the opaque
    // MEDIACODEC format.
    if (*p != AV_PIX_FMT_MEDIACODEC) {
      LOGI("Hardware decoder negotiated pixel format: %d", (int)*p);
      return *p;
    }
  }
  return AV_PIX_FMT_NONE;
}

void VideoDecoder::decodeLoop() {
  if (!nativeWindow) {
    LOGE("nativeWindow is null!");
    return;
  }

  LOGI("Starting decode thread for URL: %s", url.c_str());

  // 🛡️ THE CORRECT IDIOM: Pass nullptr and let FFmpeg allocate the context.
  // Pre-allocating with avformat_alloc_context() and setting fields before
  // open_input causes internal state corruption in ffmpeg-kit, crashing inside
  // avformat_find_stream_info (av_find_program_from_stream null deref).
  //
  // All options — including probesize and analyzeduration — are passed via
  // AVDictionary, which is the only safe channel for a streaming context.
  AVDictionary *opts = nullptr;
  av_dict_set(&opts, "probesize", "10000000", 0);       // 10 MB deep probe
  av_dict_set(&opts, "analyzeduration", "10000000", 0); // 10 sec analysis
  av_dict_set(&opts, "reconnect", "1", 0);              // reconnect on drop
  av_dict_set(&opts, "reconnect_streamed", "1", 0);
  av_dict_set(&opts, "reconnect_delay_max", "5", 0);

  AVFormatContext *formatCtx = nullptr; // FFmpeg allocates this for us
  if (avformat_open_input(&formatCtx, url.c_str(), nullptr, &opts) != 0) {
    LOGE("Failed to open %s", url.c_str());
    av_dict_free(&opts);
    return; // formatCtx is guaranteed null on failure — nothing to free
  }
  av_dict_free(&opts);

  // Null-guard: should never be null after a successful open, but be safe.
  if (!formatCtx) {
    LOGE("formatCtx is null after successful open — aborting");
    return;
  }

  if (avformat_find_stream_info(formatCtx, nullptr) < 0) {
    LOGE("Failed to find stream info for %s", url.c_str());
    avformat_close_input(&formatCtx);
    return;
  }

  if (formatCtx->duration != AV_NOPTS_VALUE) {
    this->duration = (double)formatCtx->duration / AV_TIME_BASE;
  }

  int videoStreamIdx = -1;
  int audioStreamIdx = -1;
  AVCodecContext *videoCodecCtx = nullptr;
  AVCodecContext *audioCodecCtx = nullptr;
  AVRational videoTimeBase;

  // 🔍 STREAM INVENTORY: Log what FFmpeg found in the file.
  LOGI("Found %d stream(s) in file:", formatCtx->nb_streams);
  for (unsigned int i = 0; i < formatCtx->nb_streams; i++) {
    AVCodecParameters *cp = formatCtx->streams[i]->codecpar;
    const char *type = "unknown";
    if (cp->codec_type == AVMEDIA_TYPE_VIDEO)
      type = "VIDEO";
    else if (cp->codec_type == AVMEDIA_TYPE_AUDIO)
      type = "AUDIO";
    else if (cp->codec_type == AVMEDIA_TYPE_SUBTITLE)
      type = "SUBTITLE";
    LOGI("  stream[%d]: type=%s codec_id=%d sample_rate=%d channels=%d", i,
         type, cp->codec_id, cp->sample_rate, cp->ch_layout.nb_channels);
  }

  for (unsigned int i = 0; i < formatCtx->nb_streams; i++) {
    if (formatCtx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO &&
        videoStreamIdx < 0) {
      AVCodecID codecId = formatCtx->streams[i]->codecpar->codec_id;
      const AVCodec *codec = nullptr;

      // 🏎️ STAGE 6: Hardware Acceleration Priority
      // Attempt to load Android MediaCodec hardware decoders first
      if (codecId == AV_CODEC_ID_H264) {
        codec = avcodec_find_decoder_by_name("h264_mediacodec");
        if (codec)
          LOGI("Found Hardware Decoder: h264_mediacodec");
      } else if (codecId == AV_CODEC_ID_HEVC) {
        codec = avcodec_find_decoder_by_name("hevc_mediacodec");
        if (codec)
          LOGI("Found Hardware Decoder: hevc_mediacodec");
      } else if (codecId == AV_CODEC_ID_VP9) {
        codec = avcodec_find_decoder_by_name("vp9_mediacodec");
        if (codec)
          LOGI("Found Hardware Decoder: vp9_mediacodec");
      }

      // 🛡️ Fallback: If hardware decoder is unavailable (or not compiled in
      // FFmpeg), fallback to the software decoder.
      if (!codec) {
        codec = avcodec_find_decoder(codecId);
        if (codec)
          LOGI("Using Software Decoder: %s", codec->name);
      }

      if (!codec) {
        LOGE("Failed to find ANY video codec for id: %d", codecId);
        continue;
      }

      videoCodecCtx = avcodec_alloc_context3(codec);
      avcodec_parameters_to_context(videoCodecCtx,
                                    formatCtx->streams[i]->codecpar);

      // Force mediacodec to copy the decoded frames to CPU memory so we can
      // render them
      videoCodecCtx->get_format = get_hw_format;

      if (avcodec_open2(videoCodecCtx, codec, nullptr) < 0) {
        LOGE("Failed to open video codec");
        avcodec_free_context(&videoCodecCtx);
        continue;
      }
      videoStreamIdx = i;
      videoTimeBase = formatCtx->streams[i]->time_base;

    } else if (formatCtx->streams[i]->codecpar->codec_type ==
                   AVMEDIA_TYPE_AUDIO &&
               audioStreamIdx < 0) {
      AVCodecParameters *acp = formatCtx->streams[i]->codecpar;
      LOGI("Audio stream[%d]: codec_id=%d sample_rate=%d channels=%d "
           "format=%d extradata_size=%d",
           i, acp->codec_id, acp->sample_rate, acp->ch_layout.nb_channels,
           acp->format, acp->extradata_size);

      // 🛠️ Parse AAC AudioSpecificConfig from codecpar->extradata NOW,
      // before avcodec_open2 which may consume/free the extradata in
      // audioCodecCtx. codecpar->extradata is safe — it is never freed by codec
      // operations.
      int parsedSampleRate = 0;
      int parsedChannels = 0;
      if (acp->extradata && acp->extradata_size >= 2) {
        static const int kSRTable[] = {96000, 88200, 64000, 48000, 44100,
                                       32000, 24000, 22050, 16000, 12000,
                                       11025, 8000,  7350};
        static const int kCHTable[] = {0, 1, 2, 3, 4, 5, 6, 8};
        int cfg = (acp->extradata[0] << 8) | acp->extradata[1];
        int srIdx = (cfg >> 7) & 0x0F;
        int chCfg = (cfg >> 3) & 0x0F;
        if (srIdx < 13)
          parsedSampleRate = kSRTable[srIdx];
        if (chCfg >= 1 && chCfg <= 7)
          parsedChannels = kCHTable[chCfg];
        LOGI("Parsed from codecpar extradata: srIdx=%d->%dHz, chanCfg=%d->%dch",
             srIdx, parsedSampleRate, chCfg, parsedChannels);
      }

      const AVCodec *codec = avcodec_find_decoder(acp->codec_id);
      if (!codec) {
        LOGE("Failed to find audio codec for id: %d", acp->codec_id);
        continue;
      }
      LOGI("Audio codec name: %s", codec->name);

      audioCodecCtx = avcodec_alloc_context3(codec);
      avcodec_parameters_to_context(audioCodecCtx, acp);

      // Apply parsed values if the container reported garbage
      if ((audioCodecCtx->sample_rate <= 0 ||
           audioCodecCtx->sample_rate == 1) &&
          parsedSampleRate > 0) {
        LOGI("Overriding sample_rate %d -> %d from extradata",
             audioCodecCtx->sample_rate, parsedSampleRate);
        audioCodecCtx->sample_rate = parsedSampleRate;
      }
      if (parsedChannels > 0 && (audioCodecCtx->ch_layout.nb_channels <= 0 ||
                                 audioCodecCtx->ch_layout.nb_channels > 8)) {
        av_channel_layout_default(&audioCodecCtx->ch_layout, parsedChannels);
        LOGI("Overriding channels -> %d from extradata", parsedChannels);
      }
      LOGI("After parameters_to_context+patch: sample_rate=%d channels=%d",
           audioCodecCtx->sample_rate, audioCodecCtx->ch_layout.nb_channels);

      if (avcodec_open2(audioCodecCtx, codec, nullptr) < 0) {
        LOGE("Failed to open audio codec");
        avcodec_free_context(&audioCodecCtx);
        continue;
      }

      // Re-apply parsed sample_rate after open2 in case the codec reset it
      if (audioCodecCtx->sample_rate <= 0 && parsedSampleRate > 0)
        audioCodecCtx->sample_rate = parsedSampleRate;

      LOGI("After avcodec_open2: sample_rate=%d channels=%d",
           audioCodecCtx->sample_rate, audioCodecCtx->ch_layout.nb_channels);
      audioStreamIdx = i;
    }
  }

  if (videoStreamIdx == -1) {
    LOGE("No video stream found");
    if (audioCodecCtx)
      avcodec_free_context(&audioCodecCtx);
    avformat_close_input(&formatCtx);
    return;
  }

  AVFrame *frame = av_frame_alloc();
  AVFrame *rgbFrame = av_frame_alloc();
  AVPacket *packet = av_packet_alloc();

  int width = videoCodecCtx->width;
  int height = videoCodecCtx->height;

  // RGBA Video Buffer
  int numBytes = av_image_get_buffer_size(AV_PIX_FMT_RGBA, width, height, 1);
  uint8_t *buffer = (uint8_t *)av_malloc(numBytes * sizeof(uint8_t));
  av_image_fill_arrays(rgbFrame->data, rgbFrame->linesize, buffer,
                       AV_PIX_FMT_RGBA, width, height, 1);

  SwsContext *swsCtx = nullptr;

  ANativeWindow_setBuffersGeometry(nativeWindow, width, height,
                                   WINDOW_FORMAT_RGBA_8888);

  // Audio Pipeline Initialization
  SwrContext *swrCtx = nullptr;
  AAudioStreamBuilder *builder = nullptr;
  AAudioStream *audioStream = nullptr;
  int outChannels = 2; // Default to Stereo

  if (audioStreamIdx != -1) {
    int sr = audioCodecCtx->sample_rate;

    // 🛠️ The MP4 container has corrupt sample_rate in its stsd box (we see
    // sr=1). However the 2-byte AAC AudioSpecificConfig extradata holds the
    // REAL value. Parse it manually: bits [5..8] are the
    // samplingFrequencyIndex.
    if ((sr <= 0 || sr == 1) && audioCodecCtx->extradata_size >= 2) {
      static const int kSampleRateTable[] = {96000, 88200, 64000, 48000, 44100,
                                             32000, 24000, 22050, 16000, 12000,
                                             11025, 8000,  7350};
      // AudioSpecificConfig layout (big-endian bits):
      //   [0..4]  audioObjectType  (5 bits)
      //   [5..8]  samplingFreqIdx  (4 bits)  <-- we want this
      //   [9..12] channelConfig    (4 bits)
      int config =
          (audioCodecCtx->extradata[0] << 8) | audioCodecCtx->extradata[1];
      int srIdx = (config >> 7) & 0x0F;
      int chanCfg = (config >> 3) & 0x0F;

      if (srIdx < 13) {
        audioCodecCtx->sample_rate = kSampleRateTable[srIdx];
        LOGI("Parsed AAC extradata: srIdx=%d -> sample_rate=%d, chanCfg=%d",
             srIdx, audioCodecCtx->sample_rate, chanCfg);
      } else {
        // srIdx==15 means next 24 bits hold the explicit rate — treat as 44100
        // fallback
        audioCodecCtx->sample_rate = 44100;
        LOGI("AAC srIdx out of range (%d), using 44100 fallback", srIdx);
      }

      // Fix channels from chanCfg (0 = parse from bitstream, treat as stereo)
      if (chanCfg >= 1 && chanCfg <= 7) {
        static const int kChannels[] = {0, 1, 2, 3, 4, 5, 6, 8};
        audioCodecCtx->ch_layout.nb_channels = kChannels[chanCfg];
        LOGI("Parsed channels from AAC extradata: %d",
             audioCodecCtx->ch_layout.nb_channels);
      }
    }

    if (audioCodecCtx->sample_rate <= 0) {
      LOGE("Audio sample_rate still invalid after extradata parse: %d. "
           "Disabling.",
           audioCodecCtx->sample_rate);
      audioStreamIdx = -1;
    } else {
      LOGI("Audio ready: codec=%s sample_rate=%d channels=%d",
           avcodec_get_name(audioCodecCtx->codec_id),
           audioCodecCtx->sample_rate, audioCodecCtx->ch_layout.nb_channels);
    }
  }

  if (audioStreamIdx != -1) {
    outChannels = audioCodecCtx->ch_layout.nb_channels;
    if (outChannels <= 0 || outChannels > 8)
      outChannels = 2;

    // 🎧 AAudio hardware stream — set up now since output is always fixed at
    // 44100Hz. The swrCtx resampler is initialized LAZILY on the first decoded
    // frame to avoid reading corrupt/unset sample_fmt from the codec context.
    AAudio_createStreamBuilder(&builder);
    AAudioStreamBuilder_setFormat(builder, AAUDIO_FORMAT_PCM_I16);
    AAudioStreamBuilder_setChannelCount(builder, outChannels);
    AAudioStreamBuilder_setSampleRate(builder, 44100);
    AAudioStreamBuilder_setPerformanceMode(builder,
                                           AAUDIO_PERFORMANCE_MODE_LOW_LATENCY);

    aaudio_result_t result =
        AAudioStreamBuilder_openStream(builder, &audioStream);
    if (result == AAUDIO_OK && audioStream != nullptr) {
      AAudioStream_requestStart(audioStream);
      LOGI("AAudio stream started: %d channels @ 44100Hz", outChannels);
    } else {
      LOGE("Failed to open AAudio stream: %d. Audio disabled.", result);
      audioStream = nullptr;
      audioStreamIdx = -1;
    }
  }

  LOGI("Decoding started! Audio: %s", (audioStreamIdx != -1) ? "YES" : "NO");

  // \ud83d uee0\ufe0f FRAME-RATE-BASED TIMER: More reliable than PTS for
  // corrupt containers. We compute a fixed frameDuration from the stream's
  // declared frame rate and pace every frame as frameCount * frameDuration from
  // a fixed startTime. This guarantees correct speed even when container PTS
  // values are corrupt.
  AVRational streamFps = formatCtx->streams[videoStreamIdx]->avg_frame_rate;
  if (streamFps.num <= 0 || streamFps.den <= 0)
    streamFps = formatCtx->streams[videoStreamIdx]->r_frame_rate;
  double frameDuration = (streamFps.num > 0 && streamFps.den > 0)
                             ? (double)streamFps.den / streamFps.num
                             : (1.0 / 30.0);
  LOGI("Frame pacing: %.2ffps -> %.4fs/frame",
       (double)streamFps.num / streamFps.den, frameDuration);

  double startTime = get_current_time_sec();
  int64_t frameCount = 0;

  while (isRunning) {
    int readRet = av_read_frame(formatCtx, packet);
    if (readRet < 0) {
      if (readRet == AVERROR(EAGAIN)) {
        usleep(10000); // Network stall — wait 10ms and retry
        continue;
      }
      break; // EOF or fatal error
    }
    if (packet->stream_index == videoStreamIdx) {
      if (avcodec_send_packet(videoCodecCtx, packet) == 0) {
        while (avcodec_receive_frame(videoCodecCtx, frame) == 0) {
          if (!isRunning)
            break;

          // 🕒 AUDIO MASTER CLOCK SYNC (Drift Correction & Stall Recovery)
          // The system clock (now) drives the micro-pacing, but the Audio
          // Hardware is the ultimate macro-clock. If they drift apart, we
          // adjust the baseline.
          double now = get_current_time_sec();
          if (audioStream) {
            double audioPlayedTime =
                (double)AAudioStream_getFramesRead(audioStream) / 44100.0;
            double systemTimeElapsed = now - startTime;
            double drift = systemTimeElapsed - audioPlayedTime;

            if (drift > 0.5 || drift < -0.5) {
              // Heavy drift (e.g. network stall). Snap the clock exactly to
              // audio.
              startTime = now - audioPlayedTime;
            }
            // For minor drifts (<0.5s), we rely on AAudioStream_write blocking
            // to naturally pace the hardware, preventing aggressive
            // micro-stuttering.
          }

          // Pace this frame at its expected display time
          double expectedTime = startTime + frameCount * frameDuration;
          now = get_current_time_sec();
          if (expectedTime > now) {
            usleep((long)((expectedTime - now) * 1000000.0));
          }
          currentPosition = (double)frame->pts * av_q2d(videoTimeBase);
          frameCount++;

          // 🖼️ Lazy SWS Scaler Init: Wait until the first frame reveals its
          // true pixel format.
          if (!swsCtx) {
            AVPixelFormat srcFmt = (AVPixelFormat)frame->format;
            if (srcFmt == AV_PIX_FMT_MEDIACODEC) {
              LOGE("Fatal: Frame format is MEDIACODEC. Hardware failed to "
                   "output software pixels.");
              break;
            }
            swsCtx = sws_getContext(width, height, srcFmt, width, height,
                                    AV_PIX_FMT_RGBA, SWS_BILINEAR, nullptr,
                                    nullptr, nullptr);
            LOGI("SWS Scaler initialized: format %d -> RGBA", (int)srcFmt);
          }

          // Render
          if (swsCtx) {
            sws_scale(swsCtx, (uint8_t const *const *)frame->data,
                      frame->linesize, 0, height, rgbFrame->data,
                      rgbFrame->linesize);

            ANativeWindow_Buffer windowBuffer;
            if (ANativeWindow_lock(nativeWindow, &windowBuffer, nullptr) == 0) {
              uint8_t *dst = static_cast<uint8_t *>(windowBuffer.bits);
              uint8_t *src = rgbFrame->data[0];
              int dstStride = windowBuffer.stride * 4;
              int srcStride = rgbFrame->linesize[0];

              for (int h = 0; h < height; h++) {
                memcpy(dst + h * dstStride, src + h * srcStride, srcStride);
              }
              ANativeWindow_unlockAndPost(nativeWindow);
            }
          }

          // 🛑 TIKTOK PRELOAD PAUSE: Freeze exactly after the first frame is
          // rendered.
          if (isPaused) {
            if (audioStream)
              AAudioStream_requestPause(audioStream);
            while (isPaused && isRunning) {
              usleep(20000); // Wait 20ms
            }
            if (audioStream && isRunning)
              AAudioStream_requestStart(audioStream);
            // Note: When we unpause, the Master Clock algorithm at the top of
            // the loop will automatically detect the massive time drift and
            // seamlessly snap the clocks back into sync!
          }
        }
      }
    } else if (packet->stream_index == audioStreamIdx) {
      if (avcodec_send_packet(audioCodecCtx, packet) == 0) {
        // \ud83d\udee0\ufe0f activeSampleRate persists across frames \u2014
        // frame->sample_rate is 0 in the corrupt container and causes SIGFPE in
        // av_rescale_rnd / swr_get_delay.
        int activeSampleRate = 44100;

        while (avcodec_receive_frame(audioCodecCtx, frame) == 0) {
          if (!isRunning)
            break;
          if (frame->nb_samples <= 0)
            continue; // Skip empty frames

          // Lazy resampler init: use frame properties, NOT codec context
          // metadata
          if (!swrCtx) {
            int inChannels = frame->ch_layout.nb_channels;
            if (inChannels <= 0 || inChannels > 8)
              inChannels = outChannels;

            AVSampleFormat srcFmt = (AVSampleFormat)frame->format;
            if (srcFmt < 0 || srcFmt == AV_SAMPLE_FMT_NONE)
              srcFmt = AV_SAMPLE_FMT_FLTP;

            // \ud83d udee0\ufe0f Capture validated sample rate NOW \u2014 used
            // for ALL subsequent frames
            activeSampleRate =
                frame->sample_rate > 0 ? frame->sample_rate : 44100;

            AVChannelLayout srcLayout, dstLayout;
            av_channel_layout_default(&srcLayout, inChannels);
            av_channel_layout_default(&dstLayout, outChannels);

            int ret = swr_alloc_set_opts2(&swrCtx, &dstLayout,
                                          AV_SAMPLE_FMT_S16, 44100, &srcLayout,
                                          srcFmt, activeSampleRate, 0, nullptr);
            av_channel_layout_uninit(&srcLayout);
            av_channel_layout_uninit(&dstLayout);

            if (ret == 0)
              ret = swr_init(swrCtx);
            if (ret < 0) {
              char errbuf[128];
              av_strerror(ret, errbuf, sizeof(errbuf));
              LOGE("Lazy resampler init failed (ret=%d: %s). Disabling audio.",
                   ret, errbuf);
              if (swrCtx) {
                swr_free(&swrCtx);
                swrCtx = nullptr;
              }
              audioStreamIdx = -1;
              break;
            }
            LOGI("Resampler ready: %dHz fmt=%d %dch -> 44100Hz S16 %dch",
                 activeSampleRate, (int)srcFmt, inChannels, outChannels);
          }

          // \u2705 Use activeSampleRate (guaranteed > 0) \u2014 NOT
          // frame->sample_rate (may be 0)
          uint8_t *outBuffer = nullptr;
          int outSamples = av_rescale_rnd(
              swr_get_delay(swrCtx, activeSampleRate) + frame->nb_samples,
              44100, activeSampleRate, AV_ROUND_UP);

          if (outSamples > 0 &&
              av_samples_alloc(&outBuffer, nullptr, outChannels, outSamples,
                               AV_SAMPLE_FMT_S16, 0) >= 0) {
            int converted =
                swr_convert(swrCtx, &outBuffer, outSamples,
                            (const uint8_t **)frame->data, frame->nb_samples);
            if (audioStream && converted > 0) {
              aaudio_result_t wr = AAudioStream_write(audioStream, outBuffer,
                                                      converted, 100000000);
              if (wr < 0)
                LOGE("AAudio write error: %d", (int)wr);
            }
            av_freep(&outBuffer);
          }
        }
      }
    }
    av_packet_unref(packet);
  }

  if (audioStream) {
    AAudioStream_requestStop(audioStream);
    AAudioStream_close(audioStream);
    AAudioStreamBuilder_delete(builder);
  }
  if (swrCtx)
    swr_free(&swrCtx);

  av_free(buffer);
  av_packet_free(&packet);
  av_frame_free(&frame);
  av_frame_free(&rgbFrame);
  sws_freeContext(swsCtx);
  avcodec_free_context(&videoCodecCtx);
  if (audioCodecCtx)
    avcodec_free_context(&audioCodecCtx);
  avformat_close_input(&formatCtx);
}
