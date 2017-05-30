#!/bin/bash -ex

# build folder for all the jars
build="aa-ios-admob-build"
# project
project="SuperAwesomeSDK"

# create the build folder
rm -rf $build && mkdir $build
mkdir $build/AdMob

################################################################################
# Get all the .h and .m files associated w/ the SDK
################################################################################

source="sa-mobile-sdk-ios"
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

cp -r $source/Pod/Plugin/AdMob/* $build/AdMob
rm -rf $source

# zip the files
cd $build

zip -r $project.iOS.AdMobPlugin.zip AdMob && rm -rf AdMob

cd ../
