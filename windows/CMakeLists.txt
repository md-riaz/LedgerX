cmake_minimum_required(VERSION 3.14)
project(ledgerx LANGUAGES CXX)

set(BINARY_NAME "ledgerx")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(flutter)

add_executable(${BINARY_NAME} WIN32
  "runner/main.cpp"
  "runner/flutter_window.cpp"
  "runner/utils.cpp"
  "runner/win32_window.cpp"
  "runner/Runner.rc"
  "runner/runner.exe.manifest"
)

target_compile_definitions(${BINARY_NAME} PRIVATE "UNICODE" "_UNICODE")

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION ".")
install(FILES $<TARGET_FILE:flutter_wrapper_app> DESTINATION "." COMPONENT Runtime)

install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/flutter/" DESTINATION "." COMPONENT Runtime)
