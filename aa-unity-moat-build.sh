#!/bin/bash -ex

# build folder for all the jars
build="aa-unity-moat-build"
# project
project="SuperAwesomeSDK"

# rebuild the build folder
rm -rf $build && mkdir $build

################################################################################
# Copy folder
################################################################################

# set source and repo
source=sa-unity-sdk
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

cp -r $source/* $build/ && rm -rf $source

cd $build

rm -rf demo/Assets/Plugins/
mkdir demo/Assets/Plugins/
mkdir demo/Assets/Plugins/iOS
mkdir demo/Assets/Plugins/Android
mkdir demo/Assets/Plugins/Android/res
mkdir demo/Assets/Plugins/Android/res/drawable
mkdir demo/Assets/Plugins/Android/res/layout
mkdir demo/Assets/Plugins/Android/SuperAwesome_lib
mkdir lib$project/
mkdir lib$project/include
mkdir lib$project/include/$project/
mkdir static
mkdir static/src

cd ../

################################################################################
# Android Build
################################################################################

sources=(
		"sa-mobile-sdk-android"
    "sa-mobile-lib-android-adloader"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-session"
    "sa-mobile-lib-android-utils"
    "sa-mobile-lib-android-videoplayer"
		"sa-mobile-lib-android-vastparser"
    "sa-mobile-lib-android-webplayer"
)

destinations=(
		"superawesome-base"
		"saadloader"
		"saevents"
		"samoatevents"
		"sajsonparser"
    "samodelspace"
    "sanetwork"
		"sasession"
		"sautils"
		"savideoplayer"
		"savastparser"
    "sawebplayer"
)

for i in {0..11}
do
	# form vars for each library
	source=${sources[$i]}
	destination=${destinations[$i]}
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

	# case when it's the main superawesome SDK
	if [ $destination = "superawesome-base" ]; then

		# copy main SDK & AIR lib
		cp superawesome-base/build/outputs/aar/superawesome-base-release.aar ../$build/demo/Assets/Plugins/Android/superawesome-base.zip
		cp -r superawesome-base/src/main/res/layout/* ../$build/demo/Assets/Plugins/Android/res/layout/
		cp -r superawesome-base/src/main/res/drawable/* ../$build/demo/Assets/Plugins/Android/res/drawable/
		cp saunity/build/outputs/aar/saunity-release.aar ../$build/demo/Assets/Plugins/Android/saunity.zip

		# goto build/android folder
		cd ../$build/demo/Assets/Plugins/Android

		# unzip the superawesome sdk
		unzip superawesome-base.zip -d superawesome-base && rm superawesome-base.zip
		cp superawesome-base/classes.jar superawesome-base.jar && rm -rf superawesome-base

		# unzip the saair thing
		unzip saunity.zip -d saunity && rm saunity.zip
		cp saunity/classes.jar saunity.jar && rm -rf saunity

	# case when it's one of the libraries
	else

		# copy outputs into the build folder
		cp $destination/build/outputs/aar/$destination-release.aar ../$build/demo/Assets/Plugins/Android/$destination.zip

		# try finding the moatlib and copying  it
		if [ -f $destination/libs/moatlib.jar ]
		then
			cp $destination/libs/moatlib.jar ../$build/demo/Assets/Plugins/Android/moatlib.jar
		fi

		# go to where the zip is
		cd ../$build/demo/Assets/Plugins/Android

		# unzip the library thing
		unzip $destination.zip -d $destination && rm $destination.zip
		cp $destination/classes.jar $destination.jar && rm -rf $destination

	fi

	# exit to main folder
	cd ../../../../..

	# delete the source
	rm -rf $source
done

androidManifest=$build/demo/Assets/Plugins/Android/SuperAwesome_lib/"AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAVideoAd\" android:label=\"SAFullscreenVideoAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAInterstitialAd\" android:label=\"SAInterstitialAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.views.SAGameWall\" android:label=\"SAGameWall\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sanetwork.asynctask.SAAsyncTask\$SAAsync\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\"/>" >> $androidManifest
echo "<receiver android:name=\"tv.superawesome.sdk.cpi.SACPI\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\">" >> $androidManifest
echo "<intent-filter><action android:name=\"com.android.vending.INSTALL_REFERRER\"/></intent-filter>" >> $androidManifest
echo "</receiver>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

projectProperties=$build/demo/Assets/Plugins/Android/SuperAwesome_lib/"project.properties"
echo "# Project target." > $projectProperties
echo "target=android-11" >> $projectProperties
echo "android.library=true" >> $projectProperties

################################################################################
# iOS Build
################################################################################

sources=(
    "sa-mobile-lib-ios-adloader"
    "sa-mobile-lib-ios-events"
    "sa-mobile-lib-ios-jsonparser"
    "sa-mobile-lib-ios-modelspace"
    "sa-mobile-lib-ios-network"
    "sa-mobile-lib-ios-session"
    "sa-mobile-lib-ios-utils"
    "sa-mobile-lib-ios-videoplayer"
    "sa-mobile-lib-ios-webplayer"
		"sa-mobile-lib-ios-vastparser"
		"sa-mobile-sdk-ios"
)

for i in {0..10}
do
	# get source & repository
	source=${sources[$i]}
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

	# copy the Moat plugin files & libraries
	if [ -d $source/Pod/Plugin/Moat ]
	then
		cp -r $source/Pod/Plugin/Moat/* $build/demo/Assets/Plugins/iOS/
		cp -r $source/Pod/Libraries/* $build/demo/Assets/Plugins/iOS/
	fi

	# copy header files from the Pod Classes folder
	find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/lib$project/include/$project \;

	# remove the source
	rm -rf $source/
done

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
echo "set_property(TARGET $project PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET \"8.0\")" >> $cmakelists2

cd ../

# create a main header file in the lib folder's include/SuperAwesomeSDK folder
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
cp -r lib$project/include/SuperAwesomeSDK/* demo/Assets/Plugins/iOS/

# remove the iOS intermediate files
rm -rf lib$project
rm -rf static

cd ../

################################################################################
# Final Unity build
################################################################################

/Applications/Unity4/Unity.app/Contents/MacOS/Unity \
	-batchmode \
	-projectPath "$(pwd)/$build/demo" \
	-exportPackage \
		"Assets/Plugins" \
		"Assets/SuperAwesome" \
		"$(pwd)/$build/$project.Unity.full.unitypackage" \
	-quit

# remove all other things
cd  $build

rm -rf demo
rm *.apk
rm *.md
rm LICENSE
