#!/bin/bash -ex

# ios builds
static_project="KidsWebServicesSDK"
kws_ios_build_static="$kws_ios_build/static"
kws_ios_build_static_src="$kws_ios_build_static/src"
mkdir $kws_ios_build_static
mkdir $kws_ios_build_static_src

kws_ios_build_static_result="$kws_ios_build/lib$static_project"
kws_ios_build_static_result1="$kws_ios_build_static_result/include"
kws_ios_build_static_result2="$kws_ios_build_static_result1/$static_project"
mkdir $kws_ios_build_static_result
mkdir $kws_ios_build_static_result1
mkdir $kws_ios_build_static_result2

# ##############################################################################
# 1) Start copying files for the build
# ##############################################################################

# start
cd

source_folders=(
    "$workspace/sa-mobile-lib-ios-network"
    "$workspace/sa-mobile-lib-ios-utils"
    "$workspace/sa-mobile-lib-ios-jsonparser"
    "$workspace/sa-kws-ios-sdk-objc"
)

for i in {0..3}
do
    # headers & source for compiling & building
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $kws_ios_build_static_src/ \;
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $kws_ios_build_static_src/ \;

    # headers for final build packaging
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $kws_ios_build_static_result2/ \;
done

# ##############################################################################
# 2) Prepare the CMake project
# ##############################################################################

cd $kws_ios_build_static

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
cd ..

# create the main library header
sourcefile=$kws_ios_build_static_result2/$static_project.h
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $kws_ios_build_static_src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# ##############################################################################
# 3) Use CMake to create the project
# ##############################################################################

cd $kws_ios_build_static
/Applications/CMake.app/Contents/bin/cmake -G Xcode .

# ##############################################################################
# 4) Build & Lipo
# ##############################################################################

/usr/bin/xcodebuild -target $static_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $static_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos

# do a lipo for universal binaries
cd
lipo -create "$kws_ios_build_static_src/Release-iphoneos/lib$static_project.a" "$kws_ios_build_static_src/Release-iphonesimulator/lib$static_project.a" -output "$kws_ios_build/lib$static_project/lib$static_project.a"

# zip it
cd $kws_ios_build
zip -r "$static_project.lib.zip" "lib$static_project"

# clear
rm -rf static
rm -rf lib$static_project

# exit
cd
