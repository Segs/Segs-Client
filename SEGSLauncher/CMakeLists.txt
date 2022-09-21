cmake_minimum_required(VERSION 3.1)


project(SEGSLauncher LANGUAGES CXX)


set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
#set(CMAKE_AUTOUIC ON)

find_package(Qt5 COMPONENTS Core Quick Multimedia REQUIRED)
set(CMAKE_DEBUG_POSTFIX "d")

#include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})
#add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")

set(SEGSLAUNCHER_SOURCES
    main.cpp
    Launcher.cpp
    Launcher.h
    LauncherSetup.cpp
    LauncherSetup.h
    Worker.cpp
    Worker.h
    qml.qrc
    )

add_executable(${PROJECT_NAME} WIN32 ${SEGSLAUNCHER_SOURCES})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::Multimedia jcon_IMP)


#message("Copying required Qt libraries and binaries to output directory....")
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\bin $<TARGET_FILE_DIR:SEGSLauncher>)
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\plugins $<TARGET_FILE_DIR:SEGSLauncher>)
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\qml $<TARGET_FILE_DIR:SEGSLauncher>)

