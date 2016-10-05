#!/bin/bash -ex

# ios builds
framework_project="SuperAwesomeSDK"
ios_build_framework="$ios_build/framework"
ios_build_framework_src="$ios_build_framework/src"
mkdir $ios_build_framework
mkdir $ios_build_framework_src

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

for i in {0..9}
do
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $ios_build_framework_src/ \;
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $ios_build_framework_src/ \;
done

cd $ios_build_framework

# copy and create header

sourcefile="$framework_project.h"
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $ios_build_framework_src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done
mv $sourcefile src/

# ##############################################################################
# 2) Prepare the CMake project
# ##############################################################################

# create the first CMakeLists.txt file
cmakelists="CMakeLists.txt"
echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
echo "project($framework_project)" >> $cmakelists
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
echo "add_library( $framework_project SHARED \${SRCS} )" >> $cmakelists2
echo "target_compile_options($framework_project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($framework_project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "set_target_properties( $framework_project PROPERTIES" >> $cmakelists2
echo "FRAMEWORK TRUE" >> $cmakelists2
echo "FRAMEWORK_VERSION C" >> $cmakelists2
echo "MACOSX_FRAMEWORK_IDENTIFIER tv.superawesome.$framework_project" >> $cmakelists2
echo "MACOSX_FRAMEWORK_INFO_PLIST Info.plist" >> $cmakelists2
echo "PUBLIC_HEADER $sourcefile" >> $cmakelists2
echo "XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY \"iPhone Developer (Joshua Wohle)\""
echo ")" >> $cmakelists2
cd ..

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
echo "<string>\$(PRODUCT_BUNDLE_IDENTIFIER)</string>" >> $plist
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

# ##############################################################################
# 3) Use CMake to create the project
# ##############################################################################

cd
cd $ios_build_framework
/Applications/CMake.app/Contents/bin/cmake -G Xcode .

# ##############################################################################
# 4) Build & Lipo
# ##############################################################################

/usr/bin/xcodebuild -target $framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos CODE_SIGN_IDENTITY="iPhone Developer"

# do a lipo for universal binaries
cd
cp -r $ios_build_framework_src/Release-iphoneos/$framework_project.framework $ios_build/
lipo -create -output "$ios_build/$framework_project.framework/$framework_project" "$ios_build_framework_src/Release-iphoneos/$framework_project.framework/$framework_project" "$ios_build_framework_src/Release-iphonesimulator/$framework_project.framework/$framework_project"

# final copy
find $ios_build_framework_src -iname '*.h' -exec cp \{\} $ios_build/$framework_project.framework/Headers/ \;

cd $ios_build
zip -r "$framework_project.framework.zip" $framework_project.framework
rm -rf $framework_project.framework
rm -rf framework

# exit
cd
