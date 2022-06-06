cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

find_package(Git)

set_source_files_properties ("${CMAKE_CURRENT_BINARY_DIR}/c_git_version.c" PROPERTIES GENERATED TRUE)
add_library(c_git_version STATIC "${CMAKE_CURRENT_BINARY_DIR}/c_git_version.c")
target_include_directories(c_git_version PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/inc")

add_custom_target(c_git_version_check
    COMMAND 
        "${CMAKE_COMMAND}"
            -D GIT_EXECUTABLE:string="${GIT_EXECUTABLE}"
            -D CGV_TOPDIR:string="${PROJECT_SOURCE_DIR}"
            -D CGV_SOURCE_DIR:string="${CMAKE_CURRENT_SOURCE_DIR}"
            -D CGV_BUILD_DIR:string="${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/GetGitVersion.cmake"
    COMMENT "Check Git version"
)

add_dependencies(c_git_version c_git_version_check)
