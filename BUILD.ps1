$VERSION = "3.0"
$HAMLIB_VERSION = "4.7.1"
$LIBUSB_VERSION = "1.0.29"
$LIB_DIR = "js8lib$VERSION"

if (Test-Path $LIB_DIR) {
    Write-Host "Cleaning up previous build artifacts..."
    Remove-Item -Recurse -Force $LIB_DIR
}

Write-Host "Creating library directory $LIB_DIR..."
New-Item -ItemType Directory -Path $LIB_DIR | Out-Null

Write-Host "Fetching Hamlib $HAMLIB_VERSION..."
Invoke-WebRequest -Uri "https://github.com/Hamlib/Hamlib/releases/download/$HAMLIB_VERSION/hamlib-w64-$HAMLIB_VERSION.zip" -OutFile "hamlib.zip"

Write-Host "Extracting Hamlib..."
Expand-Archive -Path "hamlib.zip" -DestinationPath "."

Write-Host "Copying Hamlib to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\hamlib-$HAMLIB_VERSION" | Out-Null
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\bin"     "$LIB_DIR\hamlib-$HAMLIB_VERSION\bin"
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\include" "$LIB_DIR\hamlib-$HAMLIB_VERSION\include"
Copy-Item -Recurse "hamlib-w64-$HAMLIB_VERSION\lib"     "$LIB_DIR\hamlib-$HAMLIB_VERSION\lib"

Write-Host "Cleaning up Hamlib artifacts..."
Remove-Item -Recurse -Force "hamlib-w64-$HAMLIB_VERSION"
Remove-Item "hamlib.zip"

Write-Host "Fetching libusb $LIBUSB_VERSION..."
Invoke-WebRequest -Uri "https://github.com/libusb/libusb/releases/download/v$LIBUSB_VERSION/libusb-$LIBUSB_VERSION.7z" -OutFile "libusb.7z"

Write-Host "Extracting libusb..."
& "C:\Program Files\7-Zip\7z.exe" x libusb.7z -o"libusb-$LIBUSB_VERSION" -y

Write-Host "Copying libusb to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\libusb-$LIBUSB_VERSION" | Out-Null
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\include" "$LIB_DIR\libusb-$LIBUSB_VERSION\include"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW32"          "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW32"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW64"          "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW64"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\MinGW-llvm-aarch64" "$LIB_DIR\libusb-$LIBUSB_VERSION\MinGW-llvm-aarch64"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2013"           "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2013"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2015"           "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2015"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2017"           "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2017"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2019"           "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2019"
Copy-Item -Recurse "libusb-$LIBUSB_VERSION\VS2022"           "$LIB_DIR\libusb-$LIBUSB_VERSION\VS2022"
Copy-Item "libusb-$LIBUSB_VERSION\libusb-1.0.def" "$LIB_DIR\libusb-$LIBUSB_VERSION\libusb-1.0.def"
Copy-Item "libusb-$LIBUSB_VERSION\README.txt"     "$LIB_DIR\libusb-$LIBUSB_VERSION\README.txt"

Write-Host "Cleaning up libusb artifacts..."
Remove-Item -Recurse -Force "libusb-$LIBUSB_VERSION"
Remove-Item "libusb.7z"

Write-Host "Fetching fftw3 $FFTW3_VERSION..."
Invoke-WebRequest -Uri "https://fftw.org/pub/fftw/fftw-$FFTW3_VERSION-dll64.zip" -OutFile "fftw3.zip"

Write-Host "Extracting fftw3..."
Expand-Archive -Path "fftw3.zip" -DestinationPath "fftw3-tmp"

Write-Host "Copying fftw3 to library..."
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\bin"     | Out-Null
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\include" | Out-Null
New-Item -ItemType Directory -Path "$LIB_DIR\fftw3\lib"     | Out-Null

# bin - wisdom executables
Copy-Item "fftw3-tmp\fftw-wisdom.exe"  "$LIB_DIR\fftw3\bin"
Copy-Item "fftw3-tmp\fftwf-wisdom.exe" "$LIB_DIR\fftw3\bin"
Copy-Item "fftw3-tmp\fftwl-wisdom.exe" "$LIB_DIR\fftw3\bin"

# include - headers and Fortran interface files
Copy-Item "fftw3-tmp\fftw3.f"     "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3.f03"   "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3.h"     "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3l.f03"  "$LIB_DIR\fftw3\include"
Copy-Item "fftw3-tmp\fftw3q.f03"  "$LIB_DIR\fftw3\include"

# lib - import libs and dlls
Copy-Item "fftw3-tmp\libfftw3-3.def"  "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3-3.dll"  "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3f-3.def" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3f-3.dll" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3l-3.def" "$LIB_DIR\fftw3\lib"
Copy-Item "fftw3-tmp\libfftw3l-3.dll" "$LIB_DIR\fftw3\lib"

Write-Host "Cleaning up fftw3 artifacts..."
Remove-Item -Recurse -Force "fftw3-tmp"
Remove-Item "fftw3.zip"

