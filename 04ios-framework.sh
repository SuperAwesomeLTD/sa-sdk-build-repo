#!/bin/bash -ex

# ios builds
framework_project="SuperAwesomeSDK"
predef="$build_repo/predef"
ios_build_framework="$ios_build/framework"
ios_build_framework_src=$ios_build_framework/$framework_project/$framework_project

mkdir $ios_build_framework

cp -r $predef/$framework_project $ios_build_framework/

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
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $ios_build_framework_src \;
		find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $ios_build_framework_src \;
done

# end
cd

# create the main header

cd $ios_build_framework_src
sourcefile="$framework_project.h"
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $ios_build_framework_src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done
cd

# ##############################################################################
# 2) Build & Lipo
# ##############################################################################

cd $ios_build_framework/$framework_project
/usr/bin/xcodebuild -target $framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
cd

# do a lipo for universal binaries
cd
cp -r $ios_build_framework/$framework_project/Build/Release-iphoneos/$framework_project.framework $ios_build/
lipo -create -output "$ios_build/$framework_project.framework/$framework_project" "$ios_build_framework/$framework_project/Build/Release-iphoneos/$framework_project.framework/$framework_project" "$ios_build_framework/$framework_project/Build/Release-iphonesimulator/$framework_project.framework/$framework_project"

cd
cd $ios_build
zip -r "$framework_project.framework.zip" $framework_project.framework
rm -rf $framework_project.framework
rm -rf framework

# exit
cd
