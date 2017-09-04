#!/bin/bash -ex

# build folder for all the jars
build="ag-unity-build"
# project
project="SAAgeGateSDK"

# rebuild the build folder
rm -rf $build && mkdir $build

################################################################################
# Copy folder
################################################################################

# set source and repo
source=sa-unity-agegate-sdk
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

cp -r $source/* $build/ && rm -rf $source

cd $build

rm -rf demo/Assets/Plugins/
mkdir demo/Assets/Plugins/
mkdir demo/Assets/Plugins/iOS
mkdir demo/Assets/Plugins/Android
mkdir demo/Assets/Plugins/Android/SuperAwesomeAdvertiser_lib
mkdir lib$project/
mkdir lib$project/include
mkdir lib$project/include/$project/
mkdir static
mkdir static/src

cd ../

################################################################################
# Android Build
################################################################################

# form vars for each library
source="sa-mobile-sdk-agegate-android"
destination="saagegate"
repository=git@github.com:SuperAwesomeLTD/$source.git

# download repo
rm -rf $source && git clone -b master $repository

# go to the new android project folder
cd $source

# add local properties
localProperties="local.properties"
echo "sdk.dir=/Users/gabriel.coman/Library/Android/sdk" >> $localProperties

# clean and build the whole project
./gradlew build

# copy main SDK & AIR lib
cp $destination/build/outputs/aar/$destination-release.aar ../$build/demo/Assets/Plugins/Android/$destination.zip
cp sagunity/build/outputs/aar/sagunity-release.aar ../$build/demo/Assets/Plugins/Android/sagunity.zip

# goto build/android folder
cd ../$build/demo/Assets/Plugins/Android

# unzip the superawesome sdk
unzip $destination.zip -d $destination && rm $destination.zip
cp $destination/classes.jar $destination.jar && rm -rf $destination

# unzip the saair thing
unzip sagunity.zip -d sagunity && rm sagunity.zip
cp sagunity/classes.jar sagunity.jar && rm -rf sagunity

# exit to main folder
cd ../../../../..

# delete the source
rm -rf $source

androidManifest=$build/demo/Assets/Plugins/Android/SuperAwesomeAdvertiser_lib/"AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk.agegate\">" >> $androidManifest
echo "<uses-sdk android:minSdkVersion=\"9\" />" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.agegate.SAAgeGate\" android:label=\"SAAgeGate\" android:configChanges=\"keyboardHidden|orientation|screenSize\" android:theme=\"@android:style/Theme.Holo.Dialog.NoActionBar\" android:excludeFromRecents=\"true\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.agegate.SAAgeInput\" android:theme=\"@android:style/Theme.Translucent.NoTitleBar\"/>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

projectProperties=$build/demo/Assets/Plugins/Android/SuperAwesomeAdvertiser_lib/"project.properties"
echo "# Project target." > $projectProperties
echo "target=android-11" >> $projectProperties
echo "android.library=true" >> $projectProperties

################################################################################
# iOS Build
################################################################################

# get source & repository
source="sa-mobile-sdk-agegate-ios"
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

# copy header files from the Pod Classes folder
find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/static/src \;
# copy source files from the Pod Classes folder
find "$source/Pod/Classes/" -iname '*.m' -exec cp \{\} $build/static/src \;

# copy Unity plugin, only for the static part of the library
if [ -d $source/Pod/Plugin/Unity ]
then
	cp -r $source/Pod/Plugin/Unity/* $build/static/src/
	cp -r $source/Pod/Plugin/Unity/* $build/lib$project/include/$project/
fi

# copy header files from the Pod Classes folder
find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/lib$project/include/$project \;

# remove the source
rm -rf $source/

cd $build/static

# create the first CMakeLists.txt file
cmakelists="CMakeLists.txt"
echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
echo "project($project)" >> $cmakelists
echo "set(DEVROOT \"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer\")" >> $cmakelists
echo "set(SDKROOT \"\${DEVROOT}/SDKs/iPhoneOS.sdk\")" >> $cmakelists
echo "if(EXISTS \${SDKROOT})" >> $cmakelists
echo "set(CMAKE_OSX_SYSROOT \"\${SDKROOT}\")" >> $cmakelists
echo "else()" >> $cmakelists
echo "message(\"Warning, iOS Base SDK path not found: \" ${SDKROOT})" >> $cmakelists
echo "endif()" >> $cmakelists
echo "set(CMAKE_OSX_ARCHITECTURES \"\$(ARCHS_STANDARD)\")" >> $cmakelists
echo "set(CMAKE_XCODE_EFFECTIVE_PLATFORMS \"-iphoneos;-iphonesimulator\")" >> $cmakelists
echo "include_directories(\${CMAKE_CURRENT_SOURCE_DIR})" >> $cmakelists
echo "add_subdirectory( src )" >> $cmakelists

cmakelists2=src/"CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $project STATIC \${SRCS} )" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fembed-bitcode\")" >> $cmakelists2
echo "set_property(TARGET $project PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET \"8.0\")" >> $cmakelists2

cd ../

# create a main header file in the lib folder's include/SAAgeGateSDK folder
sourcefile=lib$project/include/$project/$project.h

echo "#import <UIKit/UIKit.h>" >> $sourcefile
files=($(cd static/src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

cd static

/Applications/CMake.app/Contents/bin/cmake -G Xcode .
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
# do a lipo for universal binaries
lipo \
	-create \
	"src/Release-iphoneos/lib$project.a" \
	"src/Release-iphonesimulator/lib$project.a" \
	-output "../lib$project/lib$project.a"

cd ../

# copy the library & headers
cp lib$project/lib$project.a demo/Assets/Plugins/iOS/lib$project.a
cp -r lib$project/include/SAAgeGateSDK/* demo/Assets/Plugins/iOS/

# remove the iOS intermediate files
rm -rf lib$project
rm -rf static

cd ../

################################################################################
# Final Unity build
################################################################################

/Applications/Unity/Unity.app/Contents/MacOS/Unity \
	-batchmode \
	-projectPath "$(pwd)/$build/demo" \
	-exportPackage \
		"Assets/Plugins" \
		"Assets/SuperAwesome" \
		"$(pwd)/$build/$project.Unity.base.unitypackage" \
	-quit

# remove all other things
cd  $build

rm -rf demo
rm *.md
rm LICENSE
