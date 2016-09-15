#!/bin/bash -ex

cd $build_repo

# copy
cp air_build/SuperAwesomeSDK-$sdk_version_air.ane package/SuperAwesomeSDK-$sdk_version_air.AdobeAIR.base.ane
cp air_moat_build/SuperAwesomeSDK-Moat-$sdk_version_air.ane package/SuperAwesomeSDK-$sdk_version_air.AdobeAIR.full.ane
cp flash_build/SuperAwesomeSDK-$sdk_version_flash.swc package/SuperAwesomeSDK-$sdk_version_flash.AdobeFlash.swc
cp unity_build/SuperAwesomeSDK-$sdk_version_unity.unitypackage package/SuperAwesomeSDK-$sdk_version_unity.Unity.base.unitypackage
cp unity_moat_build/SuperAwesomeSDK-Moat-$sdk_version_unity.unitypackage package/SuperAwesomeSDK-$sdk_version_unity.Unity.full.unitypackage
cp ios_build/SuperAwesomeSDK-$sdk_version_ios.lib.zip package/SuperAwesomeSDK-$sdk_version_ios.iOS.lib.zip
cp ios_build/SuperAwesomeSDK-$sdk_version_ios.framework.zip package/SuperAwesomeSDK-$sdk_version_ios.iOS.framework.zip

cd

# packaging android builds - full
cd $build_repo
mkdir package/android
source_libraries_full=(
    "samodelspace.jar"
    "saadloader.jar"
    "saevents.jar"
    "samoatevents.jar"
    "sajsonparser.jar"
    "sautils.jar"
    "sasession.jar"
    "savideoplayer.jar"
    "sawebplayer.jar"
    "sanetwork.jar"
    "superawesome-$sdk_version_android.jar"
    "moatlib.jar"
    "superawesome-res.zip"
)
for i in {0..12}
do cp android_build/${source_libraries_full[$i]} package/android/
done
cd package
zip -r SuperAwesomeSDK-$sdk_version_android.Android.full.jars.zip android
rm -rf android
cd

# packaging android builds - base
cd $build_repo
mkdir package/android
source_libraries_base=(
    "samodelspace.jar"
    "saadloader.jar"
    "saevents.jar"
    "sajsonparser.jar"
    "sautils.jar"
    "sasession.jar"
    "savideoplayer.jar"
    "sawebplayer.jar"
    "sanetwork.jar"
    "superawesome-$sdk_version_android.jar"
    "superawesome-res.zip"
)
for i in {0..10}
do cp android_build/${source_libraries_base[$i]} package/android/
done
cd package
zip -r SuperAwesomeSDK-$sdk_version_android.Android.base.jars.zip android
rm -rf android
cd

# packaging android mopub
cd $build_repo
cp android_build/samopub.jar package/
cd package
zip SuperAwesomeSDK-$sdk_version_android.Android.MoPubPlugin.jars.zip samopub.jar
rm samopub.jar
cd
