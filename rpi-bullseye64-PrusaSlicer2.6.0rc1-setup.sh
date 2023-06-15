#!/bin/sh
#install Prusa Slicer(2.6.0-rc1)
#N4XWE 05-14-2023
#Test Compiled on RaspiOS-bullseye dtd 2023-05-03 64-bit

sudo apt update && sudo apt -y upgrade

sudo apt -y install git build-essential autoconf cmake libglu1-mesa-dev \
libgtk-3-dev libdbus-1-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

mkdir -p ~/src/PRSLCR && cd ~/src/PRSLCR

git clone https://www.github.com/prusa3d/PrusaSlicer ||
    { echo 'Unable to download the Prusa Slicer repository'; exit 1; }
  
cd ~/src/PRSLCR/PrusaSlicer

cd deps

mkdir build && cd build

cmake .. -DDEP_WX_GTK3=ON

make -j3

cd ../..

mkdir build && cd build

cmake .. -DSLIC3R_STATIC=1 -DSLIC3R_GTK=3 -DSLIC3R_PCH=OFF -DCMAKE_PREFIX_PATH=$(pwd)/../deps/build/destdir/usr/local -DSLIC3R_FHS=1

make -j3 && sudo make install

#Install a Prusa Slicer icon on the RPi desktop
echo "[Desktop Entry]
Name=PRSLCR
GenericName=Prusa Slicer
Comment=Start Prusa Slicer
Exec=/usr/local/bin/prusa-slicer
Icon=/usr/local/share/icons/hicolor/32x32/apps/PrusaSlicer.png
Terminal=false
Type=Application
Categories=Other;3DPrinter;" > ~/Desktop/prslcr.desktop ||
    { echo 'Unable to setup the Prusa Slicer icon'; exit 1;}
