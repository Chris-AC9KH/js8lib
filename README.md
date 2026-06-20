# JS8Call Developer's Submodule Repository for Windows

- This repository is only for JS8Call developers to build and package pre-built libraries for JS8Call. It is not intended for end users to build the code.
- The base repository contains the source code for Boost 1.88.0
- Windows packages are assembled from pre-built vendor packages and do not require any special build toos to be installed on your Windows system.

# Building and Creating a JS8Call Library Package
- Using the Qt online installer or Maintenance Tool, download and install Qt at C:\Qt - install only the needed modules: QtMultimedia, QtSerialPort, QtWebsockets and check the box to install LLVM-MINGW 17.0.6 64-bit
- Using Windows PowerShell cd to C:\ and clone this repository with:
```
git clone https://github.com/JS8Call-improved/js8lib.git
```
- cd into js8lib, use `git checkout Windows_4.0` and run the `BUILD.ps1` script to build a library archive.

- After the build completes you can validate the library build by unpacking the archive and use the js8lib folder in the -prefix path for your build. Using Qt Creator is recommended to valid the library, using the CMake prefix path in the build instructions for Qt Creator.
- After js8lib is built you can optionally package Qt 6.11.1 by running the `Package-Qt6_Windows.ps1` script.
