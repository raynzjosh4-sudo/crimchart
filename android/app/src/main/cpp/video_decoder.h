#ifndef VIDEO_DECODER_H
#define VIDEO_DECODER_H

#include <android/native_window.h>
#include <string>
#include <thread>
#include <atomic>

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libavutil/time.h>
}

class VideoDecoder {
public:
    VideoDecoder(int id);
    ~VideoDecoder();

    void setWindow(ANativeWindow* window);
    void play(const std::string& url);
    void pause();
    void resume();
    void stop();

    double getPosition();
    double getDuration();

private:
    void decodeLoop();

    int id;
    ANativeWindow* nativeWindow = nullptr;
    std::string url;
    std::atomic<bool> isRunning{false};
    std::atomic<bool> isPaused{false};
    std::atomic<double> currentPosition{0.0};
    std::atomic<double> duration{0.0};
    std::thread* decoderThread = nullptr;
};

#endif
