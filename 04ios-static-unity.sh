#!/bin/bash -ex

static_project="SuperAwesomeSDKUnity"
ios_build_static="$ios_build/static"
ios_build_static_src="$ios_build_static/src"
mkdir $ios_build_static
mkdir $ios_build_static_src

ios_build_static_result="$ios_build/lib$static_project"
ios_build_static_result1="$ios_build_static_result/include"
ios_build_static_result2="$ios_build_static_result1/$static_project"
mkdir $ios_build_static_result
mkdir $ios_build_static_result1
mkdir $ios_build_static_result2

# ##############################################################################
# 1) Start copying files for the build
# ##############################################################################

# start
cd

source_folders=(
    "$workspace/sa-mobile-lib-ios-modelspace"
    "$workspace/sa-mobile-lib-ios-network"
    "$workspace/sa-mobile-lib-ios-utils"
    "$workspace/sa-mobile-lib-ios-events"
    "$workspace/sa-mobile-lib-ios-jsonparser"
    "$workspace/sa-mobile-lib-ios-videoplayer"
    "$workspace/sa-mobile-lib-ios-webplayer"
    "$workspace/sa-mobile-lib-ios-adloader"
    "$workspace/sa-mobile-lib-ios-session"
    "$workspace/sa-mobile-sdk-ios"
)

plugin_folders=(
    "$workspace/sa-mobile-sdk-ios/Pod/Plugin/Unity"
)

for i in {0..9}
do
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $ios_build_static_src/ \;
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $ios_build_static_src/ \;

    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $ios_build_static_result2/ \;
done
for i in {0..0}
do
    find "${plugin_folders[$i]}" -iname '*.h' -exec cp \{\} $ios_build_static_src/ \;
    find "${plugin_folders[$i]}" -iname '*.m' -exec cp \{\} $ios_build_static_src/ \;
    find "${plugin_folders[$i]}" -iname '*.mm' -exec cp \{\} $ios_build_static_src/ \;

    find "${plugin_folders[$i]}" -iname '*.h' -exec cp \{\} $ios_build_static_result2/ \;
    find "${plugin_folders[$i]}" -iname '*.mm' -exec cp \{\} $ios_build_static_result2/ \;
done

cp -r $workspace/sa-mobile-lib-ios-events/Pod/Frameworks/SUPMoatMobileAppKit.framework $ios_build_static_src/

# ##############################################################################
# 2) Prepare the CMake project
# ##############################################################################

cd $ios_build_static

# create the first CMakeLists.txt file
cmakelists="CMakeLists.txt"
echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
echo "project($static_project)" >> $cmakelists
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

# create the second CMakeLists.txt file
cd src
cmakelists2="CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $static_project STATIC \${SRCS} )" >> $cmakelists2
echo "target_compile_options($static_project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($static_project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "target_compile_options($static_project PUBLIC \"-fembed-bitcode\")" >> $cmakelists2
cd

# create the main library header
sourcefile=$ios_build_static_result2/$static_project.h
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $ios_build_static_src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# ##############################################################################
# 3) Use CMake to create the project
# ##############################################################################

cd $ios_build_static
/Applications/CMake.app/Contents/bin/cmake -G Xcode .

# ##############################################################################
# 4) Build & Lipo
# ##############################################################################

/usr/bin/xcodebuild -target $static_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $static_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos

# # do a lipo for universal binaries
cd
lipo -create "$ios_build_static_src/Release-iphoneos/lib$static_project.a" "$ios_build_static_src/Release-iphonesimulator/lib$static_project.a" -output "$ios_build/lib$static_project/lib$static_project.a"

cd $ios_build
rm -rf static

# exit
cd
