find_path(
    UV_INCLUDE_DIR
    NAMES uv.h
    PATHS "${XMRIG_DEPS}" ENV "XMRIG_DEPS"
    PATH_SUFFIXES "include"
    NO_DEFAULT_PATH
)

find_path(UV_INCLUDE_DIR NAMES uv.h)

find_library(
    UV_LIBRARY
    NAMES libuv.a uv libuv
    PATHS "${XMRIG_DEPS}" ENV "XMRIG_DEPS"
    PATH_SUFFIXES "lib"
    NO_DEFAULT_PATH
)

find_library(UV_LIBRARY NAMES libuv.a uv libuv)

if (UV_INCLUDE_DIR AND EXISTS "${UV_INCLUDE_DIR}/uv/version.h")
    file(STRINGS "${UV_INCLUDE_DIR}/uv/version.h" UV_VERSION_MAJOR_LINE REGEX "^#define[	 ]+UV_VERSION_MAJOR[	 ]+[0-9]+")
    file(STRINGS "${UV_INCLUDE_DIR}/uv/version.h" UV_VERSION_MINOR_LINE REGEX "^#define[	 ]+UV_VERSION_MINOR[	 ]+[0-9]+")
    file(STRINGS "${UV_INCLUDE_DIR}/uv/version.h" UV_VERSION_PATCH_LINE REGEX "^#define[	 ]+UV_VERSION_PATCH[	 ]+[0-9]+")

    if (UV_VERSION_MAJOR_LINE AND UV_VERSION_MINOR_LINE AND UV_VERSION_PATCH_LINE)
        string(REGEX REPLACE ".*UV_VERSION_MAJOR[	 ]+([0-9]+).*" "\\1" UV_VERSION_MAJOR "${UV_VERSION_MAJOR_LINE}")
        string(REGEX REPLACE ".*UV_VERSION_MINOR[	 ]+([0-9]+).*" "\\1" UV_VERSION_MINOR "${UV_VERSION_MINOR_LINE}")
        string(REGEX REPLACE ".*UV_VERSION_PATCH[	 ]+([0-9]+).*" "\\1" UV_VERSION_PATCH "${UV_VERSION_PATCH_LINE}")
        set(UV_VERSION "${UV_VERSION_MAJOR}.${UV_VERSION_MINOR}.${UV_VERSION_PATCH}")
    endif()
endif()

if (WIN32 AND WITH_WIN7_COMPAT AND UV_VERSION AND UV_VERSION VERSION_GREATER_EQUAL "1.45.0")
    message(FATAL_ERROR "libuv ${UV_VERSION} is not suitable for Windows 7 SP1 builds. Use libuv 1.44.2 or older, or configure with -DWITH_WIN7_COMPAT=OFF.")
endif()

set(UV_LIBRARIES ${UV_LIBRARY})
set(UV_INCLUDE_DIRS ${UV_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(UV REQUIRED_VARS UV_LIBRARY UV_INCLUDE_DIR VERSION_VAR UV_VERSION)
