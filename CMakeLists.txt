cmake_minimum_required(VERSION 3.16)

project(Project_Rectangle_v2 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)#музыка
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appProject_Rectangle_v2
    main.cpp

)
qt_add_qml_module(appProject_Rectangle_v2
    URI Project_Rectangle_v2
    VERSION 1.0
    QML_FILES
        Main.qml
        Main_Menu.qml
        Levels.qml
        Level_1.qml
        RESOURCES
        images/background.png
        images/background_level_1.png
        images/background_levels.png
        music/coin.wav
SOURCES level_1.cpp level_1.h
RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
RESOURCES android/AndroidManifest.xml
SOURCES
QML_FILES Settings.qml
SOURCES settings.h settings.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appProject_Rectangle_v2 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appProject_Rectangle_v2
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/android"
)

target_link_libraries(appProject_Rectangle_v2
    PRIVATE Qt6::Quick
            Qt6::Core
            Qt6::Multimedia#музыка
)
target_link_libraries(appProject_Rectangle_v2 PRIVATE Qt6::Core)
target_link_libraries(appProject_Rectangle_v2 PRIVATE Qt6::Core)
include(GNUInstallDirs)
install(TARGETS appProject_Rectangle_v2
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
