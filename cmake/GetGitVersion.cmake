if (NOT DEFINED GIT_EXECUTABLE)
    message(FATAL_ERROR "Git executable is not set: GIT_EXECUTABLE=${GIT_EXECUTABLE}")
elseif (NOT DEFINED CGV_TOPDIR)
    message(FATAL_ERROR "Top level directory of the Git repo is not set: CGV_TOPDIR=${CGV_TOPDIR}")
elseif (NOT DEFINED CGV_SOURCE_DIR)
    message(FATAL_ERROR "c_git_version source directory is not set: CGV_SOURCE_DIR=${CGV_SOURCE_DIR}")
elseif (NOT DEFINED CGV_BUILD_DIR)
    message(FATAL_ERROR "Build directory is not set: CGV_BUILD_DIR=${CGV_BUILD_DIR}")
endif()

execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --always --tags --dirty=-modified
    WORKING_DIRECTORY "${CGV_TOPDIR}"
    OUTPUT_VARIABLE CGV_VERSION
    RESULT_VARIABLE CGV_VERSION_ERR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" rev-parse HEAD
    WORKING_DIRECTORY "${CGV_TOPDIR}"
    OUTPUT_VARIABLE CGV_HASH
    RESULT_VARIABLE CGV_HASH_ERR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" rev-parse --abbrev-ref HEAD
    WORKING_DIRECTORY "${CGV_TOPDIR}"
    OUTPUT_VARIABLE CGV_BRANCH
    RESULT_VARIABLE CGV_BRANCH_ERR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" submodule status
    WORKING_DIRECTORY "${CGV_TOPDIR}"
    OUTPUT_VARIABLE CGV_SUBMODULES
    RESULT_VARIABLE CGV_SUBMODULES_ERR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)


message(STATUS "Version: ${CGV_VERSION}  (err=${CGV_VERSION_ERR})")
message(STATUS "Hash: ${CGV_HASH}  (err=${CGV_HASH_ERR})")
message(STATUS "Branch: ${CGV_BRANCH}  (err=${CGV_BRANCH_ERR})")
message(STATUS "Submodules (err=${CGV_SUBMODULES_ERR}):\n${CGV_SUBMODULES}")

string(REPLACE ";" "" CGV_SUBMODULES "${CGV_SUBMODULES}")
string(REPLACE "\n" ";" CGV_SUBMODULES "${CGV_SUBMODULES}")
set(CGV_SUBMODULES_STATUS "\"\"")
foreach(I IN LISTS CGV_SUBMODULES)
    string(STRIP "${I}" I)
    string(APPEND CGV_SUBMODULES_STATUS " \\\n\"${I}\\n\"")
endforeach()

if (${CGV_VERSION_ERR} OR ${CGV_HASH_ERR} OR ${CGV_BRANCH_ERR} OR ${CGV_SUBMODULES_ERR})
    message(FATAL_ERROR "Failed to read: version=${CGV_VERSION_ERR}, hash=${CGV_HASH_ERR}, branch=${CGV_BRANCH_ERR}, submodules=${CGV_SUBMODULES_ERR}")
endif()

configure_file("${CGV_SOURCE_DIR}/src/c_git_version.c.in" "${CGV_BUILD_DIR}/c_git_version.c" @ONLY)
