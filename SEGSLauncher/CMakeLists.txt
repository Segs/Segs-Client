cmake_minimum_required(VERSION 3.14)


project(SEGSLauncher LANGUAGES CXX)


set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 COMPONENTS Core Quick Multimedia Network REQUIRED)
set(CMAKE_DEBUG_POSTFIX "d")


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
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia Qt6::Network jcon_IMP)


#message("Copying required Qt libraries and binaries to output directory....")
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\bin $<TARGET_FILE_DIR:SEGSLauncher>)
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\plugins $<TARGET_FILE_DIR:SEGSLauncher>)
#add_custom_command(TARGET SEGSLauncher POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_PREFIX_PATH}\\qml $<TARGET_FILE_DIR:SEGSLauncher>)

