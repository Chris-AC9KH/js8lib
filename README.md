# JS8Call Developer's Submodule Repository

- This repository is only for JS8Call developers to build and package pre-built libraries for JS8Call. It is not intended for end users
to build the code.
- The base repository contains the source code for FFTW-3.3.10
- Qt6 v6.9.3, Hamlib v4.6.4, libusb-1.0.29 and Boost 1.88.0 are obtained as submodules with `git submodule update --init --recursive` after
cloning this repository.

# Building and Creating a JS8Call Library Package
- To build a library package you must create the proper directory structure on your development machine. For Windows C:\development\js8lib is recommended
- cd into your development root folder and clone this repository with:
```
git clone https://github.com/JS8Call-improved/js8lib.git submodules
```
- cd into submodules and run `git submodule update --init --recursive` to initialize the submodules. On Windows you will have to build each submodule separately.

- After the build completes you can validate the library build by unpacking the archive and use the js8lib folder in the -prefix path
for your build.
