#!/bin/sh

TARGET=`pwd`
PLATFORM=`uname`

set -e

PATH=$PATH:./depot_tools

# Get depot tools
if [ ! -e ./depot_tools ]; then
  echo "Fetching depot_tools..."
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

# Get v8
if [ ! -e ./v8 ]; then
  echo "Fetching v8..."
  fetch v8
fi

# Build v8
cd ./v8
case $PLATFORM in
  Linux)
    echo "Building for Linux..."
    make x64.release \
      GYPFLAGS="-Dv8_use_external_startup_data=0 -Dv8_enable_i18n_support=0 -Dv8_enable_gdbjit=0"

    mkdir -p $TARGET/libv8/linux
    mkdir -p $TARGET/include/libplatform
    cp -a ./include/*.h $TARGET/include
    cp -a ./include/libplatform/*.h $TARGET/include/libplatform/
    cp -a ./out/x64.release/obj.target/src/libv8_*.a $TARGET/libv8/linux
    for f in $TARGET/libv8/linux/libv8_*.a; do
      ar -t $f | xargs ar rvs $f.new && mv -v $f.new $f
    done
    ;;

  Darwin)
    OSX_VERSION=$(sw_vers -productVersion)
    echo "Building for OS X ${OSX_VERSION}..."
    make -j5 x64.release \
      GYPFLAGS="-Dv8_use_external_startup_data=0 -Dv8_enable_i18n_support=0 -Dv8_enable_gdbjit=0" \
      GYP_DEFINES="mac_deployment_target=${OSX_VERSION}"

    mkdir -p $TARGET/libv8/darwin
    mkdir -p $TARGET/include/libplatform
    cp -a ./include/*.h $TARGET/include/
    cp -a ./include/libplatform/*.h $TARGET/include/libplatform/
    cp -a ./out/native/libv8_*.a $TARGET/libv8/darwin
    for f in $TARGET/libv8/darwin/libv8_*.a; do
      strip -S $f
    done
    ;;

  *)
    echo "Platform not supported: $PLATFORM"
    exit 1
    ;;
esac
