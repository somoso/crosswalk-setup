#!/bin/bash

set -e

source source_me.sh

mkdir ~/crosswalk
cd ~/crosswalk

gclient config --name=src/xwalk https://github.com/somoso/crosswalk.git@origin/crosswalk-16

gclient sync

.src/build/install-build-deps-android.sh

echo "{ 'GYP_DEFINES': 'OS=android target_arch=arm', }" > chromium.gyp_env

export GYP_GENERATORS='ninja'
cd ~/crosswalk/src
python xwalk/gyp_xwalk

ninja -C out/Release xwalk_core_library_aar
