#!/bin/bash -ex

# build folder for all the jars
build="kws-ios-build-static"
# project
project="KidsWebServicesSDK"

# create build folder
rm -rf $build && mkdir $build

# create static project structure
mkdir $build/lib$project/
mkdir $build/lib$project/include
mkdir $build/lib$project/include/$project/

# add sources
mkdir $build/static
mkdir $build/static/src

################################################################################
# Download and copy all the intermediate ios source & header files
################################################################################

sources=(
    "sa-mobile-lib-ios-jsonparser"
    "sa-mobile-lib-ios-network"
    "sa-mobile-lib-ios-utils"
    "sa-kws-ios-sdk-objc"
)

for i in {0..3}
do
	# get source & repository
	source=${sources[$i]}
	repository=git@github.com:SuperAwesomeLTD/$source.git

	# clone the git repo
	rm -rf $source && git clone -b master $repository

	# case when it's the main superawesome SDK
	if [ $source = "sa-kws-ios-sdk-objc" ]; then
		# copy header files from the Pod Classes folder
		find "$source/KWSiOSSDKObjC/Classes/" -iname '*.h' -exec cp \{\} $build/static/src \;
		# copy source files from the Pod Classes folder
	  find "$source/KWSiOSSDKObjC/Classes/" -iname '*.m' -exec cp \{\} $build/static/src \;

		# copy header files from the Pod Classes folder
		find "$source/KWSiOSSDKObjC/Classes/" -iname '*.h' -exec cp \{\} $build/lib$project/include/$project \;
	else
		# copy header files from the Pod Classes folder
		find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/static/src \;
		# copy source files from the Pod Classes folder
	  find "$source/Pod/Classes/" -iname '*.m' -exec cp \{\} $build/static/src \;

		# copy header files from the Pod Classes folder
		find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/lib$project/include/$project \;
	fi

	# remove the source
	rm -rf $source/
done

################################################################################
# Create the CMakeLists files
################################################################################

cd $build

# create the first CMakeLists.txt file
cmakelists=static/"CMakeLists.txt"
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

# create the second Cmake file, in the "src" folder
cmakelists2=static/src/"CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $project STATIC \${SRCS} )" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fembed-bitcode\")" >> $cmakelists2
echo "set_property(TARGET $project PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET \"8.0\")" >> $cmakelists2

# create a main header file in the lib folder's include/SuperAwesomeSDK folder
sourcefile=lib$project/include/$project/$project.h

echo "#import <UIKit/UIKit.h>" >> $sourcefile
files=($(cd static/src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

cd ../

################################################################################
# Create the library
################################################################################

cd $build/static

# create the XCode static lib project
/Applications/CMake.app/Contents/bin/cmake -G Xcode .
# build for simulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
# build for phone
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
# do a lipo for universal binaries
lipo \
	-create \
	"src/Release-iphoneos/lib$project.a" \
	"src/Release-iphonesimulator/lib$project.a" \
	-output "../lib$project/lib$project.a"

cd ../..

# ##############################################################################
# Finish & cleanup
# ##############################################################################

# goto build folder
cd $build

# zip the library
zip -r $project.iOS.lib.zip lib$project

# remove
rm -rf static
rm -rf lib$project

cd ../
