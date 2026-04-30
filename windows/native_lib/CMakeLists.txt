cmake_minimum_required(VERSION 3.14)
project(crimchat_native LANGUAGES CXX)

# ── FFmpeg paths ───────────────────────────────────────────────────────────────
set(FFMPEG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../ffmpeg/ffmpeg-n7.1-latest-win64-gpl-shared-7.1")
set(FFMPEG_INCLUDE_DIR "${FFMPEG_DIR}/include")
set(FFMPEG_LIB_DIR     "${FFMPEG_DIR}/lib")
set(FFMPEG_BIN_DIR     "${FFMPEG_DIR}/bin")

# ── Build our shared library ───────────────────────────────────────────────────
add_library(crimchat_native SHARED media_processor.cpp)
target_compile_features(crimchat_native PUBLIC cxx_std_17)

# Include FFmpeg headers
target_include_directories(crimchat_native PRIVATE "${FFMPEG_INCLUDE_DIR}")

# Link against FFmpeg import libraries (.lib files on Windows)
target_link_libraries(crimchat_native PRIVATE
  "${FFMPEG_LIB_DIR}/avcodec.lib"
  "${FFMPEG_LIB_DIR}/avformat.lib"
  "${FFMPEG_LIB_DIR}/avutil.lib"
  "${FFMPEG_LIB_DIR}/swresample.lib"
  "${FFMPEG_LIB_DIR}/swscale.lib"
)

# ── Output directories ─────────────────────────────────────────────────────────
set_target_properties(crimchat_native PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY         "${CMAKE_BINARY_DIR}/runner"
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_BINARY_DIR}/runner/Debug"
  RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/runner/Release"
  RUNTIME_OUTPUT_DIRECTORY_PROFILE "${CMAKE_BINARY_DIR}/runner/Profile"
)

# ── Copy FFmpeg DLLs next to the executable at build time ─────────────────────
set(FFMPEG_DLLS
  "${FFMPEG_BIN_DIR}/avcodec-61.dll"
  "${FFMPEG_BIN_DIR}/avformat-61.dll"
  "${FFMPEG_BIN_DIR}/avutil-59.dll"
  "${FFMPEG_BIN_DIR}/swresample-5.dll"
  "${FFMPEG_BIN_DIR}/swscale-8.dll"
  "${FFMPEG_BIN_DIR}/avdevice-61.dll"
  "${FFMPEG_BIN_DIR}/avfilter-10.dll"
)

foreach(DLL ${FFMPEG_DLLS})
  add_custom_command(TARGET crimchat_native POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${DLL}"
      "$<TARGET_FILE_DIR:crimchat_native>"
    COMMENT "Copying ${DLL}"
  )
endforeach()
