#!/bin/bash -ex

# build folder for all the jars
build="adv-unity-build"
# project
project="SuperAwesomeAdvertiserSDK"

# rebuild the build folder
rm -rf $build && mkdir $build

################################################################################
# Copy folder
################################################################################

# set source and repo
source=sa-unity-advertiser-sdk
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

sources=(
		"sa-mobile-sdk-advertiser-android"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-utils"
)

destinations=(
		"superawesomeadvertiser"
		"sajsonparser"
    "samodelspace"
    "sanetwork"
		"sautils"
)

for i in {0..4}
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
	if [ $destination = "superawesomeadvertiser" ]; then

		# copy main SDK & AIR lib
		cp superawesomeadvertiser/build/outputs/aar/superawesomeadvertiser-release.aar ../$build/demo/Assets/Plugins/Android/superawesomeadvertiser.zip
		cp sadvunity/build/outputs/aar/sadvunity-release.aar ../$build/demo/Assets/Plugins/Android/sadvunity.zip

		# goto build/android folder
		cd ../$build/demo/Assets/Plugins/Android

		# unzip the superawesome sdk
		unzip superawesomeadvertiser.zip -d superawesomeadvertiser && rm superawesomeadvertiser.zip
		cp superawesomeadvertiser/classes.jar superawesomeadvertiser.jar && rm -rf superawesomeadvertiser

		# unzip the saair thing
		unzip sadvunity.zip -d sadvunity && rm sadvunity.zip
		cp sadvunity/classes.jar sadvunity.jar && rm -rf sadvunity

	# case when it's one of the libraries
	else

		# copy outputs into the build folder
		cp $destination/build/outputs/aar/$destination-release.aar ../$build/demo/Assets/Plugins/Android/$destination.zip

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

androidManifest=$build/demo/Assets/Plugins/Android/SuperAwesomeAdvertiser_lib/"AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk.advertiser\">" >> $androidManifest
echo "<uses-sdk android:minSdkVersion=\"9\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sanetwork.asynctask.SAAsyncTask\$SAAsync\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\"/>" >> $androidManifest
echo "<receiver android:name=\"tv.superawesome.sdk.advertiser.SAVerifyInstall\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\">" >> $androidManifest
echo "<intent-filter><action android:name=\"com.android.vending.INSTALL_REFERRER\"/></intent-filter>" >> $androidManifest
echo "</receiver>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

projectProperties=$build/demo/Assets/Plugins/Android/SuperAwesomeAdvertiser_lib/"project.properties"
echo "# Project target." > $projectProperties
echo "target=android-11" >> $projectProperties
echo "android.library=true" >> $projectProperties

################################################################################
# iOS Build
################################################################################

sources="sa-mobile-sdk-advertiser-ios"

# get source & repository
source=${sources}
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

# create a main header file in the lib folder's include/SuperAwesomeAdvertiserSDK folder
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
cp -r lib$project/include/SuperAwesomeAdvertiserSDK/* demo/Assets/Plugins/iOS/

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
