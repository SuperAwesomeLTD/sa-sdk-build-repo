#!/bin/bash -ex

workspace="/Users/gabriel.coman/Workspace/sa-sdk-build-repo/"

# Awesome Ads SDK - Publishers versions
aa_project="SuperAwesomeSDK"
aa_version_ios="6.1.9"
aa_version_android="6.1.6"
aa_version_unity="6.1.5"
aa_version_air="6.1.5"
aa_version_flash="3.2.9"

# Awesome Ads SDK - Advertisers versions
adv_project="SuperAwesomeAdvertiserSDK"
adv_version_ios="1.0.9"
adv_version_android="1.0.5"
adv_version_unity="1.0.2"
adv_version_air="1.0.4"

# Awesome Ads SDK - Age Gate version
ag_project="SAAgeGateSDK"
ag_version_ios="1.0.7"
ag_version_android="1.0.3"
ag_version_unity="1.0.1"
ag_version_air="1.0.1"

# KWS - Children
kws_project="KidsWebServicesSDK"
kws_version_ios="2.3.6"
kws_version_android="2.3.3"

# KWS - Parents
kws_parent_project="KidsWebServicesParentSDK"
kws_version_parent_ios="1.2.0"
kws_version_parent_android="1.2.0"

# buildscripts
# cd $workspace
# ./aa-android-build.sh
cd $workspace
./aa-android-moat-build.sh
cd $workspace
./aa-android-mopub-build.sh
cd $workspace
./aa-android-admob-build.sh
cd $workspace
./aa-ios-build-static.sh
cd $workspace
./aa-ios-build-framework.sh
cd $workspace
./aa-ios-mopub-build.sh
cd $workspace
./aa-ios-admob-build.sh
# cd $workspace
# ./aa-flash-build.sh
# cd $workspace
# ./aa-air-build.sh
# cd $workspace
# ./aa-air-moat-build.sh
# cd $workspace
# ./aa-unity-build.sh
# cd $workspace
# ./aa-unity-moat-build.sh

# cd $workspace
# ./adv-ios-build-static.sh
# cd $workspace
# ./adv-ios-build-framework.sh
# cd $workspace
# ./adv-android-build.sh
# cd $workspace
# ./adv-air-build.sh
# cd $workspace
# ./adv-unity-build.sh

# cd $workspace
# ./ag-ios-build-static.sh
# cd $workspace
# ./ag-ios-build-framework.sh
# cd $workspace
# ./ag-android-build.sh
# cd $workspace
# ./ag-air-build.sh
# cd $workspace
# ./ag-unity-build.sh

# cd $workspace
# ./kws-ios-build-framework.sh
# cd $workspace
# ./kws-ios-build-static.sh
# cd $workspace
# ./kws-android-build.sh

# cd $workspace
# ./kws-ios-parent-build-framework.sh
# cd $workspace
# ./kws-ios-parent-build-static.sh
# cd $workspace
# ./kws-android-parent-build.sh

# packaging
cd $workspace

# create new versions
mkdir -p package/aa_ios/$aa_version_ios
mkdir -p package/aa_android/$aa_version_android
mkdir -p package/aa_flash/$aa_version_flash
mkdir -p package/aa_air/$aa_version_air
mkdir -p package/aa_unity/$aa_version_unity

mkdir -p package/adv_ios/$adv_version_ios
mkdir -p package/adv_android/$adv_version_android
mkdir -p package/adv_unity/$adv_version_unity
mkdir -p package/adv_air/$adv_version_air

mkdir -p package/ag_ios/$ag_version_ios
mkdir -p package/ag_android/$ag_version_android
mkdir -p package/ag_unity/$ag_version_unity
mkdir -p package/ag_air/$ag_version_air

mkdir -p package/kws_ios/$kws_version_ios
mkdir -p package/kws_android/$kws_version_android
mkdir -p package/kws_parent_ios/$kws_version_parent_ios
mkdir -p package/kws_parent_android/$kws_version_parent_android

# copy sources
cp aa-ios-build-static/$aa_project.iOS.lib.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.lib.zip
cp aa-ios-build-framework/$aa_project.iOS.framework.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.framework.zip
cp aa-ios-mopub-build/$aa_project.iOS.MoPubPlugin.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.MoPubPlugin.zip
cp aa-ios-admob-build/$aa_project.iOS.AdMobPlugin.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.AdMobPlugin.zip

cp aa-android-build/$aa_project.Android.base.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.base.jars.zip
cp aa-android-moat-build/$aa_project.Android.full.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.full.jars.zip
cp aa-android-mopub-build/$aa_project.Android.MoPubPlugin.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.MoPubPlugin.jars.zip
cp aa-android-admob-build/$aa_project.Android.AdMobPlugin.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.AdMobPlugin.jars.zip
#
# cp aa-flash-build/$aa_project.AdobeFlash.swc package/aa_flash/$aa_version_flash/$aa_project-$aa_version_flash.AdobeFlash.swc
#
# cp aa-air-build/$aa_project.AdobeAIR.ane package/aa_air/$aa_version_air/$aa_project-$aa_version_air.AdobeAIR.base.ane
# cp aa-air-moat-build/$aa_project.AdobeAIR.ane package/aa_air/$aa_version_air/$aa_project-$aa_version_air.AdobeAIR.full.ane

# cp aa-unity-build/$aa_project.Unity.base.unitypackage package/aa_unity/$aa_version_unity/$aa_project-$aa_version_unity.Unity.base.unitypackage
# cp aa-unity-moat-build/$aa_project.Unity.full.unitypackage package/aa_unity/$aa_version_unity/$aa_project-$aa_version_unity.Unity.full.unitypackage

# cp adv-ios-build-static/$adv_project.iOS.lib.zip package/adv_ios/$adv_version_ios/$adv_project-$adv_version_ios.iOS.lib.zip
# cp adv-ios-build-framework/$adv_project.iOS.framework.zip package/adv_ios/$adv_version_ios/$adv_project-$adv_version_ios.iOS.framework.zip
# cp adv-android-build/$adv_project.Android.base.jars.zip package/adv_android/$adv_version_android/$adv_project-$adv_version_android.Android.jars.zip
# cp adv-air-build/$adv_project.AdobeAIR.ane package/adv_air/$adv_version_air/$adv_project-$adv_version_air.AdobeAIR.ane
# cp adv-unity-build/$adv_project.Unity.base.unitypackage package/adv_unity/$adv_version_unity/$adv_project-$adv_version_unity.Unity.unitypackage

# cp ag-ios-build-static/$ag_project.iOS.lib.zip package/ag_ios/$ag_version_ios/$ag_project-$ag_version_ios.iOS.lib.zip
# cp ag-ios-build-framework/$ag_project.iOS.framework.zip package/ag_ios/$ag_version_ios/$ag_project-$ag_version_ios.iOS.framework.zip
# cp ag-android-build/$ag_project.Android.base.jars.zip package/ag_android/$ag_version_android/$ag_project-$ag_version_android.Android.jars.zip
# cp ag-air-build/$ag_project.AdobeAIR.ane package/ag_air/$ag_version_air/$ag_project-$ag_version_air.AdobeAIR.ane
# cp ag-unity-build/$ag_project.Unity.base.unitypackage package/ag_unity/$ag_version_unity/$ag_project-$ag_version_unity.Unity.unitypackage

# cp kws-ios-build-static/$kws_project.iOS.lib.zip package/kws_ios/$kws_version_ios/$kws_project-$kws_version_ios.iOS.lib.zip
# cp kws-ios-build-framework/$kws_project.iOS.framework.zip package/kws_ios/$kws_version_ios/$kws_project-$kws_version_ios.iOS.framework.zip
#
# cp kws-android-build/$kws_project.Android.jars.zip package/kws_android/$kws_version_android/$kws_project-$kws_version_android.Android.jars.zip
#
# cp kws-ios-parent-build-static/$kws_parent_project.iOS.lib.zip package/kws_parent_ios/$kws_version_parent_ios/$kws_parent_project-$kws_version_parent_ios.iOS.lib.zip
# cp kws-ios-parent-build-framework/$kws_parent_project.iOS.framework.zip package/kws_parent_ios/$kws_version_parent_ios/$kws_parent_project-$kws_version_parent_ios.iOS.framework.zip
#
# cp kws-android-parent-build/$kws_parent_project.Android.jars.zip package/kws_parent_android/$kws_version_parent_android/$kws_parent_project-$kws_version_parent_android.Android.jars.zip

git status
git add *
git commit -am "update"
git push origin master
