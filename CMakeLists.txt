cmake_minimum_required(VERSION 3.21)
project(QtVncApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(qt_vnc_app
    src/main.cpp
)

set_source_files_properties(src/qml/Main.qml PROPERTIES QT_RESOURCE_ALIAS Main.qml)

qt_add_qml_module(qt_vnc_app
    URI QtVncApp
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    QML_FILES
        src/qml/Main.qml
)

target_link_libraries(qt_vnc_app PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick)
