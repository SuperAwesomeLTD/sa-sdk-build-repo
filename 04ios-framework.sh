#!/bin/bash -ex

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
    "$workspace/sa-mobile-lib-ios-vastparser"
    "$workspace/sa-mobile-lib-ios-videoplayer"
    "$workspace/sa-mobile-lib-ios-webplayer"
    "$workspace/sa-mobile-lib-ios-adloader"
    "$workspace/sa-mobile-lib-ios-session"
    "$workspace/sa-mobile-sdk-ios"
)

framework_folder="$workspace/sa-mobile-sdk-ios-framework"
destination_1="$framework_folder/SuperAwesomeSDK/Classes"
rm -rf $destination_1
mkdir $destination_1

for i in {0..10}
do
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $destination_1/ \;
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $destination_1/ \;
done

# ##############################################################################
# 2) Write the header
# ##############################################################################

# enter
cd
cd "$framework_folder/SuperAwesomeSDK"

sourcefile=SuperAwesomeSDK.h
echo "#import <UIKit/UIKit.h>" > $sourcefile
echo "FOUNDATION_EXPORT double SuperAwesomeSDKVersionNumber;" >> $sourcefile
echo "FOUNDATION_EXPORT const unsigned char SuperAwesomeSDKVersionString[];" >> $sourcefile
files=($(cd $destination_1/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# exit
cd

# ##############################################################################
# 3) Build
# ##############################################################################

# start
cd
cd $framework_folder

# build defines
xbuildir="$framework_folder/build"
xconfig="Release"
xproj="SuperAwesomeSDK"

# perform operation

/usr/bin/xcodebuild -target "$xproj" -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
/usr/bin/xcodebuild -target "$xproj" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
cp -r "build/$xconfig-iphoneos/$xproj.framework" $ios_build/
lipo -create -output "$ios_build/$xproj.framework/$xproj" "$xbuildir/$xconfig-iphoneos/$xproj.framework/$xproj" "$xbuildir/$xconfig-iphonesimulator/$xproj.framework/$xproj"

find "$framework_folder/SuperAwesomeSDK/Classes/" -iname '*.h' -exec cp \{\} "$ios_build/$xproj.framework/Headers/" \;

cd
cd $ios_build
zip -r "$xproj-$sdk_version_ios.framework.zip" "$xproj.framework"
rm -rf "$xproj.framework"

# exit
cd
