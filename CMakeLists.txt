cmake_minimum_required(VERSION 3.2) 

Project(Storage VERSION 1.0.0 LANGUAGES OBJCXX)

set(CMAKE_MACOSX_BUNDLE YES)
set(CMAKE_CXX_STANDARD 17)

add_executable("${PROJECT_NAME}" MACOSX_BUNDLE main.mm)

set_target_properties("${PROJECT_NAME}" PROPERTIES
  MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}"
  MACOSX_BUNDLE_GUI_IDENTIFIER "com.harshil.storage"
  MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"
  MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist")


target_link_libraries("${PROJECT_NAME}" "-framework Cocoa")
