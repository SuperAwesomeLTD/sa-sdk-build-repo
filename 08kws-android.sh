#!/bin/bash -ex

################################################################################
# 1) Move all AARs into JARs
################################################################################

# start
cd

source_folders=(
    "$workspace/sa-mobile-lib-android-jsonparser/sajsonparser"
    "$workspace/sa-mobile-lib-android-utils/sautils"
    "$workspace/sa-mobile-lib-android-network/sanetwork"
    "$workspace/sa-kws-android-sdk/kwssdk"
)
source_libraries=(
    "sajsonparser"
    "sautils"
    "sanetwork"
    "kwssdk"
)

for i in {0..3}
do
    # create different targets
    source_aar="${source_libraries[$i]}-debug.aar"
    dest_zip="${source_libraries[$i]}-release.zip"
    tmp_folder="${source_libraries[$i]}-release"
    dest_jar="${source_libraries[$i]}.jar"

    # these two are the full source paths to the AAR that I need to take
    # and the ZIP file that I want to move it to
    full_source="${source_folders[$i]}/build/outputs/aar/$source_aar"
    full_dest="$kws_android_build/$dest_zip"

    # perform copy
    cp $full_source $full_dest

    # go in
    cd $kws_android_build

    # perform operation
    mkdir $tmp_folder
    unzip $dest_zip -d $tmp_folder
    cp $tmp_folder/classes.jar $dest_jar
    rm -rf $tmp_folder
    rm -rf $dest_zip

    # go out
    cd
done

# exit
cd

################################################################################
# 2) Write the manifest
################################################################################

# Write the Manifest

# start
cd

# goto build folder
cd $kws_android_build

# write to file
androidManifest="AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"kws.superawesome.tv.kwssdk\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"com.google.android.c2dm.permission.RECEIVE\" />" >> $androidManifest
echo "<application android:allowBackup=\"true\"></application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

# exit
cd
