#!/bin/bash -ex

# ios builds
kws_framework_project="KidsWebServicesSDK"
predef="$build_repo/predef"
kws_ios_build_framework="$kws_ios_build/framework"
kws_ios_build_framework_src=$kws_ios_build_framework/$kws_framework_project/$kws_framework_project

mkdir $kws_ios_build_framework

cp -r $predef/$kws_framework_project $kws_ios_build_framework/

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
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $kws_ios_build_framework_src \;
		find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $kws_ios_build_framework_src \;
done

# end
cd

# create the main header

cd $kws_ios_build_framework_src
sourcefile="$kws_framework_project.h"
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $kws_ios_build_framework_src/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done
cd

# ##############################################################################
# 2) Build & Lipo
# ##############################################################################

cd $kws_ios_build_framework/$kws_framework_project
/usr/bin/xcodebuild -target $kws_framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
/usr/bin/xcodebuild -target $kws_framework_project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
cd

# do a lipo for universal binaries
cd
cp -r $kws_ios_build_framework/$kws_framework_project/Build/Release-iphoneos/$kws_framework_project.framework $kws_ios_build/
lipo -create -output "$kws_ios_build/$kws_framework_project.framework/$kws_framework_project" "$kws_ios_build_framework/$kws_framework_project/Build/Release-iphoneos/$kws_framework_project.framework/$kws_framework_project" "$kws_ios_build_framework/$kws_framework_project/Build/Release-iphonesimulator/$kws_framework_project.framework/$kws_framework_project"
mkdir $kws_ios_build/$kws_framework_project.framework/Headers
find "$kws_ios_build_framework_src/" -iname "*.h" -exec cp \{\} $kws_ios_build/$kws_framework_project.framework/Headers \;

cd
cd $kws_ios_build
zip -r "$kws_framework_project.framework.zip" $kws_framework_project.framework
rm -rf $kws_framework_project.framework
rm -rf framework

# exit
cd
