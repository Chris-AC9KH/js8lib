$VERSION                  = "4.0"
$HAMLIB_VERSION           = "4.7.1"
$LIBUSB_VERSION           = "1.0.29"
$FFTW3_VERSION            = "3.3.5"
$BOOST_VERSION_HYPHEN     = "1.88"
$QT_VERSION               = "6.11.1"
$LIB_DIR                  = "js8lib$VERSION"
$QT_LLVM_BIN              = "C:\Qt\$QT_VERSION\llvm-mingw_64\bin"
$QT_TOOLS_BIN             = "C:\Qt\Tools\llvm-mingw1706_64\bin"

$ErrorActionPreference = "Stop"

if (Test-Path $LIB_DIR) {
    Write-Host "Cleaning up previous build artifacts..."
    Remove-Item -Recurse -Force $LIB_DIR
}

Write-Host "Creating library directory $LIB_DIR..."
New-Item -ItemType Directory -Path $LIB_DIR | Out-Null

# Hamlib
Write-Host "Fetching Hamlib $HAMLIB_VERSION..."
Invoke-WebRequest -Uri "https://github.com/Hamlib/Hamlib/releases/download/$HAMLIB_VERSION/hamlib-w64-$HAMLIB_VERSION.zip" -OutFile "hamlib.zip"

Write-Host "Extracting Hamlib..."
Expand-Archive -Path "hamlib.zip" -DestinationPath "."

Write-Host "Copying Hamlib to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\hamlib-$HAMLIB_VERSION" | Out-Null
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\bin"     "$LIB_DIR\hamlib-$HAMLIB_VERSION\bin"
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\include" "$LIB_DIR\hamlib-$HAMLIB_VERSION\include"
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\lib"     "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib"

Write-Host "Restructuring Hamlib lib directory..."
Move-Item "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib\gcc\*" "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib\"
Remove-Item -Recurse -Force "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib\gcc"
Remove-Item -Recurse -Force "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib\msvc"

Write-Host "Cleaning up Hamlib artifacts..."
Remove-Item -Recurse -Force "hamlib-w64-$HAMLIB_VERSION"
Remove-Item "hamlib.zip"

# libusb
Write-Host "Fetching libusb $LIBUSB_VERSION..."
Invoke-WebRequest -Uri "https://github.com/libusb/libusb/releases/download/v$LIBUSB_VERSION/libusb-$LIBUSB_VERSION.7z" -OutFile "libusb.7z"

Write-Host "Extracting libusb..."
& "C:\Program Files\7-Zip\7z.exe" x libusb.7z -o"libusb-$LIBUSB_VERSION" -y

Write-Host "Copying libusb to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\libusb-$LIBUSB_VERSION" | Out-Null
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\include"            "$LIB_DIR\libusb-$LIBUSB_VERSION\include"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW32"            "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW32"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW64"            "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW64"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW-llvm-aarch64" "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW-llvm-aarch64"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2013"             "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2013"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2015"             "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2015"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2017"             "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2017"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2019"             "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2019"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2022"             "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2022"
Copy-Item "libusb-$LIBUSB_VERSION\libusb-1.0.def"             "$LIB_DIR\libusb-$LIBUSB_VERSION\libusb-1.0.def"
Copy-Item "libusb-$LIBUSB_VERSION\README.txt"                  "$LIB_DIR\libusb-$LIBUSB_VERSION\README.txt"

Write-Host "Cleaning up libusb artifacts..."
Remove-Item -Recurse -Force "libusb-$LIBUSB_VERSION"
Remove-Item "libusb.7z"

# fftw3
Write-Host "Fetching fftw3 $FFTW3_VERSION..."
Invoke-WebRequest -Uri "https://fftw.org/pub/fftw/fftw-$FFTW3_VERSION-dll64.zip" -OutFile "fftw3.zip"

Write-Host "Extracting fftw3..."
Expand-Archive -Path "fftw3.zip" -DestinationPath "fftw3-tmp"

Write-Host "Copying fftw3 to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\bin"     | Out-Null
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\include" | Out-Null
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\lib"     | Out-Null

Copy-Item "fftw3-tmp\fftw-wisdom.exe"  "$LIB_DIR\fftw3\bin"
Copy-Item "fftw3-tmp\fftwf-wisdom.exe" "$LIB_DIR\fftw3\bin"
Copy-Item "fftw3-tmp\fftwl-wisdom.exe" "$LIB_DIR\fftw3\bin"

Copy-Item "fftw3-tmp\fftw3.f"    "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3.f03"  "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3.h"    "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3l.f03" "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3q.f03" "$LIB_DIR\fftw3\include"

Copy-Item "fftw3-tmp\libfftw3-3.def"  "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3-3.dll"  "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3f-3.def" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3f-3.dll" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3l-3.def" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3l-3.dll" "$LIB_DIR\fftw3\lib"

Write-Host "Cleaning up fftw3 artifacts..."
Remove-Item -Recurse -Force "fftw3-tmp"
Remove-Item "fftw3.zip"

# Boost (headers only)
Write-Host "Building Boost headers..."
Push-Location "boost"
$env:Path = "$QT_TOOLS_BIN;" + $env:Path
& ".\bootstrap.bat" "clang"
& ".\b2.exe" install --with-headers --prefix="..\$LIB_DIR\boost-$BOOST_VERSION_HYPHEN"
Pop-Location

cls
Write-Host "--------------------------------------------------------------------"
Write-Host "         boost-v$BOOST_VERSION_HYPHEN header copy successful........."
Write-Host "--------------------------------------------------------------------"
Start-Sleep -Seconds 3

# dll staging folder
Write-Host "Creating dll staging folder..."
New-Item -ItemType Directory -Path "$LIB_DIR\dll" | Out-Null

Write-Host "Copying Qt LLVM/Clang runtime dlls..."
Copy-Item "$QT_LLVM_BIN\libc++.dll"    "$LIB_DIR\dll"
Copy-Item "$QT_LLVM_BIN\libunwind.dll" "$LIB_DIR\dll"

Write-Host "Copying Hamlib runtime dlls..."
Copy-Item "$LIB_DIR\hamlib-$HAMLIB_VERSION\bin\libhamlib-4.dll"     "$LIB_DIR\dll"
Copy-Item "$LIB_DIR\hamlib-$HAMLIB_VERSION\bin\libwinpthread-1.dll" "$LIB_DIR\dll"

Write-Host "Copying fftw3 runtime dll..."
Copy-Item "$LIB_DIR\fftw3\lib\libfftw3f-3.dll" "$LIB_DIR\dll"

Write-Host "Copying libusb runtime dll..."
Copy-Item "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW64\dll\libusb-1.0.dll" "$LIB_DIR\dll"

# Final archive
# Rename to js8lib before archiving so it unzips to just "js8lib"
Write-Host "Preparing final archive..."
Rename-Item -Path $LIB_DIR -NewName "js8lib"
Compress-Archive -Path "js8lib" -DestinationPath "js8lib${VERSION}_Win64.zip"

Write-Host "--------------------------------------------------------------------"
Write-Host "         js8lib$VERSION Win64 build complete!"
Write-Host "--------------------------------------------------------------------"
