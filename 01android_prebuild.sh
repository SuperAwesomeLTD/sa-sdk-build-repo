#!/bin/bash -ex

cd $workspace

lib_folders_to_build=(
    "sa-mobile-lib-android-adloader"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-session"
    "sa-mobile-lib-android-utils"
    "sa-mobile-lib-android-videoplayer"
    "sa-mobile-lib-android-webplayer"
    "sa-mobile-sdk-android"
		"sa-kws-android-sdk"
)
for i in {0..10}
do
    cd ${lib_folders_to_build[$i]}
    ./gradlew clean
    ./gradlew build
    cd ..
done
