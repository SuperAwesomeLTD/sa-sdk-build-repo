#!/bin/bash -ex

# build folder for all the jars
build="aa-air-build"
# project
project="SuperAwesomeSDK"

# clear the build folder & recreate it
rm -rf $build && mkdir $build

################################################################################
# Create the folder structure
################################################################################

cd $build

mkdir ios
mkdir android
mkdir android/res
mkdir android/res/drawable
mkdir android/res/layout
mkdir default

cd ../

################################################################################
# ADOBE AIR Build
################################################################################

# set source and repo
source=sa-adobeair-sdk
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone repo over clean folder
rm -rf $source && git clone -b master $repository

# get the project var
this=$(pwd)

# goto the Adobe AIR SDK and run acompc to build everything
cd /Applications/Adobe\ Flash\ Builder\ 4.7/sdks/21.0.0/bin
./acompc \
	-swf-version=13 \
	-source-path $this/$source/src \
	-debug=false \
	-output $this/$build/$project.AIR.swc \
	-include-sources=$this/$source/src

# cleanup
cd $this
rm -rf $source

cd $build

# copy the air library into all of the previous folders
cp $project.AIR.swc $project.AIR.zip
unzip $project.AIR.zip -d airlibrary
cp airlibrary/library.swf ios/library.swf
cp airlibrary/library.swf android/library.swf
cp airlibrary/library.swf default/library.swf
rm -rf airlibrary
rm $project.AIR.zip

cd ../

################################################################################
# ANDROID Build
################################################################################

sources=(
		"sa-mobile-sdk-android"
    "sa-mobile-lib-android-adloader"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-session"
    "sa-mobile-lib-android-utils"
    "sa-mobile-lib-android-videoplayer"
    "sa-mobile-lib-android-webplayer"
)

destinations=(
		"superawesome-base"
		"saadloader"
		"saevents"
		"sajsonparser"
    "samodelspace"
    "sanetwork"
		"sasession"
		"sautils"
		"savideoplayer"
    "sawebplayer"
)

for i in {0..9}
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
		cp superawesome-base/build/outputs/aar/superawesome-base-release.aar ../$build/android/superawesome-base.zip
		cp -r superawesome-base/src/main/res/layout/* ../$build/android/res/layout/
		cp -r superawesome-base/src/main/res/drawable/* ../$build/android/res/drawable/
		cp saair/build/outputs/aar/saair-release.aar ../$build/android/saair.zip

		# goto build/android folder
		cd ../$build/android

		# unzip the superawesome sdk
		unzip superawesome-base.zip -d superawesome-base && rm superawesome-base.zip
		cp superawesome-base/classes.jar superawesome-base.jar && rm -rf superawesome-base

		# unzip the saair thing
		unzip saair.zip -d saair && rm saair.zip
		cp saair/classes.jar saair.jar && rm -rf saair

	# case when it's one of the libraries
	else

		# copy outputs into the build folder
		cp $destination/build/outputs/aar/$destination-release.aar ../$build/android/$destination.zip

		# go to where the zip is
		cd ../$build/android

		# unzip the library thing
		unzip $destination.zip -d $destination && rm $destination.zip
		cp $destination/classes.jar $destination.jar && rm -rf $destination

	fi

	# exit to main folder
	cd ../../

	# delete the source
	rm -rf $source
done

cd $build

androidPlatformFile="android_platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $androidPlatformFile
echo "<packagedDependencies>" >> $androidPlatformFile
for i in {0..9}
do echo "<packagedDependency>${destinations[$i]}.jar</packagedDependency>" >> $androidPlatformFile
done
echo "</packagedDependencies>" >> $androidPlatformFile
echo "<packagedResources>" >> $androidPlatformFile
echo "<packagedResource>" >> $androidPlatformFile
echo "<packageName>tv.superawesome.sdk</packageName>" >> $androidPlatformFile
echo "<folderName>res</folderName>" >> $androidPlatformFile
echo "</packagedResource>" >> $androidPlatformFile
echo "</packagedResources>" >> $androidPlatformFile
echo "</platform>" >> $androidPlatformFile

cd ../

################################################################################
# iOS Build
################################################################################

cd $build

iosPlatformFile="ios_platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $iosPlatformFile
echo "<sdkVersion>8.0</sdkVersion>" >> $iosPlatformFile
echo "<linkerOptions>" >> $iosPlatformFile
echo "<option>-ios_version_min 8.0</option>" >> $iosPlatformFile
# echo "<option>-framework $project</option>" >> $iosPlatformFile
echo "</linkerOptions>" >> $iosPlatformFile
echo "</platform>" >> $iosPlatformFile

cd ../

# create static project structure
mkdir $build/lib$project/
mkdir $build/lib$project/include
mkdir $build/lib$project/include/$project/

mkdir $build/static
mkdir $build/static/src

mkdir $build/framework
mkdir $build/framework/src

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
		"sa-mobile-sdk-ios"
)

for i in {0..9}
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
	# copy header files from the Pod Classes folder
	find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/lib$project/include/$project \;
	# copy AIR plugin, only for the static part of the library
	if [ -d $source/Pod/Plugin/AIR ]
	then
		cp -r $source/Pod/Plugin/AIR/* $build/static/src
	fi

	# copy header files from the Pod Classes folder
	find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/framework/src \;
	# copy source files from the Pod Classes folder
  find "$source/Pod/Classes/" -iname '*.m' -exec cp \{\} $build/framework/src \;


	# remove the source
	rm -rf $source/
done

################################################################################
# static part of the library

cd $build/static

# create the first CMakeLists.txt file
cmakelists="CMakeLists.txt"
echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
echo "project($project)" >> $cmakelists
echo "set(SDKVER \"9.3\")" >> $cmakelists
echo "set(DEVROOT \"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer\")" >> $cmakelists
echo "set(SDKROOT \"\${DEVROOT}/SDKs/iPhoneSimulator\${SDKVER}.sdk\")" >> $cmakelists
echo "if(EXISTS \${SDKROOT})" >> $cmakelists
echo "set(CMAKE_OSX_SYSROOT \"\${SDKROOT}\")" >> $cmakelists
echo "else()" >> $cmakelists
echo "message(\"Warning, iOS Base SDK path not found: \" ${SDKROOT})" >> $cmakelists
echo "endif()" >> $cmakelists
echo "set(CMAKE_OSX_ARCHITECTURES \"\$(ARCHS_STANDARD)\")" >> $cmakelists
echo "set(CMAKE_XCODE_EFFECTIVE_PLATFORMS \"-iphoneos;-iphonesimulator\")" >> $cmakelists
echo "include_directories(\${CMAKE_CURRENT_SOURCE_DIR})" >> $cmakelists
echo "add_subdirectory( src )" >> $cmakelists

cd src
cmakelists2="CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $project STATIC \${SRCS} )" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2

# go back to build folder
cd ../..

# create a main header file in the lib folder's include/SuperAwesomeSDK folder
sourcefile=lib$project/include/$project/$project.h

echo "#import <UIKit/UIKit.h>" >> $sourcefile
files=($(cd static/src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# go-to the "Static" project
cd static

# cmake the static project and build it for release on iPhone & simulator
/Applications/CMake.app/Contents/bin/cmake -G Xcode .
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
# lipo (join) the two iPhone & simulator libraries
lipo \
	-create \
	"src/Release-iphoneos/lib$project.a" \
	"src/Release-iphonesimulator/lib$project.a" \
	-output "../lib$project/lib$project.a"

cd ../

# add the newly created library to the "ios" folder of the AIR build
cp lib$project/lib$project.a ios/lib$project.a && rm -rf static && rm -rf lib$project

################################################################################
# framework part of the library

cd framework

# create and copy the header

sourcefile=src/"$project.h"
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# create the first CMakeLists.txt file
cmakelists="CMakeLists.txt"
echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
echo "project($project)" >> $cmakelists
echo "set(SDKVER \"10.0\")" >> $cmakelists
echo "set(DEVROOT \"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer\")" >> $cmakelists
echo "set(SDKROOT \"\${DEVROOT}/SDKs/iPhoneOS\${SDKVER}.sdk\")" >> $cmakelists
echo "if(EXISTS \${SDKROOT})" >> $cmakelists
echo "set(CMAKE_OSX_SYSROOT \"\${SDKROOT}\")" >> $cmakelists
echo "else()" >> $cmakelists
echo "message(\"Warning, iOS Base SDK path not found: \" ${SDKROOT})" >> $cmakelists
echo "endif()" >> $cmakelists
echo "set(CMAKE_OSX_ARCHITECTURES \"\$(ARCHS_STANDARD)\")" >> $cmakelists
echo "set(CMAKE_XCODE_EFFECTIVE_PLATFORMS \"-iphoneos;-iphonesimulator\")" >> $cmakelists
echo "include_directories(\${CMAKE_CURRENT_SOURCE_DIR})" >> $cmakelists
echo "add_subdirectory( src )" >> $cmakelists

# create the second CMakeLists.txt file
cmakelists2=src/"CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $project SHARED \${SRCS} )" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "set_target_properties( $project PROPERTIES" >> $cmakelists2
echo "FRAMEWORK TRUE" >> $cmakelists2
echo "FRAMEWORK_VERSION C" >> $cmakelists2
echo "MACOSX_FRAMEWORK_IDENTIFIER tv.superawesome.$project" >> $cmakelists2
echo "MACOSX_FRAMEWORK_INFO_PLIST Info.plist" >> $cmakelists2
echo "MACOSX_RPATH TRUE" >> $cmakelists2
echo "PUBLIC_HEADER $sourcefile" >> $cmakelists2
echo "XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY \"\""
echo ")" >> $cmakelists2

# create plist file

plist="Info.plist"
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $plist
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $plist
echo "<plist version=\"1.0\">" >> $plist
echo "<dict>" >> $plist
echo "<key>CFBundleDevelopmentRegion</key>" >> $plist
echo "<string>en</string>" >> $plist
echo "<key>CFBundleExecutable</key>" >> $plist
echo "<string>\$(EXECUTABLE_NAME)</string>" >> $plist
echo "<key>CFBundleIdentifier</key>" >> $plist
echo "<string>tv.superawesome.$project</string>" >> $plist
echo "<key>CFBundleInfoDictionaryVersion</key>" >> $plist
echo "<string>6.0</string>" >> $plist
echo "<key>CFBundleName</key>" >> $plist
echo "<string>\$(PRODUCT_NAME)</string>" >> $plist
echo "<key>CFBundlePackageType</key>" >> $plist
echo "<string>FMWK</string>" >> $plist
echo "<key>CFBundleShortVersionString</key>" >> $plist
echo "<string>1.0</string>" >> $plist
echo "<key>CFBundleSignature</key>" >> $plist
echo "<string>????</string>" >> $plist
echo "<key>CFBundleVersion</key>" >> $plist
echo "<string>\$(CURRENT_PROJECT_VERSION)</string>" >> $plist
echo "<key>NSPrincipalClass</key>" >> $plist
echo "<string></string>" >> $plist
echo "</dict>" >> $plist
echo "</plist>" >> $plist

# Use CMake to create the project
/Applications/CMake.app/Contents/bin/cmake -G Xcode .
# Use XCode to build for iPhone and iPhoneSimulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos

# go back to the air_buil folder
cd ../

# create a new framework folder with a Headers subfolder
mkdir $project.framework
mkdir $project.framework/Headers
# copy the plist
cp framework/src/Release-iphoneos/$project.framework/Info.plist $project.framework/Info.plist

# do a lipo to unite the iphone & simulator libs
lipo \
	-create \
	"framework/src/Release-iphoneos/$project.framework/$project" \
	"framework/src/Release-iphonesimulator/$project.framework/$project" \
	-output "$project.framework/$project"

# copy headers
find framework/src/ -iname '*.h' -exec cp \{\} $project.framework/Headers/ \;

# delete
rm -rf framework

cd ../

################################################################################
# Final ANE Build
################################################################################

cd $build

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
echo "<nativeLibrary>lib$project.a</nativeLibrary>" >> $extensionFile
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

/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/21.0.0/bin/adt \
	-package \
	-target ane $project.AdobeAIR.ane extension.xml \
	-swc $project.AIR.swc \
	-platform Android-ARM \
	-C android . \
	-platformoptions android_platform.xml \
	-platform iPhone-ARM \
	-C ios . \
	-platformoptions ios_platform.xml \
	-platform default \
	-C default .

# remove intermediate files so just the .ane remains
rm -rf android
rm -rf ios
rm -rf default
rm -rf *.framework
rm *.xml
rm *.swc
