#include <jni.h>
#include <android/native_window_jni.h>
#include <android/native_window.h>
#include <iostream>
#include <map>

// Include our core engine header
#include "video_engine.h"
#include "video_decoder.h"

extern "C" {
#include <libavcodec/jni.h>
}

std::map<int, VideoDecoder*> decoders;

extern "C" JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    av_jni_set_java_vm(vm, nullptr);
    return JNI_VERSION_1_6;
}

extern "C" {
    // FFI callable endpoint for Dart to play a video on a texture
    int32_t ve_play_video(int32_t textureId, const char* url) {
        if (decoders.find(textureId) != decoders.end()) {
            decoders[textureId]->play(std::string(url));
            return 1; // Success
        }
        return 0; // Failure
    }

    int32_t ve_stop_video(int32_t textureId) {
        if (decoders.find(textureId) != decoders.end()) {
            decoders[textureId]->stop();
            return 1;
        }
        return 0;
    }

    int32_t ve_dispose_video(int32_t textureId) {
        if (decoders.find(textureId) != decoders.end()) {
            delete decoders[textureId];
            decoders.erase(textureId);
            return 1;
        }
        return 0;
    }

    int32_t ve_pause_video(int32_t textureId) {
        if (decoders.find(textureId) != decoders.end()) {
            decoders[textureId]->pause();
            return 1;
        }
        return 0;
    }

    int32_t ve_resume_video(int32_t textureId) {
        if (decoders.find(textureId) != decoders.end()) {
            decoders[textureId]->resume();
            return 1;
        }
        return 0;
    }
}

extern "C" JNIEXPORT void JNICALL
Java_com_crimchart_app_MainActivity_initVideoEngineSurface(
    JNIEnv* env,
    jobject /* this */,
    jlong textureId,
    jobject surface) {
    
    // Convert the Java Surface object to an Android Native Window
    ANativeWindow* window = ANativeWindow_fromSurface(env, surface);
    
    if (window != nullptr) {
        std::cout << "[VideoEngine JNI] Successfully extracted ANativeWindow for texture " << textureId << std::endl;
        
        // Initialize the Video Decoder for this Texture
        if (decoders.find(textureId) == decoders.end()) {
            decoders[textureId] = new VideoDecoder(textureId);
        }
        decoders[textureId]->setWindow(window);
        
    } else {
        std::cout << "[VideoEngine JNI] FAILED to extract ANativeWindow" << std::endl;
    }
}
