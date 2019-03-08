
# Simple module to find USD.

# On a system with an existing USD /usr/local installation added to the system
# PATH, use of PATHS in find_path incorrectly causes the existing USD
# installation to be found.  As per
# https://cmake.org/cmake/help/v3.4/command/find_path.html
# and
# https://cmake.org/pipermail/cmake/2010-October/040460.html
#
# HINTS get searched before system paths, which produces the desired result.

find_path(PXR_INCLUDE_DIRS
    NAMES
        pxr/pxr.h
    HINTS
        ${USD_ROOT}
        $ENV{USD_ROOT}
    PATH_SUFFIXES
        include
    DOC
        "USD Include directory"
)

find_library(USD_LIBRARY
    NAMES
        usd
    HINTS
        ${USD_ROOT}
        $ENV{USD_ROOT}
    PATH_SUFFIXES
        lib
    DOC
        "USD Librarires directory"
)

get_filename_component(USD_LIBRARY_DIR ${USD_LIBRARY} DIRECTORY)

find_file(USD_GENSCHEMA
    NAMES
        usdGenSchema
    PATHS
        ${USD_ROOT}
        $ENV{USD_ROOT}
    PATH_SUFFIXES
        bin
    DOC
        "USD Gen schema application")

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(USD
    REQUIRED_VARS
        PXR_INCLUDE_DIRS
        USD_LIBRARY_DIR
        USD_GENSCHEMA
)

if (USD_FOUND)
    # Adjust some paths, so we can run usdGenSchemas
    append_path_to_env_var("PYTHONPATH" "${AL_USDMAYA_USD_LOCATION}/lib/python")
    if(WIN32)
        append_path_to_env_var("PATH" "${AL_USDMAYA_USD_LOCATION}/bin;${AL_USDMAYA_USD_LOCATION}/lib")
    endif()
endif()
