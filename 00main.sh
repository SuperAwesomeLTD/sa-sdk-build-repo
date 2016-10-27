#!/bin/bash -ex

# SDK versions
sdk_version_ios="5.2.6"
sdk_version_android="5.2.8"
sdk_version_unity="5.1.3"
sdk_version_air="5.1.2"
sdk_version_flash="3.2.8"
sdk_version_kws_ios="1.3.0"
sdk_version_kws_android="1.2.3"
sdk_version_web="2.0.0"
sdk_version_kws="1.1.0"

# other variables
homey="/Users/gabriel.coman"
workspace="$homey/Workspace"
build_repo="$workspace/sa-sdk-build-repo"
android_build="$build_repo/android_build"
flash_build="$build_repo/flash_build"
air_build="$build_repo/air_build"
air_moat_build="$build_repo/air_moat_build"
unity_build="$build_repo/unity_build"
unity_moat_build="$build_repo/unity_moat_build"
ios_build="$build_repo/ios_build"
package_file="$build_repo/package"

# start
cd

# rebuild Android build folder
if [ -d $android_build ]
then
    rm -rf $android_build
fi
mkdir $android_build

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

# rebuild iOS build folder
if [ -d $ios_build ]
then
    rm -rf $ios_build
fi
mkdir $ios_build

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

cd $build_repo

# create package folder
mkdir -p package
mkdir -p package/air
mkdir -p package/unity
mkdir -p package/flash
mkdir -p package/ios
mkdir -p package/android

# exit
cd

# start other scripts
cd $build_repo
. ./01android_prebuild.sh
cd $build_repo
. ./01android.sh
cd $build_repo
. ./02flash.sh
cd $build_repo
. ./03air.sh
cd $build_repo
. ./03air_moat.sh
cd $build_repo
. ./04ios-static.sh
cd $build_repo
. ./04ios-framework.sh
cd $build_repo
. ./04ios-static-unity.sh
cd $build_repo
. ./05unity.sh
cd $build_repo
. ./05unity_moat.sh
cd $build_repo
. ./06package.sh

# update the current repo
cd $build_repo
git status
git add --all
git commit -am "update"
git push origin master
