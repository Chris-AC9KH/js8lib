# JS8Call Developer's Submodule Repository

- This repository is only for JS8Call developers to build and package pre-built libraries for JS8Call. It is not intended for end users
to build the code.
- The base repository contains the source code for FFTW-3.3.10 and Boost 1.88.0
- Hamlib, libusb are obtained as submodules with `git submodule update --init --recursive' by
running the BUILD.sh script.

# Building and Creating a JS8Call Library Package
- To build a library package you must create the proper directory structure on your development machine. The following command will
accomplish this: `mkdir ~/.local/bin/js8lib`
- cd into your development root folder which can be anything you wish and clone this repository with:
```
git clone https://github.com/JS8Call-improved/js8lib.git submodules
```
- cd into submodules and run the BUILD.sh script with `./BUILD.sh`. If the build is successful it will create a gzipped tar archive of the
library build in the root of your development folder. Depending on the capabilities of your build machine this can take a long time.

- After the build completes you can validate the library build by building JS8Call with: `-prefix ~/.local/bin/js8lib` for your build.
