#!/bin/bash
set -e

# (C) copyright 2025 Chris Olson AC9KH
# Builds js8lib base dependencies for JS8Call on Linux (package maintainers)
# Runs on a local Ubuntu 24 machine OR via GitHub Actions workflow.
# No Qt build option here by design — Qt is handled by a separate script.

# --- Variables ---
# set these to configure the build
LIB_VERSION="4.0"
HAMLIB_TAG="4.7.2"
LIBUSB_TAG="v1.0.29"
FFTW_VERSION="3.3.10"
BOOST_VERSION="1.88.0"

echo "--------------------------------------------------------------------"
echo "         Building js8lib ${LIB_VERSION} for JS8Call package maintainers"
echo "         Build host: Ubuntu 24 Server ONLY"
echo "         DO NOT run this script as root"
echo "--------------------------------------------------------------------"
sleep 2

# --- Must not run as root ---
if [ "$(id -u)" -eq 0 ]; then
    echo "This script must NOT be run as root. Exiting."
    exit 1
fi

# --- Verify we are on Ubuntu 24 ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "ubuntu" || "$VERSION_ID" != "24.04" ]]; then
        echo "This script must be run on Ubuntu 24.04 Server. Detected: $ID $VERSION_ID"
        echo "Exiting."
        exit 1
    fi
else
    echo "Cannot detect Linux distribution. Exiting."
    exit 1
fi

# --- Install build dependencies ---
echo "Installing build dependencies..."
sudo apt-get update
sudo apt-get install -y \
    build-essential pkgconf autoconf libtool automake texinfo \
    libusb-1.0-0-dev libudev-dev

echo "--------------------------------------------------------------------"
echo "         Building js8lib........."
echo "--------------------------------------------------------------------"
sleep 2

# --- Set variables ---
SUBMODULES=$(pwd)
PREFIX="/usr/lib/js8call"
ARCH="$(uname -m)"

# --- Clean and recreate prefix directory before building ---
if [ -d "$PREFIX" ] && [ -n "$PREFIX" ]; then
    echo "Prefix $PREFIX already exists. Performing fresh wipe..."
    sudo rm -rf "$PREFIX"
fi

echo "Creating clean $PREFIX..."
sudo mkdir -p "$PREFIX"
sudo chown root:root "$PREFIX"

# --- Update submodules ---
cd "${SUBMODULES}"
git submodule update --init --recursive
if [ $? -ne 0 ]; then
    echo "git submodule update failed. Exiting."
    exit 1
fi

####### Build libusb #######
cd "${SUBMODULES}/libusb"
./bootstrap.sh
./configure --prefix="${PREFIX}"
make && sudo make install
make clean

echo "--------------------------------------------------------------------"
echo "         libusb-${LIBUSB_TAG} build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build Hamlib #######
cd "${SUBMODULES}/Hamlib"
git fetch --depth 1 origin tag "${HAMLIB_TAG}"
git checkout "${HAMLIB_TAG}"
./bootstrap
./configure --prefix="${PREFIX}"
make && sudo make install
make clean

echo "--------------------------------------------------------------------"
echo "         Hamlib-${HAMLIB_TAG} build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build fftw #######
cd "${SUBMODULES}/fftw"
./configure --prefix="${PREFIX}" --enable-single --enable-threads
make && sudo make install
make clean

echo "--------------------------------------------------------------------"
echo "         fftw-v${FFTW_VERSION} build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build boost (headers only) #######
cd "${SUBMODULES}/boost"
./bootstrap.sh --prefix="${PREFIX}"
sudo ./b2 install --with-headers

echo "--------------------------------------------------------------------"
echo "         boost-v${BOOST_VERSION} header copy successful........."
echo "--------------------------------------------------------------------"
sleep 3

# --- Clean up submodule build artifacts ---
cd "${SUBMODULES}"
git submodule foreach --recursive git clean -fdx
cd ..

echo "--------------------------------------------------------------------"
echo "         Syncing libraries to tarball staging area..."
echo "--------------------------------------------------------------------"
sleep 3

# --- Stage and package ---
STAGING="$HOME/js8lib_staging"
TARBALL="js8lib${LIB_VERSION}-Linux_${ARCH}_pkg.tar.gz"

rm -rf "${STAGING}"
mkdir -p "${STAGING}/js8lib"

rsync -arvz "${PREFIX}/" "${STAGING}/js8lib/"

cd "${STAGING}"
tar -czvf "$HOME/${TARBALL}" js8lib

rm -rf "${STAGING}"

echo "--------------------------------------------------------------------"
echo "   DONE!"
echo "   Library archive: $HOME/${TARBALL}"
echo ""
echo "   It is recommended to validate this build by building JS8Call"
echo "   using ${PREFIX} as CMAKE_PREFIX_PATH before releasing."
echo ""
echo "   Qt is NOT included — run the Qt build script separately."
echo "   Qt installs to ${PREFIX}/Qt"
echo "--------------------------------------------------------------------"
