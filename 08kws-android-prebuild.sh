#!/bin/bash -ex

cd $workspace

lib_folders_to_build=(
    "sa-kws-android-sdk"
		"sa-kws-parent-android-sdk"
)
for i in {0..2}
do
    cd ${lib_folders_to_build[$i]}
    ./gradlew clean
    ./gradlew build
    cd ..
done
