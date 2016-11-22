#!/bin/bash -ex

# start
cd

# create dest folders
mkdir "$air_build/android"
mkdir "$air_build/ios"
mkdir "$air_build/default"

# ##############################################################################
# 1) Copy the Android stuff
# ##############################################################################

air_sources=(
    "samodelspace.jar"
    "sajsonparser.jar"
    "saevents.jar"
    "sautils.jar"
    "sasession.jar"
    "savideoplayer.jar"
    "sawebplayer.jar"
    "saadloader.jar"
    "sanetwork.jar"
    "superawesome.jar"
    "saair.jar"
)

for i in {0..10}
do cp "$android_build/${air_sources[$i]}" "$air_build/android"
done

# Copy Android resources
cd

cd "$air_build/android"
mkdir res
mkdir res/drawable
mkdir res/layout
cd
cp -r "$android_build/superawesome-res/layout/" "$air_build/android/res/layout/"
cp -r "$android_build/superawesome-res/drawable/" "$air_build/android/res/drawable/"

# exit
cd

# ##############################################################################
# 2) Copy iOS stuff
# ##############################################################################

# copy the main AIR library

cd
cp $ios_build/SuperAwesomeSDKAIR.lib.zip $air_build/ios
cd $air_build/ios
unzip SuperAwesomeSDKAIR.lib.zip -d tmp
cp tmp/libSuperAwesomeSDKAIR/libSuperAwesomeSDKAIR.a ../ios/
rm -rf tmp
rm SuperAwesomeSDKAIR.lib.zip

# copy the framework

cd
cp $ios_build/SuperAwesomeSDK.framework.zip $air_build/
cd $air_build
# mkdir Frameworks
unzip SuperAwesomeSDK.framework.zip -d tmp
cp -r tmp/SuperAwesomeSDK.framework SuperAwesomeSDK.framework
rm -rf tmp
rm SuperAwesomeSDK.framework.zip

# ##############################################################################
# 3) Get the Flash library
# ##############################################################################

# start
cd

cp "$workspace/sa-adobeair-sdk/bin/SuperAwesome_AIR.swc" "$air_build/"
cd $air_build
cp SuperAwesome_AIR.swc SuperAwesome_AIR.zip
mkdir tmp
unzip SuperAwesome_AIR.zip -d tmp
cp tmp/library.swf android/
cp tmp/library.swf ios/
cp tmp/library.swf default/
rm -rf tmp
rm SuperAwesome_AIR.zip

# exit
cd

# ##############################################################################
# 4) Write the extension file
# ##############################################################################

# start
cd

cd $air_build

# write to file
extensionFile="extension.xml"
echo "<extension xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $extensionFile
echo "<id>tv.superawesome.plugins.air</id>" >> $extensionFile
echo "<versionNumber>1.0.0</versionNumber>" >> $extensionFile
# platforms
echo "<platforms>" >> $extensionFile
# android platform
echo "<platform name=\"Android-ARM\">" >> $extensionFile
echo "<applicationDeployment> " >> $extensionFile
echo "<nativeLibrary>saair.jar</nativeLibrary>" >> $extensionFile
echo "<initializer>tv.superawesome.plugins.air.SAAIRExtension</initializer>" >> $extensionFile
echo "</applicationDeployment>" >> $extensionFile
echo "</platform>" >> $extensionFile
# ios platform
echo "<platform name=\"iPhone-ARM\">" >> $extensionFile
echo "<applicationDeployment>" >> $extensionFile
echo "<nativeLibrary>libSuperAwesomeSDKAIR.a</nativeLibrary>" >> $extensionFile
echo "<initializer>SAExtensionInitializer</initializer>" >> $extensionFile
echo "</applicationDeployment>" >> $extensionFile
echo "</platform>" >> $extensionFile
# default platform
echo "<platform name=\"default\">" >> $extensionFile
echo "<applicationDeployment/>" >> $extensionFile
echo "</platform>" >> $extensionFile
# end platforms
echo "</platforms>" >> $extensionFile
echo "</extension>" >> $extensionFile

# exit
cd

# ##############################################################################
# 5) Write the android platform file
# ##############################################################################

# start
cd

cd $air_build

androidPlatformFile="android_platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $androidPlatformFile
echo "<packagedDependencies>" >> $androidPlatformFile
for i in {0..9}
do echo "<packagedDependency>${air_sources[$i]}</packagedDependency>" >> $androidPlatformFile
done
echo "</packagedDependencies>" >> $androidPlatformFile
echo "<packagedResources>" >> $androidPlatformFile
echo "<packagedResource>" >> $androidPlatformFile
echo "<packageName>tv.superawesome.sdk</packageName>" >> $androidPlatformFile
echo "<folderName>res</folderName>" >> $androidPlatformFile
echo "</packagedResource>" >> $androidPlatformFile
echo "</packagedResources>" >> $androidPlatformFile
echo "</platform>" >> $androidPlatformFile

# exit
cd

# ##############################################################################
# 6) Write the ios platform file
# ##############################################################################

# start
cd

cd $air_build

iosPlatformFile="ios_platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $iosPlatformFile
echo "<sdkVersion>8.0</sdkVersion>" >> $iosPlatformFile
echo "<linkerOptions>" >> $iosPlatformFile
echo "<option>-ios_version_min 8.0</option>" >> $iosPlatformFile
echo "<option>-framework SuperAwesomeSDK</option>"
# echo "<option>-rpath @executable_path</option>" >> $iosPlatformFile
echo "</linkerOptions>" >> $iosPlatformFile
# echo "<packagedDependencies>" >> $iosPlatformFile
# echo "<packagedDependency>SuperAwesomeSDK.framework</packagedDependency>" >> $iosPlatformFile
# echo "</packagedDependencies>" >> $iosPlatformFile
echo "</platform>" >> $iosPlatformFile

# exit
cd

# ##############################################################################
# 7) Make the build
# ##############################################################################

cd
cd $air_build

/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/21.0.0/bin/adt -package -target ane SuperAwesomeSDK.ane extension.xml -swc SuperAwesome_AIR.swc -platform Android-ARM -C android . -platformoptions android_platform.xml -platform iPhone-ARM -platformoptions ios_platform.xml -C ios . -platform default -C default .

# exit
cd
