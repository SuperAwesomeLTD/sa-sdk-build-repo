#!/bin/bash -ex

################################################################################
# 1) Move all AARs into JARs
################################################################################

# start
cd

source_folders=(
    "$workspace/sa-mobile-lib-android-modelspace/samodelspace"
    "$workspace/sa-mobile-lib-android-adloader/saadloader"
    "$workspace/sa-mobile-lib-android-events/saevents"
    "$workspace/sa-mobile-lib-android-events/samoatevents"
    "$workspace/sa-mobile-lib-android-jsonparser/sajsonparser"
    "$workspace/sa-mobile-lib-android-utils/sautils"
    "$workspace/sa-mobile-lib-android-session/sasession"
    "$workspace/sa-mobile-lib-android-videoplayer/savideoplayer"
    "$workspace/sa-mobile-lib-android-webplayer/sawebplayer"
    "$workspace/sa-mobile-lib-android-network/sanetwork"
    "$workspace/sa-mobile-sdk-android/demo/superawesome-base"
    "$workspace/sa-mobile-sdk-android/demo/saair"
    "$workspace/sa-mobile-sdk-android/demo/saunity"
    "$workspace/sa-mobile-sdk-android/demo/samopub"
)
source_libraries=(
    "samodelspace"
    "saadloader"
    "saevents"
    "samoatevents"
    "sajsonparser"
    "sautils"
    "sasession"
    "savideoplayer"
    "sawebplayer"
    "sanetwork"
    "superawesome-base"
    "saair"
    "saunity"
    "samopub"
)

for i in {0..13}
do
    # create different targets
    source_aar="${source_libraries[$i]}-debug.aar"
    dest_zip="${source_libraries[$i]}-release.zip"
    tmp_folder="${source_libraries[$i]}-release"
    dest_jar="${source_libraries[$i]}.jar"

    # these two are the full source paths to the AAR that I need to take
    # and the ZIP file that I want to move it to
    full_source="${source_folders[$i]}/build/outputs/aar/$source_aar"
    full_dest="$android_build/$dest_zip"

    # perform copy
    cp $full_source $full_dest

    # go in
    cd $android_build

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
# 1.1) Add versioning to the main SDK
################################################################################

# start
cd

cd $android_build
mv superawesome-base.jar superawesome.jar

# exit
cd

################################################################################
# 1.2) Add the Moat lib
################################################################################

# start
cd

cp "$workspace/sa-mobile-lib-android-events/samoatevents/libs/moatlib.jar" "$android_build/moatlib.jar"

# exit
cd

################################################################################
# 2) Get All Aux Resources
################################################################################

# start
cd

source_drawables="$workspace/sa-mobile-sdk-android/demo/superawesome-base/src/main/res/drawable"
source_layouts="$workspace/sa-mobile-sdk-android/demo/superawesome-base/src/main/res/layout"
dest_res="$android_build/superawesome-res"
dest_drawables="$dest_res/drawable"
dest_layouts="$dest_res/layout"

mkdir $dest_res
mkdir $dest_drawables
mkdir $dest_layouts
cp -r "$source_drawables/" "$dest_drawables/"
cp -r "$source_layouts/" "$dest_layouts/"
cd $android_build
zip -r superawesome-res.zip superawesome-res

# exit
cd

################################################################################
# 3) Write the manifest
################################################################################

# Write the Manifest

# start
cd

# goto build folder
cd $android_build

# write to file
androidManifest="AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAVideoAd\" android:label=\"SAFullscreenVideoAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAInterstitialAd\" android:label=\"SAInterstitialAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAGameWall\" android:label=\"SAGameWall\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sanetwork.asynctask.SAAsyncTask\$SAAsync\" android:exported=\"false\"/>" >> $androidManifest
echo "<receiver android:name=\"tv.superawesome.sdk.cpi.SACPI\" android:exported=\"true\">" >> $androidManifest
echo "<intent-filter><action android:name=\"com.android.vending.INSTALL_REFERRER\"/></intent-filter>" >> $androidManifest
echo "</receiver>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

# exit
cd
