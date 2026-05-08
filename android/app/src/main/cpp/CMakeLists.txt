# Minimum CMake version required by Android Studio
cmake_minimum_required(VERSION 3.22.1)

project("crimchart_native")

# 1. Tell Android where the FFmpeg directory is
set(FFMPEG_DIR ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg)

# 2. Link the Header files (.h) so media_processor.cpp can read them
include_directories(${FFMPEG_DIR}/include/${ANDROID_ABI})

# 3. Import the Prebuilt FFmpeg Shared Libraries (.so)
# ${ANDROID_ABI} automatically selects the correct folder (arm64-v8a, etc.) based on the phone running the app
add_library(avcodec SHARED IMPORTED)
set_target_properties(avcodec PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libavcodec.so)

add_library(avformat SHARED IMPORTED)
set_target_properties(avformat PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libavformat.so)

add_library(avutil SHARED IMPORTED)
set_target_properties(avutil PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libavutil.so)

add_library(swscale SHARED IMPORTED)
set_target_properties(swscale PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libswscale.so)

add_library(swresample SHARED IMPORTED)
set_target_properties(swresample PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libswresample.so)

add_library(avfilter SHARED IMPORTED)
set_target_properties(avfilter PROPERTIES IMPORTED_LOCATION ${FFMPEG_DIR}/lib/${ANDROID_ABI}/libavfilter.so)

# 4. Build Your Custom C++ Engine
add_library(crimchart_native SHARED media_processor.cpp)

# 5. Find the native Android logging library (so your std::cout prints to the terminal)
find_library(log-lib log)

# 6. Stitch everything together into one ultra-fast libcrimchart_native.so file
target_link_libraries(
    crimchart_native
    avformat
    avcodec
    avfilter   # 👑 UNLOCKS PRO EDITING EFFECTS
    avutil
    swscale
    swresample
    ${log-lib}
)
