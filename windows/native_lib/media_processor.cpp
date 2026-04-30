#include <stdint.h>
#include <iostream>
#include <string>
#include <cstring>

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}

#if defined(_WIN32)
#define FFI_EXPORT __declspec(dllexport)
#else
#define FFI_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

static void log_av_error(const char* ctx, int err) {
    char buf[256];
    av_strerror(err, buf, sizeof(buf));
    std::cerr << "[C++] " << ctx << ": " << buf << std::endl;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1 – ENGINE INIT
// ═══════════════════════════════════════════════════════════════════════════════
extern "C" {

FFI_EXPORT int initialize_media_engine() {
    std::cout << "[C++] FFmpeg: " << av_version_info() << std::endl;
    return 1;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2 – IMAGE COMPRESSION (RGBA bytes → JPEG bytes)
// ═══════════════════════════════════════════════════════════════════════════════

/// Compresses raw RGBA pixel data into JPEG.
/// Returns a malloc'd buffer via out_data / out_size. Caller must call
/// free_native_buffer() when done.
FFI_EXPORT int compress_image_to_jpeg(
    const uint8_t* rgba_bytes,
    int            width,
    int            height,
    int            jpeg_quality,   // 1-100
    uint8_t**      out_data,
    int*           out_size
) {
    if (!rgba_bytes || width <= 0 || height <= 0 || !out_data || !out_size) return -1;

    // ── Find JPEG encoder ─────────────────────────────────────────────────
    const AVCodec* codec = avcodec_find_encoder(AV_CODEC_ID_MJPEG);
    if (!codec) { std::cerr << "[C++] JPEG encoder not found\n"; return -2; }

    AVCodecContext* ctx = avcodec_alloc_context3(codec);
    ctx->pix_fmt       = AV_PIX_FMT_YUVJ420P;
    ctx->width         = width;
    ctx->height        = height;
    ctx->time_base     = {1, 30};
    ctx->flags         = AV_CODEC_FLAG_QSCALE;
    ctx->thread_count  = 8; // Parallelize image JPEG encoding for instant speed
    ctx->thread_type   = FF_THREAD_SLICE | FF_THREAD_FRAME;
    ctx->global_quality = FF_QP2LAMBDA * (int)((100 - jpeg_quality) / 3.4f + 1);

    if (avcodec_open2(ctx, codec, nullptr) < 0) {
        avcodec_free_context(&ctx);
        return -3;
    }

    // ── Convert RGBA → YUVJ420P ───────────────────────────────────────────
    SwsContext* sws = sws_getContext(
        width, height, AV_PIX_FMT_RGBA,
        width, height, AV_PIX_FMT_YUVJ420P,
        SWS_BILINEAR, nullptr, nullptr, nullptr
    );

    AVFrame* yuv = av_frame_alloc();
    yuv->format  = AV_PIX_FMT_YUVJ420P;
    yuv->width   = width;
    yuv->height  = height;
    av_image_alloc(yuv->data, yuv->linesize, width, height, AV_PIX_FMT_YUVJ420P, 32);

    const uint8_t* src[1]  = { rgba_bytes };
    int            src_stride[1] = { width * 4 };
    sws_scale(sws, src, src_stride, 0, height, yuv->data, yuv->linesize);
    sws_freeContext(sws);

    // ── Encode ────────────────────────────────────────────────────────────
    AVPacket* pkt = av_packet_alloc();
    int ret = avcodec_send_frame(ctx, yuv);
    if (ret >= 0) ret = avcodec_receive_packet(ctx, pkt);

    if (ret >= 0) {
        *out_data = (uint8_t*)malloc(pkt->size);
        *out_size = pkt->size;
        memcpy(*out_data, pkt->data, pkt->size);
    } else {
        log_av_error("JPEG encode", ret);
    }

    av_packet_free(&pkt);
    av_freep(&yuv->data[0]);
    av_frame_free(&yuv);
    avcodec_free_context(&ctx);

    return (ret >= 0) ? 0 : -4;
}

/// Must be called by Dart after consuming the buffer from compress_image_to_jpeg.
FFI_EXPORT void free_native_buffer(uint8_t* buf) {
    if (buf) free(buf);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3 – VIDEO METADATA
// ═══════════════════════════════════════════════════════════════════════════════

/// Reads video metadata without decoding frames. Fast O(1) operation.
/// Fills out_duration_sec, out_width, out_height, out_fps.
/// Returns 0 on success.
FFI_EXPORT int get_video_info(
    const char* input_path,
    double*     out_duration_sec,
    int*        out_width,
    int*        out_height,
    double*     out_fps
) {
    if (!input_path) return -1;

    AVFormatContext* fmt_ctx = nullptr;
    int ret = avformat_open_input(&fmt_ctx, input_path, nullptr, nullptr);
    if (ret < 0) { log_av_error("get_video_info open", ret); return -2; }

    avformat_find_stream_info(fmt_ctx, nullptr);

    int vs = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    if (vs < 0) { avformat_close_input(&fmt_ctx); return -3; }

    AVStream* stream = fmt_ctx->streams[vs];

    if (out_duration_sec) {
        *out_duration_sec = (fmt_ctx->duration > 0)
            ? (double)fmt_ctx->duration / AV_TIME_BASE
            : (double)stream->duration * av_q2d(stream->time_base);
    }
    if (out_width)  *out_width  = stream->codecpar->width;
    if (out_height) *out_height = stream->codecpar->height;
    if (out_fps) {
        AVRational r = stream->avg_frame_rate;
        *out_fps = (r.den > 0) ? (double)r.num / r.den : 30.0;
    }

    avformat_close_input(&fmt_ctx);
    return 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4 – THUMBNAIL EXTRACTION (fast key-frame seek)
// ═══════════════════════════════════════════════════════════════════════════════

/// Seeks to time_sec in the video and writes the nearest key frame as JPEG
/// to output_path. Uses AVSEEK_FLAG_BACKWARD for instant key-frame seek.
/// thumb_width = 0 → use original width.
FFI_EXPORT int extract_thumbnail(
    const char* input_path,
    const char* output_path,
    double      time_sec,
    int         thumb_width
) {
    if (!input_path || !output_path) return -1;

    AVFormatContext* fmt_ctx = nullptr;
    if (avformat_open_input(&fmt_ctx, input_path, nullptr, nullptr) < 0) return -2;
    avformat_find_stream_info(fmt_ctx, nullptr);

    int vs = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    if (vs < 0) { avformat_close_input(&fmt_ctx); return -3; }

    AVStream* stream = fmt_ctx->streams[vs];
    const AVCodec* dec = avcodec_find_decoder(stream->codecpar->codec_id);
    AVCodecContext* dec_ctx = avcodec_alloc_context3(dec);
    avcodec_parameters_to_context(dec_ctx, stream->codecpar);
    // Use multiple threads for faster decode
    dec_ctx->thread_count = 4;
    dec_ctx->thread_type  = FF_THREAD_FRAME;
    avcodec_open2(dec_ctx, dec, nullptr);

    // ── Seek to requested time ─────────────────────────────────────────────
    int64_t ts = (int64_t)(time_sec / av_q2d(stream->time_base));
    av_seek_frame(fmt_ctx, vs, ts, AVSEEK_FLAG_BACKWARD);
    avcodec_flush_buffers(dec_ctx);

    // ── Decode until we get a complete frame ──────────────────────────────
    AVPacket* pkt   = av_packet_alloc();
    AVFrame*  frame = av_frame_alloc();
    bool      got   = false;

    while (!got && av_read_frame(fmt_ctx, pkt) >= 0) {
        if (pkt->stream_index != vs) { av_packet_unref(pkt); continue; }
        if (avcodec_send_packet(dec_ctx, pkt) >= 0) {
            if (avcodec_receive_frame(dec_ctx, frame) >= 0) got = true;
        }
        av_packet_unref(pkt);
    }

    int result = -4;
    if (got) {
        // ── Scale to thumb size ─────────────────────────────────────────
        int src_w = frame->width, src_h = frame->height;
        int dst_w = (thumb_width > 0) ? thumb_width : src_w;
        int dst_h = (int)((double)src_h * dst_w / src_w) & ~1; // keep even

        SwsContext* sws = sws_getContext(
            src_w, src_h, (AVPixelFormat)frame->format,
            dst_w, dst_h, AV_PIX_FMT_YUVJ420P,
            SWS_BILINEAR, nullptr, nullptr, nullptr
        );

        AVFrame* yuv = av_frame_alloc();
        yuv->format = AV_PIX_FMT_YUVJ420P;
        yuv->width  = dst_w;
        yuv->height = dst_h;
        av_image_alloc(yuv->data, yuv->linesize, dst_w, dst_h, AV_PIX_FMT_YUVJ420P, 32);
        sws_scale(sws, frame->data, frame->linesize, 0, src_h, yuv->data, yuv->linesize);
        sws_freeContext(sws);

        // ── Encode to JPEG file ─────────────────────────────────────────
        const AVCodec* jpg_enc = avcodec_find_encoder(AV_CODEC_ID_MJPEG);
        AVCodecContext* jpg_ctx = avcodec_alloc_context3(jpg_enc);
        jpg_ctx->pix_fmt     = AV_PIX_FMT_YUVJ420P;
        jpg_ctx->width       = dst_w;
        jpg_ctx->height      = dst_h;
        jpg_ctx->time_base   = {1, 30};
        jpg_ctx->flags       = AV_CODEC_FLAG_QSCALE;
        jpg_ctx->global_quality = FF_QP2LAMBDA * 4; // ~85% quality
        avcodec_open2(jpg_ctx, jpg_enc, nullptr);

        AVPacket* jpg_pkt = av_packet_alloc();
        if (avcodec_send_frame(jpg_ctx, yuv) >= 0 &&
            avcodec_receive_packet(jpg_ctx, jpg_pkt) >= 0) {

            // Write directly to file
            FILE* f = fopen(output_path, "wb");
            if (f) {
                fwrite(jpg_pkt->data, 1, jpg_pkt->size, f);
                fclose(f);
                result = 0;
            }
        }

        av_packet_free(&jpg_pkt);
        avcodec_free_context(&jpg_ctx);
        av_freep(&yuv->data[0]);
        av_frame_free(&yuv);
    }

    av_frame_free(&frame);
    av_packet_free(&pkt);
    avcodec_free_context(&dec_ctx);
    avformat_close_input(&fmt_ctx);

    if (result == 0)
        std::cout << "[C++] thumbnail -> " << output_path << std::endl;
    return result;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5 – PREVIEW STRIP (N evenly-spaced thumbnails for scrub bar)
// ═══════════════════════════════════════════════════════════════════════════════

/// Generates num_frames evenly-spaced thumbnails for a scrub / hover strip.
/// Output files are named: {output_dir}/{index:03d}.jpg  (0-indexed)
/// Returns number of frames successfully written.
FFI_EXPORT int generate_preview_strip(
    const char* input_path,
    const char* output_dir,
    int         num_frames,
    int         thumb_width
) {
    if (!input_path || !output_dir || num_frames <= 0) return -1;

    AVFormatContext* fmt_ctx = nullptr;
    if (avformat_open_input(&fmt_ctx, input_path, nullptr, nullptr) < 0) return -2;
    avformat_find_stream_info(fmt_ctx, nullptr);

    double duration = (fmt_ctx->duration > 0)
        ? (double)fmt_ctx->duration / AV_TIME_BASE : 0.0;

    avformat_close_input(&fmt_ctx);
    if (duration <= 0) return -3;

    int written = 0;
    for (int i = 0; i < num_frames; i++) {
        double t = duration * i / num_frames;
        char path[1024];
        snprintf(path, sizeof(path), "%s/%03d.jpg", output_dir, i);
        if (extract_thumbnail(input_path, path, t, thumb_width) == 0)
            written++;
    }
    std::cout << "[C++] preview strip: " << written << "/" << num_frames << " frames\n";
    return written;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6 – VIDEO COMPRESSION (H.264 + AAC transcode)
// ═══════════════════════════════════════════════════════════════════════════════

FFI_EXPORT int compress_video(const char* input_path, const char* output_path) {
    if (!input_path || !output_path) return -1;
    std::cout << "[C++] compress_video: " << input_path << " -> " << output_path << std::endl;

    AVFormatContext* in_ctx = nullptr;
    int ret = avformat_open_input(&in_ctx, input_path, nullptr, nullptr);
    if (ret < 0) { log_av_error("avformat_open_input", ret); return -2; }
    avformat_find_stream_info(in_ctx, nullptr);

    int vi = av_find_best_stream(in_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    int ai = av_find_best_stream(in_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);

    AVFormatContext* out_ctx = nullptr;
    avformat_alloc_output_context2(&out_ctx, nullptr, nullptr, output_path);

    // ── Video encoder (H.264) ─────────────────────────────────────────────
    AVStream* out_vs = nullptr; AVCodecContext* enc_vc = nullptr;
    if (vi >= 0) {
        AVStream* s = in_ctx->streams[vi];
        const AVCodec* c = avcodec_find_encoder(AV_CODEC_ID_H264);
        out_vs = avformat_new_stream(out_ctx, nullptr);
        enc_vc = avcodec_alloc_context3(c);
        enc_vc->codec_type = AVMEDIA_TYPE_VIDEO;
        enc_vc->width      = s->codecpar->width;
        enc_vc->height     = s->codecpar->height;
        enc_vc->time_base  = {1, 30}; enc_vc->framerate = {30, 1};
        enc_vc->pix_fmt    = AV_PIX_FMT_YUV420P;
        enc_vc->bit_rate   = 150000; // Extreme Data Saver (was 1.5M)
        av_opt_set(enc_vc->priv_data, "preset", "superfast", 0);
        av_opt_set(enc_vc->priv_data, "crf",    "38",        0);
        if (out_ctx->oformat->flags & AVFMT_GLOBALHEADER)
            enc_vc->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        avcodec_open2(enc_vc, c, nullptr);
        avcodec_parameters_from_context(out_vs->codecpar, enc_vc);
        out_vs->time_base = enc_vc->time_base;
    }

    // ── Audio encoder (AAC) ───────────────────────────────────────────────
    AVStream* out_as = nullptr; AVCodecContext* enc_ac = nullptr;
    if (ai >= 0) {
        AVStream* s = in_ctx->streams[ai];
        const AVCodec* c = avcodec_find_encoder(AV_CODEC_ID_AAC);
        out_as = avformat_new_stream(out_ctx, nullptr);
        enc_ac = avcodec_alloc_context3(c);
        enc_ac->codec_type  = AVMEDIA_TYPE_AUDIO;
        enc_ac->sample_rate = s->codecpar->sample_rate;
        enc_ac->bit_rate    = 24000; // 24k Audio for Extreme Data Saver
        enc_ac->ch_layout   = AV_CHANNEL_LAYOUT_MONO;
        enc_ac->sample_fmt  = AV_SAMPLE_FMT_FLTP;
        enc_ac->time_base   = {1, enc_ac->sample_rate};
        if (out_ctx->oformat->flags & AVFMT_GLOBALHEADER)
            enc_ac->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        avcodec_open2(enc_ac, c, nullptr);
        avcodec_parameters_from_context(out_as->codecpar, enc_ac);
        out_as->time_base = enc_ac->time_base;
    }

    avio_open(&out_ctx->pb, output_path, AVIO_FLAG_WRITE);
    avformat_write_header(out_ctx, nullptr);

    auto open_dec = [&](int idx) -> AVCodecContext* {
        if (idx < 0) return nullptr;
        AVStream* s = in_ctx->streams[idx];
        const AVCodec* d = avcodec_find_decoder(s->codecpar->codec_id);
        AVCodecContext* dc = avcodec_alloc_context3(d);
        avcodec_parameters_to_context(dc, s->codecpar);
        dc->thread_count = 4;
        avcodec_open2(dc, d, nullptr);
        return dc;
    };
    AVCodecContext* dec_vc = open_dec(vi);
    AVCodecContext* dec_ac = open_dec(ai);

    AVPacket* pkt = av_packet_alloc();
    AVFrame* frm  = av_frame_alloc();
    AVPacket* epkt = av_packet_alloc();

    while (av_read_frame(in_ctx, pkt) >= 0) {
        bool isV = pkt->stream_index == vi;
        bool isA = pkt->stream_index == ai;
        if (!isV && !isA) { av_packet_unref(pkt); continue; }

        AVCodecContext* dc  = isV ? dec_vc  : dec_ac;
        AVCodecContext* ec  = isV ? enc_vc  : enc_ac;
        AVStream*       ost = isV ? out_vs  : out_as;
        AVStream*       ist = in_ctx->streams[pkt->stream_index];
        if (!dc || !ec || !ost) { av_packet_unref(pkt); continue; }

        if (avcodec_send_packet(dc, pkt) >= 0) {
            while (avcodec_receive_frame(dc, frm) >= 0) {
                frm->pts = av_rescale_q(frm->pts, ist->time_base, ec->time_base);
                if (avcodec_send_frame(ec, frm) >= 0) {
                    while (avcodec_receive_packet(ec, epkt) >= 0) {
                        av_packet_rescale_ts(epkt, ec->time_base, ost->time_base);
                        epkt->stream_index = ost->index;
                        av_interleaved_write_frame(out_ctx, epkt);
                        av_packet_unref(epkt);
                    }
                }
                av_frame_unref(frm);
            }
        }
        av_packet_unref(pkt);
    }

    auto flush = [&](AVCodecContext* ec, AVStream* st) {
        if (!ec || !st) return;
        avcodec_send_frame(ec, nullptr);
        while (avcodec_receive_packet(ec, epkt) >= 0) {
            av_packet_rescale_ts(epkt, ec->time_base, st->time_base);
            epkt->stream_index = st->index;
            av_interleaved_write_frame(out_ctx, epkt);
            av_packet_unref(epkt);
        }
    };
    flush(enc_vc, out_vs);
    flush(enc_ac, out_as);
    av_write_trailer(out_ctx);

    av_frame_free(&frm); av_packet_free(&pkt); av_packet_free(&epkt);
    avcodec_free_context(&dec_vc); avcodec_free_context(&dec_ac);
    avcodec_free_context(&enc_vc); avcodec_free_context(&enc_ac);
    avio_closep(&out_ctx->pb);
    avformat_free_context(out_ctx);
    avformat_close_input(&in_ctx);

    std::cout << "[C++] compress_video done -> " << output_path << std::endl;
    return 0;
}

FFI_EXPORT int compress_audio(const char* input_path, const char* output_path, int target_bitrate) {
    if (!input_path || !output_path) return -1;
    std::cout << "[C++] compress_audio: " << input_path << " -> " << output_path << " (" << target_bitrate << "bps)\n";

    AVFormatContext* in_ctx = nullptr;
    if (avformat_open_input(&in_ctx, input_path, nullptr, nullptr) < 0) return -2;
    avformat_find_stream_info(in_ctx, nullptr);

    int ai = av_find_best_stream(in_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);
    if (ai < 0) { avformat_close_input(&in_ctx); return -3; }

    AVFormatContext* out_ctx = nullptr;
    avformat_alloc_output_context2(&out_ctx, nullptr, nullptr, output_path);

    AVStream* out_as = nullptr; 
    AVCodecContext* enc_ac = nullptr;
    AVStream* in_s = in_ctx->streams[ai];

    const AVCodec* c = avcodec_find_encoder(AV_CODEC_ID_AAC);
    out_as = avformat_new_stream(out_ctx, nullptr);
    enc_ac = avcodec_alloc_context3(c);

    enc_ac->codec_type  = AVMEDIA_TYPE_AUDIO;
    enc_ac->sample_rate = in_s->codecpar->sample_rate;
    enc_ac->bit_rate    = target_bitrate;
    enc_ac->ch_layout   = AV_CHANNEL_LAYOUT_MONO; // Force mono for extreme savings
    enc_ac->sample_fmt  = AV_SAMPLE_FMT_FLTP;
    enc_ac->time_base   = {1, enc_ac->sample_rate};

    if (out_ctx->oformat->flags & AVFMT_GLOBALHEADER)
        enc_ac->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;

    if (avcodec_open2(enc_ac, c, nullptr) < 0) {
        avcodec_free_context(&enc_ac);
        avformat_free_context(out_ctx);
        avformat_close_input(&in_ctx);
        return -4;
    }

    avcodec_parameters_from_context(out_as->codecpar, enc_ac);
    out_as->time_base = enc_ac->time_base;

    if (avio_open(&out_ctx->pb, output_path, AVIO_FLAG_WRITE) < 0) {
        avcodec_free_context(&enc_ac);
        avformat_free_context(out_ctx);
        avformat_close_input(&in_ctx);
        return -5;
    }

    avformat_write_header(out_ctx, nullptr);

    const AVCodec* d = avcodec_find_decoder(in_s->codecpar->codec_id);
    AVCodecContext* dec_ac = avcodec_alloc_context3(d);
    avcodec_parameters_to_context(dec_ac, in_s->codecpar);
    avcodec_open2(dec_ac, d, nullptr);

    AVPacket* pkt = av_packet_alloc();
    AVFrame* frm  = av_frame_alloc();
    AVPacket* epkt = av_packet_alloc();

    while (av_read_frame(in_ctx, pkt) >= 0) {
        if (pkt->stream_index == ai) {
            if (avcodec_send_packet(dec_ac, pkt) >= 0) {
                while (avcodec_receive_frame(dec_ac, frm) >= 0) {
                    frm->pts = av_rescale_q(frm->pts, in_s->time_base, enc_ac->time_base);
                    if (avcodec_send_frame(enc_ac, frm) >= 0) {
                        while (avcodec_receive_packet(enc_ac, epkt) >= 0) {
                            av_packet_rescale_ts(epkt, enc_ac->time_base, out_as->time_base);
                            epkt->stream_index = out_as->index;
                            av_interleaved_write_frame(out_ctx, epkt);
                            av_packet_unref(epkt);
                        }
                    }
                }
            }
        }
        av_packet_unref(pkt);
    }

    // Flush encoder
    avcodec_send_frame(enc_ac, nullptr);
    while (avcodec_receive_packet(enc_ac, epkt) >= 0) {
        av_packet_rescale_ts(epkt, enc_ac->time_base, out_as->time_base);
        epkt->stream_index = out_as->index;
        av_interleaved_write_frame(out_ctx, epkt);
        av_packet_unref(epkt);
    }

    av_write_trailer(out_ctx);

    av_frame_free(&frm); av_packet_free(&pkt); av_packet_free(&epkt);
    avcodec_free_context(&dec_ac); avcodec_free_context(&enc_ac);
    avio_closep(&out_ctx->pb);
    avformat_free_context(out_ctx);
    avformat_close_input(&in_ctx);

    std::cout << "[C++] compress_audio done -> " << output_path << std::endl;
    return 0;
}

} // extern "C"
