if(MINGW AND CMAKE_CROSSCOMPILING)
    set(CONFIGURE_COMMAND ./configure --host=${HOST} --target=${HOST} --disable-shared --prefix=${CMAKE_BINARY_DIR}/external/dist --without-libusb CFLAGS=-g\ -O2\ -fstack-protector CXXFLAGS=-g\ -O2\ -fstack-protector)
else(MINGW AND CMAKE_CROSSCOMPILING)
if(APPLE)
if(BUILD_OSX_UNIVERSAL)
    set(CONFIGURE_COMMAND ./configure --disable-shared --prefix=${CMAKE_BINARY_DIR}/external/dist --without-libusb CFLAGS=-g\ -O2\ -mmacosx-version-min=10.9\ -arch\ x86_64\ -arch\ arm64 CXXFLAGS=-g\ -O2\ -mmacosx-version-min=10.9\ -arch\ x86_64\ -arch\ arm64)
else()
    set(CONFIGURE_COMMAND ./configure --disable-shared --prefix=${CMAKE_BINARY_DIR}/external/dist --without-libusb CFLAGS=-g\ -O2\ -mmacosx-version-min=10.9 CXXFLAGS=-g\ -O2\ -mmacosx-version-min=10.9)
endif(BUILD_OSX_UNIVERSAL)
else()
    set(CONFIGURE_COMMAND ./configure --disable-shared --prefix=${CMAKE_BINARY_DIR}/external/dist --without-libusb CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER})
endif()
endif(MINGW AND CMAKE_CROSSCOMPILING)

include(ExternalProject)
ExternalProject_Add(hamlib
    URL https://github.com/Hamlib/Hamlib/archive/refs/heads/Hamlib-4.5.5.zip
    BUILD_IN_SOURCE 1
    INSTALL_DIR external/dist
    CONFIGURE_COMMAND ./bootstrap && ${CONFIGURE_COMMAND}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
)

include_directories(${CMAKE_BINARY_DIR}/external/dist/include)
list(APPEND FREEDV_LINK_LIBS ${CMAKE_BINARY_DIR}/external/dist/lib/libhamlib.a)
list(APPEND FREEDV_STATIC_DEPS hamlib)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector")

