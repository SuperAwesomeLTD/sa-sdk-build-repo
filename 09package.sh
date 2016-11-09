#!/bin/bash -ex

cd $build_repo
cd package

# create version folders
cd air
mkdir -p $sdk_version_air
cd ../android
mkdir -p $sdk_version_android
cd ../flash
mkdir -p $sdk_version_flash
cd ../ios
mkdir -p $sdk_version_ios
cd ../unity
mkdir -p $sdk_version_unity
cd ../kws_ios
mkdir -p $sdk_version_kws_ios
cd ../kws_android
mkdir -p $sdk_version_kws_android

cd ../..

# start copying
cp air_build/SuperAwesomeSDK.ane package/air/$sdk_version_air/SuperAwesomeSDK-$sdk_version_air.AdobeAIR.base.ane
cp air_moat_build/SuperAwesomeSDK-Moat.ane package/air/$sdk_version_air/SuperAwesomeSDK-$sdk_version_air.AdobeAIR.full.ane
cp flash_build/SuperAwesomeSDK.swc package/flash/$sdk_version_flash/SuperAwesomeSDK-$sdk_version_flash.AdobeFlash.swc
cp unity_build/SuperAwesomeSDK.unitypackage package/unity/$sdk_version_unity/SuperAwesomeSDK-$sdk_version_unity.Unity.base.unitypackage
cp unity_moat_build/SuperAwesomeSDK-Moat.unitypackage package/unity/$sdk_version_unity/SuperAwesomeSDK-$sdk_version_unity.Unity.full.unitypackage
cp ios_build/SuperAwesomeSDK.lib.zip package/ios/$sdk_version_ios/SuperAwesomeSDK-$sdk_version_ios.iOS.lib.zip
cp ios_build/SuperAwesomeSDK.framework.zip package/ios/$sdk_version_ios/SuperAwesomeSDK-$sdk_version_ios.iOS.framework.zip
cp kws_ios_build/KWSSDK.lib.zip package/kws_ios/$sdk_version_kws_ios/KidsWebServicesSSDK-$sdk_version_kws_ios.iOS.lib.zip
cp kws_ios_build/KWSSDK.framework.zip package/kws_ios/$sdk_version_kws_ios/KidsWebServicesSDK-$sdk_version_kws_ios.iOS.framework.zip

cd

# packaging android builds - full
cd $build_repo
mkdir package/android/$sdk_version_android/android
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
    "superawesome.jar"
    "moatlib.jar"
    "superawesome-res.zip"
)
for i in {0..12}
do cp android_build/${source_libraries_full[$i]} package/android/$sdk_version_android/android
done
cd package/android/$sdk_version_android
zip -r SuperAwesomeSDK-$sdk_version_android.Android.full.jars.zip android
rm -rf android
cd

# packaging android builds - base
cd $build_repo
mkdir package/android/$sdk_version_android/android
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
    "superawesome.jar"
    "superawesome-res.zip"
)
for i in {0..10}
do cp android_build/${source_libraries_base[$i]} package/android/$sdk_version_android/android
done
cd package/android/$sdk_version_android
zip -r SuperAwesomeSDK-$sdk_version_android.Android.base.jars.zip android
rm -rf android
cd

# packaging android mopub
cd $build_repo
cp android_build/samopub.jar package/android/$sdk_version_android
cd package/android/$sdk_version_android
zip SuperAwesomeSDK-$sdk_version_android.Android.MoPubPlugin.jars.zip samopub.jar
rm samopub.jar
cd

# packaging android KWS build
cd $build_repo
mkdir package/kws_android/$sdk_version_kws_android/android
source_libraries_kws=(
		"sautils.jar"
		"sanetwork.jar"
		"sajsonparser.jar"
		"kwssdk.jar"
)
for i in {0..3}
do cp kws_android_build/${source_libraries_kws[$i]} package/kws_android/$sdk_version_kws_android/android
done
cd package/kws_android/$sdk_version_kws_android
zip -r KidsWebServicesSDK-$sdk_version_kws_android.Android.jars.zip android
rm -rf android
cd
