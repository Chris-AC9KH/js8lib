#!/bin/sh
clear
# make sure we have the necessary tools installed to build libraries
sudo apt install build-essential pkgconf autoconf libtool automake texinfo
clear
echo "--------------------------------------------------------------------"
echo "         Building js8lib........."
echo "--------------------------------------------------------------------"
sleep 2

if [ ! -d $HOME/.local/lib/js8lib ]; then
    echo "directory structure does not exist! Creating....."
    mkdir $HOME/.local/lib/js8lib
    sleep 3
fi

# set variables
SUBMODULES=$(pwd)
PREFIX="$HOME/.local/lib/js8lib"
ARCH="$(uname -m)"
PLATFORM="$(uname)"

cd ${SUBMODULES} && git submodule update --init --recursive

####### Build libusb #######
cd ${SUBMODULES}/libusb
./bootstrap.sh
./configure --prefix=${PREFIX}

make && make install
make clean
clear
echo "--------------------------------------------------------------------"
echo "         libusb-v1.0.29 build successful........."
echo "--------------------------------------------------------------------"
sleep 5

####### Build Hamlib #######
cd ../Hamlib
./bootstrap
./configure --prefix=${PREFIX}

make && make install
make clean
clear
echo "--------------------------------------------------------------------"
echo "         Hamlib-v4.7.1 build successful........."
echo "--------------------------------------------------------------------"
sleep 5

####### Build fftw #######
cd ../fftw
./configure --prefix=${PREFIX} --enable-single --enable-threads

make && make install
make clean
clear
echo "--------------------------------------------------------------------"
echo "         fftw-v3.3.10 build successful........."
echo "--------------------------------------------------------------------"
sleep 5

####### Build boost #######
cd ../boost
./bootstrap.sh --prefix=${PREFIX}
./b2 install --with-headers
clear
echo "--------------------------------------------------------------------"
echo "         boost-v1.88.0 header copy successful........."
echo "--------------------------------------------------------------------"
sleep 5

cd ${SUBMODULES} && git clean -fdx
git restore *
cd ..

clear

echo "--------------------------------------------------------------------"
echo "syncing libraries............."
echo "--------------------------------------------------------------------"
sleep 5

cd ${SUBMODULES}/..
if [ -d ./js8lib ]; then
    mv ./js8lib ./js8lib_old && mkdir ./js8lib
  else
    mkdir ./js8lib
fi

rsync -arvz $HOME/.local/lib/js8lib/ ./js8lib/

# create downloadable pre-built library archive
tar -czvf js8lib3.0-Linux_${ARCH}.tar.gz js8lib

# clean up build artifacts
if [ -d ./js8lib_old ]; then
    rm -rf ./js8lib
    mv ./js8lib_old ./js8lib
else
    rm -rf ./js8lib
fi

clear
echo "--------------------------------------------------------------------"
echo "   DONE!    "
echo "library archive created"
echo "It is recommended to try a JS8Call-improved build using ~/.local/lib/js8lib"
echo "as the PREFIX_PATH to validate your build. If satisfied you can"
echo "delete the files in ~/.local/lib/js8lib"
echo "--------------------------------------------------------------------"
