
#work around if CMAKE_CURRENT_FUNCTION_LIST_DIR is not
#available (CMake 3.17)
set(_C_GIT_VERSION_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")


function(add_doxygen_version_hook doxygenTarget)
    set(_hookname "doxygen_version_hook.${doxygenTarget}")
    set(_doxy_tpl "${CMAKE_BINARY_DIR}/Doxyfile.${doxygenTarget}")

    add_custom_target("${_hookname}"
        COMMAND "${CMAKE_COMMAND}"
            -D GIT_EXECUTABLE:string="${GIT_EXECUTABLE}"
            -D CGV_TOPDIR:string="${CMAKE_SOURCE_DIR}"
            -D CGV_DOXYFILE:string="${_doxy_tpl}"
            -P "${_C_GIT_VERSION_CMAKE_DIR}/UpdateDoxyfileVersion.cmake"
        COMMENT "Doxygen version hook ${doxygenTarget}"
    )

    add_dependencies(${doxygenTarget} ${_hookname})
    add_dependencies(${_hookname} c_git_version_check)

    message(DEBUG "Add hook to ${doxygenTarget}: name=${_hookname} doxyfile=${_doxy_tpl} topdir=${CMAKE_SOURCE_DIR}")

    unset(_hookname)
    unset(_doxy_tpl)
endfunction()
