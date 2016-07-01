#!/bin/bash -ex

ios_sdk_version="3.2.1"
android_sdk_version="4.0.0"
air_sdk_version="3.2.1"
flash_sdk_version="3.2.4"

# ##############################################################################
# Prepare
# ##############################################################################

if [ -d android_build ]
then
    rm -rf android_build
fi
mkdir android_build
if [ -d air_build ]
then
    rm -rf air_build
fi
mkdir air_build
if [ -d ios_build ]
then
    rm -rf ios_build
fi
mkdir ios_build
if [ -d flash_build ]
then
    rm -rf flash_build
fi
mkdir flash_build

cd ../

# ##############################################################################
# Android
# ##############################################################################

cp sa-mobile-lib-android-modelspace/samodelspace/build/outputs/aar/samodelspace-release.aar sa-sdk-build-repo/android_build/samodelspace-release.zip
cp sa-mobile-lib-android-adloader/saadloader/build/outputs/aar/saadloader-release.aar sa-sdk-build-repo/android_build/saadloader-release.zip
cp sa-mobile-lib-android-events/saevents/build/outputs/aar/saevents-release.aar sa-sdk-build-repo/android_build/saevents-release.zip
cp sa-mobile-lib-android-events/samoatevents/build/outputs/aar/samoatevents-release.aar sa-sdk-build-repo/android_build/samoatevents-release.zip
cp sa-mobile-lib-android-jsonparser/sajsonparser/build/outputs/aar/sajsonparser-release.aar sa-sdk-build-repo/android_build/sajsonparser-release.zip
cp sa-mobile-lib-android-utils/sautils/build/outputs/aar/sautils-release.aar sa-sdk-build-repo/android_build/sautils-release.zip
cp sa-mobile-lib-android-vastparser/savastparser/build/outputs/aar/savastparser-release.aar sa-sdk-build-repo/android_build/savastparser-release.zip
cp sa-mobile-lib-android-videoplayer/savideoplayer/build/outputs/aar/savideoplayer-release.aar sa-sdk-build-repo/android_build/savideoplayer-release.zip
cp sa-mobile-lib-android-webplayer/sawebplayer/build/outputs/aar/sawebplayer-release.aar sa-sdk-build-repo/android_build/sawebplayer-release.zip
cp sa-mobile-sdk-android/superawesomesdk/sa-sdk/build/outputs/aar/sa-sdk-release.aar sa-sdk-build-repo/android_build/sa-sdk-release.zip
cp sa-mobile-sdk-android/demo/saair/build/outputs/aar/saair-release.aar sa-sdk-build-repo/android_build/saair-release.zip
cp sa-mobile-sdk-android/demo/saunity/build/outputs/aar/saunity-release.aar sa-sdk-build-repo/android_build/saunity-release.zip
cp sa-mobile-sdk-android/demo/samopub/build/outputs/aar/samopub-release.aar sa-sdk-build-repo/android_build/samopub-release.zip

cd sa-sdk-build-repo/android_build

mkdir sa-mobile-lib-android-modelspace
unzip samodelspace-release.zip -d sa-mobile-lib-android-modelspace/
cp sa-mobile-lib-android-modelspace/classes.jar samodelspace.jar
rm -rf sa-mobile-lib-android-modelspace
rm samodelspace-release.zip

mkdir sa-mobile-lib-android-adloader
unzip saadloader-release.zip -d sa-mobile-lib-android-adloader/
cp sa-mobile-lib-android-adloader/classes.jar saadloader.jar
rm -rf sa-mobile-lib-android-adloader
rm saadloader-release.zip

mkdir sa-mobile-lib-android-events
unzip saevents-release.zip -d sa-mobile-lib-android-events/
cp sa-mobile-lib-android-events/classes.jar saevents.jar
rm -rf sa-mobile-lib-android-events
rm saevents-release.zip

mkdir sa-mobile-lib-android-events
unzip samoatevents-release.zip -d sa-mobile-lib-android-events/
cp sa-mobile-lib-android-events/classes.jar samoatevents.jar
rm -rf sa-mobile-lib-android-events
rm samoatevents-release.zip

mkdir sa-mobile-lib-android-jsonparser
unzip sajsonparser-release.zip -d sa-mobile-lib-android-jsonparser/
cp sa-mobile-lib-android-jsonparser/classes.jar sajsonparser.jar
rm -rf sa-mobile-lib-android-jsonparser
rm sajsonparser-release.zip

mkdir sa-mobile-lib-android-utils
unzip sautils-release.zip -d sa-mobile-lib-android-utils/
cp sa-mobile-lib-android-utils/classes.jar sautils.jar
rm -rf sa-mobile-lib-android-utils
rm sautils-release.zip

mkdir sa-mobile-lib-android-vastparser
unzip savastparser-release.zip -d sa-mobile-lib-android-vastparser/
cp sa-mobile-lib-android-vastparser/classes.jar savastparser.jar
rm -rf sa-mobile-lib-android-vastparser
rm savastparser-release.zip

mkdir sa-mobile-lib-android-videoplayer
unzip savideoplayer-release.zip -d sa-mobile-lib-android-videoplayer/
cp sa-mobile-lib-android-videoplayer/classes.jar savideoplayer.jar
rm -rf sa-mobile-lib-android-videoplayer
rm savideoplayer-release.zip

mkdir sa-mobile-lib-android-webplayer
unzip sawebplayer-release.zip -d sa-mobile-lib-android-webplayer/
cp sa-mobile-lib-android-webplayer/classes.jar sawebplayer.jar
rm -rf sa-mobile-lib-android-webplayer
rm sawebplayer-release.zip

mkdir saair
unzip saair-release.zip -d saair/
cp saair/classes.jar saair.jar
rm -rf saair
rm saair-release.zip

mkdir saunity
unzip saunity-release.zip -d saunity/
cp saunity/classes.jar saunity.jar
rm -rf saunity
rm saunity-release.zip

mkdir samopub
unzip samopub-release.zip -d samopub/
cp samopub/classes.jar samopub.jar
rm -rf samopub
rm samopub-release.zip

mkdir sa-sdk
unzip sa-sdk-release.zip -d sa-sdk/
cp sa-sdk/classes.jar sa-sdk-$android_sdk_version.jar
rm -rf sa-sdk
rm sa-sdk-release.zip

# Get Resources
mkdir sa-sdk-res
mkdir sa-sdk-res/drawable
mkdir sa-sdk-res/layout
cd ../..
cp -r sa-mobile-sdk-android/superawesomesdk/sa-sdk/src/main/res/drawable/* sa-sdk-build-repo/android_build/sa-sdk-res/drawable/
cp -r sa-mobile-sdk-android/superawesomesdk/sa-sdk/src/main/res/layout/* sa-sdk-build-repo/android_build/sa-sdk-res/layout
cd sa-sdk-build-repo/android_build
zip -r sa-sdk-res.zip sa-sdk-res
rm -rf sa-sdk-res

# Write the Manifest
androidManifest="AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.WRITE_EXTERNAL_STORAGE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAFullscreenVideoAd$SAFullscreenVideoAdActivity\" android:label=\"SAFullscreenVideoAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAInterstitialAd$SAInterstitialAdActivity\" android:label=\"SAInterstitialAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sautils.SAAsyncTask$SAAsync\" android:exported=\"false\"/>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

cd ..

# ##############################################################################
# AIR
# ##############################################################################

mkdir air_build/android
mkdir air_build/default
cp android_build/samodelspace.jar air_build/android
cp android_build/sajsonparser.jar air_build/android
cp android_build/saevents.jar air_build/android
cp android_build/savastparser.jar air_build/android
cp android_build/sautils.jar air_build/android
cp android_build/savideoplayer.jar air_build/android
cp android_build/sawebplayer.jar air_build/android
cp android_build/saadloader.jar air_build/android
cp android_build/sa-sdk-$android_sdk_version.jar air_build/android
cp android_build/saair.jar air_build/android
cp android_build/sa-sdk-res.zip air_build/android
cp presets/play-services-ads-8.4.0.jar air_build/android
cp presets/play-services-base-8.4.0.jar air_build/android
cp presets/play-services-basement-8.4.0.jar air_build/android
cd air_build/android
mkdir res
mkdir res/drawable
mkdir res/layout
unzip sa-sdk-res.zip -d res
rm sa-sdk-res.zip
cp -r res/sa-sdk-res/layout/* res/layout/
cp -r res/sa-sdk-res/drawable/* res/drawable/
rm -rf res/sa-sdk-res
cd ../../..
cp sa-adobeair-sdk/bin/SuperAwesome_AIR.swc sa-sdk-build-repo/air_build/
cd sa-sdk-build-repo/air_build
cp SuperAwesome_AIR.swc SuperAwesome_AIR.zip
mkdir tmp
unzip SuperAwesome_AIR.zip -d tmp
cp tmp/library.swf android/
cp tmp/library.swf default/
rm -rf tmp
rm SuperAwesome_AIR.zip
# write to file
extensionFile="extension.xml"
echo "<extension xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $extensionFile
echo "<id>tv.superawesome.plugins.air</id>" >> $extensionFile
echo "<versionNumber>1.0.0</versionNumber>" >> $extensionFile
echo "<platforms>" >> $extensionFile
echo "<platform name=\"Android-ARM\">" >> $extensionFile
echo "<applicationDeployment> " >> $extensionFile
echo "<nativeLibrary>saair.jar</nativeLibrary>" >> $extensionFile
echo "<initializer>tv.superawesome.plugins.air.SAAIRExtension</initializer>" >> $extensionFile
echo "</applicationDeployment>" >> $extensionFile
echo "</platform>" >> $extensionFile
echo "<platform name=\"default\">" >> $extensionFile
echo "<applicationDeployment/>" >> $extensionFile
echo "</platform>" >> $extensionFile
echo "</platforms>" >> $extensionFile
echo "</extension>" >> $extensionFile
# write to second file
platformFile="platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $platformFile
echo "<packagedDependencies>" >> $platformFile
echo "<packagedDependency>sautils.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>saevents.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>sajsonparser.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>samodelspace.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>savastparser.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>savideoplayer.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>saadloader.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>sawebplayer.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>sa-sdk-$android_sdk_version.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>play-services-ads-8.4.0.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>play-services-base-8.4.0.jar</packagedDependency>" >> $platformFile
echo "<packagedDependency>play-services-basement-8.4.0.jar</packagedDependency>" >> $platformFile
echo "</packagedDependencies>" >> $platformFile
echo "<packagedResources>" >> $platformFile
echo "<packagedResource>" >> $platformFile
echo "<packageName>tv.superawesome.sdk</packageName>" >> $platformFile
echo "<folderName>res</folderName>" >> $platformFile
echo "</packagedResource>" >> $platformFile
echo "</packagedResources>" >> $platformFile
echo "</platform>" >> $platformFile
# build
/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/21.0.0/bin/adt -package -target ane SAAIR-$air_sdk_version.ane extension.xml -swc SuperAwesome_AIR.swc -platform Android-ARM -C android . -platformoptions platform.xml -platform default -C default .
cd ../..

# ##############################################################################
# iOS - Static Lib
# ##############################################################################

cd sa-mobile-sdk-ios-staticlib
./make.sh
/usr/bin/xcodebuild -target UniversalLib -configuration Release
cd ../
cp sa-mobile-sdk-ios-staticlib/output/libSuperAwesomeSDK.zip sa-sdk-build-repo/ios_build/libSuperAwesomeSDK-$ios_sdk_version.zip

# ##############################################################################
# iOS - Framework
# ##############################################################################

cd sa-mobile-sdk-ios-framework
./make.sh
/usr/bin/xcodebuild -target "Build framework" -configuration Release
cd ../
cp sa-mobile-sdk-ios-framework/output/SuperAwesomeSDK.framework.zip sa-sdk-build-repo/ios_build/SuperAwesomeSDK-$ios_sdk_version.framework.zip

# ##############################################################################
# Unity
# ##############################################################################

cd sa-unity-sdk/demo/Assets/Plugins
if [ -d Android ]
then
    rm -rf Android
fi
mkdir Android
mkdir Android/SuperAwesome_lib
mkdir Android/res/
mkdir Android/res/drawable
mkdir Android/res/layout
cd ../../../..
cp sa-sdk-build-repo/android_build/$androidManifest sa-unity-sdk/demo/Assets/Plugins/Android/SuperAwesome_lib/
cp sa-sdk-build-repo/android_build/sa-sdk-$android_sdk_version.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/saadloader.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/saevents.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/sajsonparser.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/samodelspace.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/saunity.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/sautils.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/savastparser.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/savideoplayer.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cp sa-sdk-build-repo/android_build/sawebplayer.jar sa-unity-sdk/demo/Assets/Plugins/Android/
cd sa-unity-sdk/demo/Assets/Plugins/Android/SuperAwesome_lib
projectProperties="project.properties"
echo "# Project target." > $projectProperties
echo "target=android-11" >> $projectProperties
echo "android.library=true" >> $projectProperties
cd ../../../../../..

# ##############################################################################
# Flash
# ##############################################################################

cp sa-flash-sdk/bin/SuperAwesome_Flash.swc sa-sdk-build-repo/flash_build/SuperAwesome_Flash-$flash_sdk_version.swc

# ##############################################################################
# Commit this repo to Git
# ##############################################################################

cd sa-sdk-build-repo
ls -all
git status
git add --all
commitMessage="update ios_sdk="$ios_sdk_version" android_sdk="$android_sdk_version" air_sdk="$air_sdk_version" flash_sdk="$flash_sdk_version
git commit -am "$commitMessage"
git push origin master

# ##############################################################################
# Update documentation
# ##############################################################################

cd ../
cd sa-adobeair-sdk-docs
git status
git add -all
git commit -am "update docs"
git push origin master
cd ../
cd sa-flash-sdk-docs
git status
git add -all
git commit -am "update docs"
git push origin master
cd ../
cd sa-mobile-sdk-ios-docs
git status
git add -all
git commit -am "update docs"
git push origin master
cd ../
cd sa-mobile-sdk-android-docs
git status
git add -all
git commit -am "update docs"
git push origin master
cd ../
cd sa-unity-sdk-docs
git status
git add -all
git commit -am "update docs"
git push origin master

cd ../
cd sa-dev-site
./add_external_documentation.sh
git status
git commit -am "update docs"
git push origin master
git push heroku-production master
cd ../
