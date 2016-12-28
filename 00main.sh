#!/bin/bash -ex

# Awesome Ads SDK versions
sdk_version_ios="5.3.14"
sdk_version_android="5.3.7"
sdk_version_unity="5.1.6"
sdk_version_air="5.1.5"
sdk_version_flash="3.2.8"
sdk_version_web="2.0.0"

# Kids Web Services SDK versions
sdk_version_kws_ios="2.1.9"
sdk_version_kws_android="2.1.6"
sdk_version_kws="1.1.0"
sdk_version_kws_parent_ios="1.0.4"
sdk_version_kws_parent_android="1.0.7"

# main build variables
# home dir
# workspace dir
# build repo
homey="/Users/gabriel.coman"
workspace="$homey/Workspace"
build_repo="$workspace/sa-sdk-build-repo"

# Awesome Ads build dir
android_build="$build_repo/android_build"
flash_build="$build_repo/flash_build"
air_build="$build_repo/air_build"
air_moat_build="$build_repo/air_moat_build"
unity_build="$build_repo/unity_build"
unity_moat_build="$build_repo/unity_moat_build"
ios_build="$build_repo/ios_build"

# Kids Web Services build dir
kws_ios_build="$build_repo/kws_ios_build"
kws_android_build="$build_repo/kws_android_build"
kws_parent_ios_build="$build_repo/kws_parent_ios_build"
kws_parent_android_build="$build_repo/kws_parent_android_build"

# Final package dir
package_file="$build_repo/package"

# start
cd

# rebuild Android build folder
if [ -d $android_build ]
then
    rm -rf $android_build
fi
mkdir $android_build

# rebuild iOS build folder
if [ -d $ios_build ]
then
    rm -rf $ios_build
fi
mkdir $ios_build

# rebuild AIR build folder
if [ -d $air_build ]
then
    rm -rf $air_build
fi
mkdir $air_build

# rebuild AIR build folder
if [ -d $air_moat_build ]
then
    rm -rf $air_moat_build
fi
mkdir $air_moat_build

# rebuild Flash build folder
if [ -d $flash_build ]
then
    rm -rf $flash_build
fi
mkdir $flash_build

# rebuild Unity build folder
if [ -d $unity_build ]
then
    rm -rf $unity_build
fi
mkdir $unity_build

# rebuild Unity MOAT build folder
if [ -d $unity_moat_build ]
then
    rm -rf $unity_moat_build
fi
mkdir $unity_moat_build

# rebuild KWS iOS build folder
if [ -d $kws_ios_build ]
then
	rm -rf $kws_ios_build
fi
mkdir $kws_ios_build

# rebuild KWS Android build folder
if [ -d $kws_android_build ]
then
	rm -rf $kws_android_build
fi
mkdir $kws_android_build

# rebuild KWS Parent iOS build folder
if [ -d $kws_parent_ios_build ]
then
	rm -rf $kws_parent_ios_build
fi
mkdir $kws_parent_ios_build

# rebuild KWS Parent Android build folder
if [ -d $kws_parent_android_build ]
then
	rm -rf $kws_parent_android_build
fi
mkdir $kws_parent_android_build

cd $build_repo

# create package folder
mkdir -p package
mkdir -p package/air
mkdir -p package/unity
mkdir -p package/flash
mkdir -p package/ios
mkdir -p package/android
mkdir -p package/kws_ios
mkdir -p package/kws_android
mkdir -p package/kws_parent_ios
mkdir -p package/kws_parent_android

# exit
cd

# Awesome Ads & KWS Andrid Prebuild
# cd $build_repo
# . ./01android-prebuild.sh
cd $build_repo
. ./01android.sh
cd $build_repo
. ./02flash.sh
cd $build_repo
. ./04ios-static.sh
cd $build_repo
. ./04ios-framework.sh
cd $build_repo
. ./04ios-static-unity.sh
cd $build_repo
. ./04ios-static-air.sh
cd $build_repo
. ./03air.sh
cd $build_repo
. ./03air_moat.sh
cd $build_repo
. ./05unity.sh
cd $build_repo
. ./05unity-moat.sh

# Kids Web Service Build scripts
cd $build_repo
. ./06kws-ios-static.sh
cd $build_repo
. ./07kws-ios-framework.sh
# cd $build_repo
# . ./08kws-android-prebuild.sh
cd $build_repo
. ./08kws-android.sh
cd $build_repo
. ./09kws-parent-android.sh
cd $build_repo
. ./10kws-parent-ios-static.sh
cd $build_repo
. ./10kws-parent-ios-framework.sh

cd $build_repo
. ./11package.sh

# update the current repo
cd $build_repo
git status
git add --all
git commit -am "update"
git push origin master
