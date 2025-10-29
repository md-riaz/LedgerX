cmake_minimum_required(VERSION 3.10)
project(runner LANGUAGES CXX)

set(BINARY_NAME "ledgerx")
set(APPLICATION_ID "com.ledgerx.app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(flutter)

include(ExternalProject)

add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
)

target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

set_target_properties(${BINARY_NAME} PROPERTIES
  INSTALL_RPATH "$ORIGIN/lib"
)

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  BUNDLE DESTINATION "${CMAKE_INSTALL_PREFIX}")

install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/flutter_assets"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/data")

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
