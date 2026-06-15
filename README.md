# JS8Call Developer's Submodule Repository

- This repository is only for JS8Call developers to build and package pre-built libraries for JS8Call. It is not intended for end users to build the code.
- The base repository contains the source code for Boost 1.88.0

# Building and Creating a JS8Call Library Package
- Using Windows PowerShell cd to C:\ and clone this repository with:
```
git clone https://github.com/JS8Call-improved/js8lib.git
```
- cd into js8lib, use `git checkout Windows_3.0` and run the BUILD.ps1 script to build a library archive.

- After the build completes you can validate the library build by unpacking the archive and use the js8lib folder in the -prefix path for your build. Using Qt Creator is recommended to valid the library, using the CMake prefix path in the build instructions for Qt Creator.
