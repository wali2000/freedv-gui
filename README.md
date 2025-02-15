 # Building FreeDV GUI

This document describes how to build the FreeDV GUI program for various operating systems.  FreeDV GUI is developed on Ubuntu Linux, and then cross compiled for Windows using Fedora Linux (Fedora has great cross compiling support) and Docker.

## Further Reading

  * http://freedv.org - introduction, documentation, downloads
  * [FreeDV GUI User Manual](USER_MANUAL.md)
  * [Building for Windows using Docker](docker/README_docker.md)
  
## Building on Ubuntu Linux (16-20) with PortAudio
  ```
  $ sudo apt install libspeexdsp-dev libsamplerate0-dev sox git \
  libwxgtk3.0-gtk3-dev portaudio19-dev libhamlib-dev libasound2-dev libao-dev \
  libgsm1-dev libsndfile1-dev cmake module-assistant build-essential
  $ git clone https://github.com/drowe67/freedv-gui.git
  $ cd freedv-gui
  $ ./build_linux.sh portaudio
  ```
  (For Ubuntu 20.04 the wxWidgets package is named `libwxgtk3.0-gtk3-dev`.)
  
  Then run with:
  ```
  $ ./build_linux/src/freedv
  ```
  
  Note this builds all libraries locally, nothing is installed on your machine.  ```make install``` is not required.

## Building on Fedora Linux with PortAudio
  ```
  $ sudo dnf groupinstall "Development Tools"
  $ sudo dnf install cmake wxGTK3-devel portaudio-devel libsamplerate-devel \
    libsndfile-devel speexdsp-devel hamlib-devel alsa-lib-devel libao-devel \
    gsm-devel gcc-c++ sox
  $ git clone https://github.com/drowe67/freedv-gui.git
  $ cd freedv-gui
  $ ./build_linux.sh portaudio
  ```
  Then run with:
  ```
  $ ./build_linux/src/freedv
  ```

## Building on Ubuntu Linux (16-20) with PulseAudio
  ```
  $ sudo apt install libspeexdsp-dev libsamplerate0-dev sox git \
  libwxgtk3.0-gtk3-dev libhamlib-dev libasound2-dev libao-dev \
  libgsm1-dev libsndfile1-dev cmake module-assistant build-essential libpulse-dev
  $ git clone https://github.com/drowe67/freedv-gui.git
  $ cd freedv-gui
  $ ./build_linux.sh pulseaudio
  ```
  (For Ubuntu 20.04 the wxWidgets package is named `libwxgtk3.0-gtk3-dev`.)
  
  Then run with:
  ```
  $ ./build_linux/src/freedv
  ```
  
  Note this builds all libraries locally, nothing is installed on your machine.  ```make install``` is not required.

## Building on Fedora Linux with PulseAudio
  ```
  $ sudo dnf groupinstall "Development Tools"
  $ sudo dnf install cmake wxGTK3-devel libsamplerate-devel \
    libsndfile-devel speexdsp-devel hamlib-devel alsa-lib-devel libao-devel \
    gsm-devel pulseaudio-libs-devel gcc-c++ sox
  $ git clone https://github.com/drowe67/freedv-gui.git
  $ cd freedv-gui
  $ ./build_linux.sh pulseaudio
  ```
  Then run with:
  ```
  $ ./build_linux/src/freedv
  ```
  
## Installing on Linux

You need to install the codec2 and lpcnetfreedv shared libraries, and freedv-gui:
  ```
  $ cd ~/freedv-gui/codec2/build_linux
  $ sudo make install
  $ cd ~/freedv-gui/LPCNet/build_linux
  $ sudo make install
  $ cd ~/freedv-gui/build_linux
  $ sudo make install
  $ sudo ldconfig
  ```
 
## Generating Debian packages

To generate a Debian/Ubuntu package, simply run the "cpack" command after running "make". The resulting .deb file can then be installed by running "dpkg -i" (once Codec2 and LPCNet packages are also installed).
 
## Testing

The ```wav``` directory contains test files of modulated audio that you can use to test FreeDV (see the [USER_MANUAL](USER_MANUAL.md)).

## Building for Windows using Docker

The Windows build process has been automated using a Docker container, see the freedv-gui Docker [README](docker/README_docker.md).

## Building for Windows on Fedora (Cross compiling)

Install basic MinGW development packages:
```
  $ sudo dnf install mingw{32,64}-filesystem mingw{32,64}-binutils \
    mingw{32,64}-gcc mingw{32,64}-crt mingw{32,64}-headers mingw32-nsis
```

Install dependencies of FreeDV/Codec2:
```
  $ sudo dnf install mingw{32,64}-speex
```

Enable Freetel specific packages not currently in Fedora proper:
```
  $ sudo dnf install dnf-plugins-core
  $ sudo dnf copr enable hobbes1069/mingw
  $ sudo dnf install mingw{32,64}-wxWidgets3 mingw{32,64}-hamlib \
    mingw{32,64}-portaudio mingw{32,64}-libsndfile mingw{32,64}-libsamplerate.noarch
```

Clone freedv-gui:
```
  $ cd
  $ git clone https://github.com/drowe67/freedv-gui.git
```

Building FreeDV for 64 Bit windows:
```
  $ cd ~/freedv-gui
  $ ./build_windows.sh
  $ cd build_win64
  $ make package
```

**OR** Building FreeDV for 32 Bit windows:
```
  $ cd ~/freedv-gui
  $ CMAKE=mingw32-cmake ./build_windows.sh
  $ cd build_win32
  $ make package
```

### Building FreeDV using LLVM MinGW (EXPERIMENTAL)

It is now possible to use the LLVM version of MinGW to build FreeDV. This allows
one to build FreeDV for ARM as well as for Intel Windows systems, including support
for 2020 mode (on systems fast enough to acceptably decode it).

#### Prerequisites

* CMake >= 3.25.0
* Linux (tested on Ubuntu 22.04)
    * *NOTE: This does not currently work on macOS due to CMake using incorrect library suffixes.*
* NSIS for generating the installer (for example, `sudo apt install nsis` on Ubuntu)

#### Instructions

1. Download LLVM MinGW at https://github.com/mstorsjo/llvm-mingw/releases/tag/20220906.
2. Decompress into your preferred location. For example: `tar xvf llvm-mingw-20220906-ucrt-ubuntu-18.04-x86_64.tar.xz` (The exact filename here will depend on the file downloaded in step (1). Note that for best results, you should use a build containing "ucrt" in the file name corresponding to the platform which you're building the Windows binary from.)
3. Add LLVM MinGW to your PATH: `export PATH=/path/to/llvm-mingw-20220906-ucrt-ubuntu-18.04-x86_64/bin:$PATH`. (The folder containing the LLVM tools is typically named the same as the file downloaded in step (2) minus the extension.)
4. Create a build folder inside freedv-gui: `mkdir build_windows`
5. Run CMake to configure the FreeDV build: `cd build_windows && cmake -DCMAKE_TOOLCHAIN_FILE=${PWD}/../cross-compile/freedv-mingw-llvm-[architecture].cmake ..`
   * Valid architectures are: aarch64, armv7, i686, x86_64
6. Build FreeDV as normal: `make` (You can also add `-j[num]` to the end of this command to use multiple cores and shorten the build time.)
7. Create FreeDV installer: `make package`

#### Known Issues

* NSIS-related issues:
    * ARM installers will not properly register in Windows despite installing properly. You can still run the application manually by navigating to C:\Program Files\FreeDV \[version\]\ using File Explorer and double-clicking on `freedv.exe`.

### Testing Windows Build

Conveniently, it is possible to run Windows executables using Wine on Fedora:

Testing LPCNet:
```
  $ cd ~/freedv-gui/LPCNet/build_win/src
  $ WINEPATH=$HOME/freedv-gui/codec2/build_win/src';'$HOME/freedv-gui/build_win/_CPack_Packages/win64/NSIS/FreeDV-1.4.0-devel-win64/bin/ wine lpcnet_enc.exe --infile all.wav --outfile all.bit
  $ WINEPATH=$HOME/freedv-gui/codec2/build_win/src';'$HOME/freedv-gui/build_win/_CPack_Packages/win64/NSIS/FreeDV-1.4.0-devel-win64/bin/ wine lpcnet_dec.exe --infile all.bin --outfile all_out.raw
  $ cat all_out.raw | aplay -f S16_LE -r 16000

```

Testing FreeDV API:

```
  $ cd freedv-gui/codec2/build_win/src
  $ WINEPATH=$HOME/freedv-gui/LPCNet/build_win/src';'$HOME/freedv-gui/build_win/_CPack_Packages/win64/NSIS/FreeDV-1.4.0-devel-win64/bin/ wine freedv_rx 2020 ~/freedv-gui/wav/all_2020.wav out.raw
  $ play -t .s16 -r 16000 -b 16 out.raw
```

## Building and installing on macOS

Using MacPorts, most of the appropriate dependencies can be installed by:

$ sudo port install subversion git libtool sox +universal cmake

It should be fairly similar using HomeBrew, but you will need to replace all the /opt/ paths in the following instructions.

Note: If using an ARM Mac, you may need to build and install the Git version of MacPorts first. See https://guide.macports.org/#installing.macports.git for more details on how to do this.

Once the dependencies are installed, you can then run the `build_osx.sh` script inside the source tree to build
FreeDV and associated libraries (codec2, LPCNet, hamlib). A FreeDV.app app bundle will be created inside the build_osx/src
folder which can be copied to your system's Applications folder.

## Building and installing on FreeBSD

In ```build_linux.sh``` change the ```build_linux``` directory to build_freebsd.
