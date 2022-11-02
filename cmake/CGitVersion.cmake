cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

set(_C_GIT_VERSION_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")


function(cgv_add_subdirectory)
    add_subdirectory("${_C_GIT_VERSION_CMAKE_DIR}/..")
endfunction()


function(cgv_doxygen_add_version_hook doxygenTarget)
    set(_hookname "doxygen_version_hook.${doxygenTarget}")
    set(_doxy_tpl "${CMAKE_BINARY_DIR}/Doxyfile.${doxygenTarget}")

    if (NOT DOXYGEN_FOUND)
        message(WARNING "Doxygen was not found")
    endif()

    if (NOT TARGET ${doxygenTarget})
        message(FATAL_ERROR "${doxygenTarget} is not a defined target")
    endif()

    if (NOT TARGET c_git_version_check)
        message(FATAL_ERROR "Missing target c_git_version_ceck, maybe c-git-version wasn't added (add_subdirectory)")
    endif()

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

    message(STATUS "Add hook to ${doxygenTarget}: name=${_hookname} doxyfile=${_doxy_tpl} topdir=${CMAKE_SOURCE_DIR}")

    unset(_hookname)
    unset(_doxy_tpl)
endfunction()
