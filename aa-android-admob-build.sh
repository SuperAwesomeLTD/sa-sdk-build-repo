#!/bin/bash -ex

# build folder for all the jars
build="aa-android-admob-build"
# project
project="SuperAwesomeSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

source="sa-mobile-sdk-android"
destination="saadmob"
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

cd $source

# add local properties
localProperties="local.properties"
echo "sdk.dir=/Users/gabriel.coman/Library/Android/sdk" >> $localProperties

# clean and build the whole project
./gradlew build

cp saadmob/build/outputs/aar/saadmob-release.aar ../$build/saadmob.zip

cd ../$build

unzip saadmob.zip -d saadmob && rm saadmob.zip
cp saadmob/classes.jar $project.Android.AdMobPlugin.jar && rm -rf saadmob

zip $project.Android.AdMobPlugin.jars.zip $project.Android.AdMobPlugin.jar && rm -rf $project.Android.AdMobPlugin.jar

# exit
cd
