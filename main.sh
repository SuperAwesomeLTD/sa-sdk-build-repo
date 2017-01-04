#!/bin/bash -ex

workspace="/Users/gabriel.coman/Workspace/sa-sdk-build-repo/"

# Awesome Ads SDK versions
aa_project="SuperAwesomeSDK"
aa_version_ios="5.3.15"
aa_version_android="5.3.9"
aa_version_unity="5.1.7"
aa_version_air="5.1.6"
aa_version_flash="3.2.8"

kws_project="KidsWebServicesSDK"
kws_version_ios="2.1.10"
kws_version_android="2.1.7"

kws_parent_project="KidsWebServicesParentSDK"
kws_version_parent_ios="1.0.4"
kws_version_parent_android="1.0.7"

# buildscripts
cd $workspace
./aa-android-build.sh
cd $workspace
./aa-android-moat-build.sh
cd $workspace
./aa-android-mopub-build.sh
cd $workspace
./aa-ios-build-static.sh
cd $workspace
./aa-ios-build-framework.sh
cd $workspace
./aa-flash-build.sh
cd $workspace
./aa-air-build.sh
cd $workspace
./aa-air-moat-build.sh
cd $workspace
./aa-unity-build.sh
cd $workspace
./aa-unity-moat-build.sh

cd $workspace
./kws-ios-build-framework.sh
cd $workspace
./kws-ios-build-static.sh
cd $workspace
./kws-android-build.sh

cd $workspace
./kws-ios-parent-build-framework.sh
cd $workspace
./kws-ios-parent-build-static.sh
cd $workspace
./kws-android-parent-build.sh

# packaging
cd $workspace

# create new versions
mkdir -p package/aa_ios/$aa_version_ios
mkdir -p package/aa_android/$aa_version_android
mkdir -p package/aa_flash/$aa_version_flash
mkdir -p package/aa_air/$aa_version_air
mkdir -p package/aa_unity/$aa_version_unity
mkdir -p package/kws_ios/$kws_version_ios
mkdir -p package/kws_android/$kws_version_android
mkdir -p package/kws_parent_ios/$kws_version_parent_ios
mkdir -p package/kws_parent_android/$kws_version_parent_android

# copy sources
cp aa-ios-build-static/$aa_project.iOS.lib.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.lib.zip
cp aa-ios-build-framework/$aa_project.iOS.framework.zip package/aa_ios/$aa_version_ios/$aa_project-$aa_version_ios.iOS.framework.zip

cp aa-android-build/$aa_project.Android.base.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.base.jars.zip
cp aa-android-moat-build/$aa_project.Android.full.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.full.jars.zip
cp aa-android-mopub-build/$aa_project.Android.MoPubPlugin.jars.zip package/aa_android/$aa_version_android/$aa_project-$aa_version_android.Android.MoPubPlugin.jars.zip

cp aa-flash-build/$aa_project.AdobeFlash.swc package/aa_flash/$aa_version_flash/$aa_project-$aa_version_flash.AdobeFlash.swc

cp aa-air-build/$aa_project.AdobeAIR.ane package/aa_air/$aa_version_air/$aa_project-$aa_version_air.AdobeAIR.base.ane
cp aa-air-moat-build/$aa_project.AdobeAIR.ane package/aa_air/$aa_version_air/$aa_project-$aa_version_air.AdobeAIR.full.ane

cp aa-unity-build/$aa_project.Unity.base.unitypackage package/aa_unity/$aa_version_unity/$aa_project-$aa_version_unity.Unity.base.unitypackage
cp aa-unity-moat-build/$aa_project.Unity.full.unitypackage package/aa_unity/$aa_version_unity/$aa_project-$aa_version_unity.Unity.full.unitypackage

cp kws-ios-build-static/$kws_project.iOS.lib.zip package/kws_ios/$kws_version_ios/$kws_project-$kws_version_ios.iOS.lib.zip
cp kws-ios-build-framework/$kws_project.iOS.framework.zip package/kws_ios/$kws_version_ios/$kws_project-$kws_version_ios.iOS.framework.zip

cp kws-android-build/$kws_project.Android.jars.zip package/kws_android/$kws_version_android/$kws_project-$kws_version_android.Android.jars.zip

cp kws-ios-parent-build-static/$kws_parent_project.iOS.lib.zip package/kws_parent_ios/$kws_version_parent_ios/$kws_parent_project-$kws_version_parent_ios.iOS.lib.zip
cp kws-ios-parent-build-framework/$kws_parent_project.iOS.framework.zip package/kws_parent_ios/$kws_version_parent_ios/$kws_parent_project-$kws_version_parent_ios.iOS.framework.zip

cp kws-android-parent-build/$kws_parent_project.Android.jars.zip package/kws_parent_android/$kws_version_parent_android/$kws_parent_project-$kws_version_parent_android.Android.jars.zip

git status
git commit -am "update"
git push origin master
