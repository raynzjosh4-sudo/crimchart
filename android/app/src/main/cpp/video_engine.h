#ifndef VIDEO_ENGINE_H
#define VIDEO_ENGINE_H

#include <stdint.h>

// Export macros for Windows
#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Initialize the video engine cache and thread pools
EXPORT int32_t ve_init_engine();

// Ping test to verify FFI connection is alive
EXPORT int32_t ve_ping(int32_t val);

// Start pre-fetching a video segment
EXPORT int32_t ve_prefetch_video(const char* url);

#ifdef __cplusplus
}
#endif

#endif // VIDEO_ENGINE_H
