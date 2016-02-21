#!/bin/bash

set -e

export XWALK_OS_ANDROID=1

cd ~

if [ ! -d "depot_tools" ]; then
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH=`pwd`/depot_tools:"$PATH"
fi

mkdir ~/chromium
cd ~/chromium

gclient config --name=src/xwalk https://github.com/somoso/crosswalk.git@origin/crosswalk-16

gclient sync

./build/install-build-deps-android.sh

echo "{ 'GYP_DEFINES': 'OS=android target_arch=arm', }" > chromium.gyp_env

export GYP_GENERATORS='ninja'
python xwalk/gyp_xwalk

ninja -C out/Release xwalk_core_library_aar xwalk_shared_library_aar
