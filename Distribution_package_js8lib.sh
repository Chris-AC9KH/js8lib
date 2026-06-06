#!/bin/bash
set -e

clear
echo "--------------------------------------------------------------------"
echo "         Building js8lib for JS8Call package maintainers"
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
    libusb-1.0-0-dev

clear
echo "--------------------------------------------------------------------"
echo "         Building js8lib........."
echo "--------------------------------------------------------------------"
sleep 2

# --- Set variables ---
SUBMODULES=$(pwd)
PREFIX="/usr/lib/js8call"
ARCH="$(uname -m)"

# --- Create directory structure owned by root ---
if [ ! -d "$PREFIX" ]; then
    echo "Creating $PREFIX..."
    sudo mkdir -p "$PREFIX"
fi
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
clear
echo "--------------------------------------------------------------------"
echo "         libusb-v1.0.29 build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build Hamlib #######
cd "${SUBMODULES}/Hamlib"
./bootstrap
./configure --prefix="${PREFIX}"
make && sudo make install
make clean
clear
echo "--------------------------------------------------------------------"
echo "         Hamlib-v4.7.1 build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build fftw #######
cd "${SUBMODULES}/fftw"
./configure --prefix="${PREFIX}" --enable-single --enable-threads
make && sudo make install
make clean
clear
echo "--------------------------------------------------------------------"
echo "         fftw-v3.3.10 build successful........."
echo "--------------------------------------------------------------------"
sleep 3

####### Build boost (headers only) #######
cd "${SUBMODULES}/boost"
./bootstrap.sh --prefix="${PREFIX}"
sudo ./b2 install --with-headers
clear
echo "--------------------------------------------------------------------"
echo "         boost-v1.88.0 header copy successful........."
echo "--------------------------------------------------------------------"
sleep 3

# --- Clean up submodule build artifacts ---
cd "${SUBMODULES}"
git clean -fdx
git restore .
cd ..

clear
echo "--------------------------------------------------------------------"
echo "         Syncing libraries to tarball staging area..."
echo "--------------------------------------------------------------------"
sleep 3

# --- Stage and package ---
STAGING="$HOME/js8lib_staging"
TARBALL="js8lib3.0-Linux_${ARCH}.tar.gz"

rm -rf "${STAGING}"
mkdir -p "${STAGING}/js8lib"

rsync -arvz "${PREFIX}/" "${STAGING}/js8lib/"

cd "${STAGING}"
tar -czvf "$HOME/${TARBALL}" js8lib

rm -rf "${STAGING}"

clear
echo "--------------------------------------------------------------------"
echo "   DONE!"
echo "   Library archive: $HOME/${TARBALL}"
echo ""
echo "   It is recommended to validate this build by building JS8Call"
echo "   using ${PREFIX} as CMAKE_PREFIX_PATH before releasing."
echo ""
echo "   Qt 6.9.3 is NOT included — run the Qt build script separately."
echo "   Qt installs to ${PREFIX}/Qt"
echo "--------------------------------------------------------------------"