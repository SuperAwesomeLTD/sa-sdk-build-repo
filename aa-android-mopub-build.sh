#!/bin/bash -ex

# build folder for all the jars
build="aa-android-mopub-build"
# project
project="SuperAwesomeSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

source="sa-mobile-sdk-android"
destination="samopub"
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

cd $source

# add local properties
localProperties="local.properties"
echo "sdk.dir=/Users/gabriel.coman/Library/Android/sdk" >> $localProperties

# clean and build the whole project
./gradlew build

cp samopub/build/outputs/aar/samopub-release.aar ../$build/samopub.zip

cd ../$build

unzip samopub.zip -d samopub && rm samopub.zip
cp samopub/classes.jar $project.Android.MoPubPlugin.jar && rm -rf samopub

zip $project.Android.MoPubPlugin.jars.zip $project.Android.MoPubPlugin.jar && rm -rf $project.Android.MoPubPlugin.jar

# exit
cd
