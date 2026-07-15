#!/bin/sh
set -e

# (C) copyright 2025 Chris Olson AC9KH
# Builds js8lib and optionally Qt6 for JS8Call on MacOS (Universal: ARM64 + x86_64)

# --- Variables ---
LIB_VERSION="4.0"
QT_VERSION="6.11.1"
HAMLIB_TAG="4.7.2"
MACOS_MIN="14.0"

# Target dual architectures
UNIVERSAL_FLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=${MACOS_MIN}"

QT_TAG="v${QT_VERSION}"
PREFIX="/usr/local/js8lib"
SUBMODULES=$(pwd)

clear
echo "--------------------------------------------------------------------"
echo "   Building universal js8lib ${LIB_VERSION} for macOS (ARM64 & x86_64)..."
echo "--------------------------------------------------------------------"
sleep 2

if [ ! -d "${PREFIX}" ]; then
    echo "Directory structure does not exist!"
    echo "${PREFIX} must be created and be writeable by your username before running the build."
    echo "See README.md"
    echo "Exiting..."
    exit 1
fi

rm -rf "${PREFIX:?PREFIX is not set or empty}"/*

cd "${SUBMODULES}" && git submodule update --init --recursive

####### Build libusb #######
cd "${SUBMODULES}/libusb" || exit 1
./bootstrap.sh
./configure CFLAGS="${UNIVERSAL_FLAGS}" \
            CXXFLAGS="${UNIVERSAL_FLAGS}" \
            LDFLAGS="${UNIVERSAL_FLAGS}" \
            --prefix="${PREFIX}"
            
make -j"${NCPU}" && make install
make clean

echo "--------------------------------------------------------------------"
echo "         libusb-v1.0.29 build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build Hamlib #######
cd "${SUBMODULES}/Hamlib" || exit 1
git checkout "${HAMLIB_TAG}"

./bootstrap
./configure CFLAGS="${UNIVERSAL_FLAGS}" \
            CXXFLAGS="${UNIVERSAL_FLAGS}" \
            LDFLAGS="${UNIVERSAL_FLAGS}" \
            --prefix="${PREFIX}"

make -j"${NCPU}" && make install
make clean

echo "--------------------------------------------------------------------"
echo "         Hamlib ${HAMLIB_TAG} build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build fftw #######
cd "${SUBMODULES}/fftw" || exit 1

./configure CFLAGS="${UNIVERSAL_FLAGS}" \
            CXXFLAGS="${UNIVERSAL_FLAGS}" \
            LDFLAGS="${UNIVERSAL_FLAGS}" \
            --prefix="${PREFIX}" \
            --enable-single --enable-threads
            
make -j"${NCPU}" && make install
make clean

echo "--------------------------------------------------------------------"
echo "         fftw-v3.3.10 build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build boost (headers only) #######
# Header-only libraries are architecture-independent; no changes needed here.
cd "${SUBMODULES}/boost" || exit 1
./bootstrap.sh --prefix="${PREFIX}"
./b2 install --with-headers

echo "--------------------------------------------------------------------"
echo "         boost-v1.88.0 header copy successful........."
echo "--------------------------------------------------------------------"
sleep 3

read -p "Build Qt ${QT_VERSION} from git sources? Select No if using external Qt build: Yes(y) / No(n): " qt

if [ "$qt" = "y" ]; then
####### Build Qt6 #######
    cd "${SUBMODULES}"
    git clone https://github.com/qt/qt5.git Qt6
    cd "${SUBMODULES}/Qt6"
    git checkout "${QT_TAG}"
    ./init-repository --module-subset=qtbase,qtshadertools,qtmultimedia,qtimageformats,qtserialport,qtsvg,qtwebsockets
    mkdir -p "${SUBMODULES}/qt6-build"
    cd "${SUBMODULES}/qt6-build"
    
    # For Qt 6 / CMake, pass the architectures via CMAKE_OSX_ARCHITECTURES
    "${SUBMODULES}/Qt6/configure" -prefix "${PREFIX}" \
        -ffmpeg-dir /usr/local/ffmpeg \
        -ffmpeg-deploy \
        -- -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
           -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOS_MIN}"
           
    cmake --build . --parallel
    cmake --install .

    echo "--------------------------------------------------------------------"
    echo "         Qt ${QT_VERSION} build successful........."
    echo "--------------------------------------------------------------------"
    sleep 3

    rm -rf "${SUBMODULES}/qt6-build"
    cd "${SUBMODULES}" && git clean -fdx
    git restore .
    cd ..
else
    cd "${SUBMODULES}" && git clean -fdx
    git restore .
    cd ..
fi

echo "--------------------------------------------------------------------"
echo "syncing libraries............."
echo "setting linker @rpath relative values for embedded libraries......"
echo "--------------------------------------------------------------------"
sleep 3

cd "${SUBMODULES}/.."
mkdir ./js8lib

cd /usr/local/js8lib/lib
install_name_tool -id @rpath/libhamlib.4.dylib libhamlib.4.dylib
install_name_tool -id @rpath/libusb-1.0.0.dylib libusb-1.0.0.dylib

cd "${SUBMODULES}/.."
rsync -arvz /usr/local/js8lib/ ./js8lib/

if [ "$qt" = "y" ]; then
    tar -czvf js8lib${LIB_VERSION}-MacOS_Universal_with_Qt.tar.gz js8lib
else
    tar -czvf js8lib${LIB_VERSION}-MacOS_Universal_no_Qt.tar.gz js8lib
fi

cd "${SUBMODULES}/.."
rm -rf ./js8lib

clear
echo "--------------------------------------------------------------------"
echo "   DONE!"
echo "   Universal library archive created."
echo "--------------------------------------------------------------------"

