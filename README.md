# JS8Call Developer's Submodule Repository for Linux

- This repository is only for JS8Call developers to build and package pre-built libraries for JS8Call. It is not intended for end users
to build the code.
- The base repository contains the source code for FFTW-3.3.10 and Boost 1.88.0
- Hamlib, libusb are obtained as submodules with `git submodule update --init --recursive' by
running the BUILD.sh script.

# Building and Creating a JS8Call Library Package
- IMPORTANT NOTE: this must be run on Ubuntu 24 Server with no GUI installed
- cd into your development root folder which can be anything you wish and clone this repository with:
```
git clone https://github.com/JS8Call-improved/js8lib.git submodules
```
- cd into submodules and run the Distribution_package_js8lib.sh script with `./Distribution_package_js8lib.sh`. If the build is successful it will create a gzipped tar archive of the library build in the root of your development folder. Depending on the capabilities of your build machine this can take a long time.

- After the build completes you can validate the library build by building JS8Call with: `-prefix /usr/lib/js8lib` for your build.
- Optional after building js8lib, if you want to build the required Qt package; run the Linux-Dist_pkg_Qt6.sh script which will fetch and build the proper version of Qt6 for this library version. This will probably take a long time.
