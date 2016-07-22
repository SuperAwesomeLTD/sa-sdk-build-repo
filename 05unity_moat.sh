#!/bin/bash -ex

unity_dir="$workspace/sa-unity-sdk"
unity_assets_dir="$unity_dir/demo/Assets"
unity_plugins_dir="$unity_assets_dir/Plugins"
unity_sa_dir="$unity_assets_dir/SuperAwesome"
unity_android_dir="$unity_plugins_dir/Android"
unity_ios_dir="$unity_plugins_dir/iOS"

# ##############################################################################
# 1) Prepare
# ##############################################################################

# start
cd
rm -rf $unity_plugins_dir
mkdir $unity_plugins_dir
mkdir $unity_android_dir
mkdir $unity_ios_dir

# ##############################################################################
# 2) Copy iOS
# ##############################################################################

cp $ios_build_static_result/libSuperAwesomeSDKUnity.a $unity_ios_dir
cp -r $ios_build_static_result/include/SuperAwesomeSDKUnity/* $unity_ios_dir
cp -r $workspace/sa-mobile-lib-ios-events/Pod/Plugin/Moat/* $unity_ios_dir
cp -r $workspace/sa-mobile-lib-ios-events/Pod/Libraries/* $unity_ios_dir

# ##############################################################################
# 3) Copy Android
# ##############################################################################

# create some dirs
mkdir "$unity_android_dir/res"
mkdir "$unity_android_dir/SuperAwesome_lib"

# copy some files
cp -r "$android_build/superawesome-res/" "$unity_android_dir/res"
cp $android_build/AndroidManifest.xml $unity_android_dir/SuperAwesome_lib/
unity_libs=(
    "samodelspace"
    "saadloader"
    "saevents"
    "samoatevents"
    "sajsonparser"
    "sautils"
    "savastparser"
    "sasession"
    "savideoplayer"
    "sawebplayer"
    "sanetwork"
    "superawesome-$sdk_version_android"
    "saunity"
    "moatlib"
)
for i in {0..13}
do cp $android_build/${unity_libs[$i]}.jar $unity_android_dir/
done

# create
cd "$unity_android_dir/SuperAwesome_lib"
projectProperties="project.properties"
echo "# Project target." > $projectProperties
echo "target=android-11" >> $projectProperties
echo "android.library=true" >> $projectProperties

cd

##############################################################################
# 4) Build product
##############################################################################

/Applications/Unity4/Unity.app/Contents/MacOS/Unity -batchmode -projectPath "$unity_dir/demo" -exportPackage "Assets/Plugins" "Assets/SuperAwesome" "$unity_moat_build/SuperAwesomeSDK-Moat-$sdk_version_unity.unitypackage" -quit
