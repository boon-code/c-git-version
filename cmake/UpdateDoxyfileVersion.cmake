if (NOT DEFINED GIT_EXECUTABLE)
    message(FATAL_ERROR "Git executable is not set: GIT_EXECUTABLE=${GIT_EXECUTABLE}")
elseif (NOT DEFINED CGV_TOPDIR)
    message(FATAL_ERROR "Top level directory of the Git repo is not set: CGV_TOPDIR=${CGV_TOPDIR}")
elseif (NOT DEFINED CGV_DOXYFILE)
    message(FATAL_ERROR "Generated Doxyfile is not set: CGV_DOXYFILE=${CGV_DOXYFILE}")
endif()

message(DEBUG "UpdateDoxyfileVersion: doxyfile=${CGV_DOXYFILE} topdir=${CGV_TOPDIR}")

execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --always --tags --dirty=-modified
    WORKING_DIRECTORY "${CGV_TOPDIR}"
    OUTPUT_VARIABLE CGV_VERSION
    RESULT_VARIABLE CGV_VERSION_ERR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

message(STATUS "Version in Doxyfile: ${CGV_VERSION}  (err=${CGV_VERSION_ERR})")

if (${CGV_VERSION_ERR})
    message(FATAL_ERROR "Failed to read: version=${CGV_VERSION_ERR}")
endif()

file(READ "${CGV_DOXYFILE}" content)
string(REGEX REPLACE "PROJECT_NUMBER[^\n]*\n" "PROJECT_NUMBER = \"${CGV_VERSION}\"\n" modified_content ${content})

if (NOT content STREQUAL modified_content)
    file(WRITE "${CGV_DOXYFILE}" "${modified_content}")
    message(DEBUG "Updated ${CGV_DOXYFILE} version=${CGV_VERSION}")
else()
    message(DEBUG "${CGV_DOXYFILE} is already up to date")
endif()
