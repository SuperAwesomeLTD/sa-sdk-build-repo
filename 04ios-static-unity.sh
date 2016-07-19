#!/bin/bash -ex

ios_build_static="$ios_build/static_unity"
mkdir $ios_build_static

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

plugin_folders=(
    "$workspace/sa-mobile-sdk-ios"
)

static_lib_folder="$workspace/sa-mobile-sdk-ios-staticlib-unity"
destination_1="$static_lib_folder/SuperAwesomeSDKUnity/Classes"

rm -rf $destination_1
mkdir $destination_1

for i in {0..10}
do
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.h' -exec cp \{\} $destination_1/ \;
    find "${source_folders[$i]}/Pod/Classes/" -iname '*.m' -exec cp \{\} $destination_1/ \;
done
for i in {0..0}
do
    find "${plugin_folders[$i]}/Pod/Plugin/Unity" -iname '*.h' -exec cp \{\} $destination_1/ \;
    find "${plugin_folders[$i]}/Pod/Plugin/Unity" -iname '*.m' -exec cp \{\} $destination_1/ \;
    find "${plugin_folders[$i]}/Pod/Plugin/Unity" -iname '*.mm' -exec cp \{\} $destination_1/ \;
done

# ##############################################################################
# 2) Write the header
# ##############################################################################

# enter
cd
cd "$static_lib_folder/SuperAwesomeSDKUnity"

sourcefile=SuperAwesomeSDKUnity.h
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd $destination_1/ && ls *.h))
for item in ${files[*]}
do echo "#import \"$item\"" >> $sourcefile
done

# ##############################################################################
# 3) Build
# ##############################################################################

# start
cd
cd $static_lib_folder

# build defines
xbuildir="$static_lib_folder/build"
xconfig="Release"
xproj="SuperAwesomeSDKUnity"
xtarget="SuperAwesomeSDKUnity"

# perform operation
/usr/bin/xcodebuild -target $xtarget ONLY_ACTIVE_ARCH=NO -configuration $xconfig -sdk iphoneos
/usr/bin/xcodebuild -target $xtarget ONLY_ACTIVE_ARCH=NO -configuration $xconfig -sdk iphonesimulator
lipo -create "$xbuildir/$xconfig-iphoneos/lib$xproj.a" "$xbuildir/$xconfig-iphonesimulator/lib$xproj.a" -output "$ios_build_static/lib$xproj.a"

# exit
cd

# ##############################################################################
# 4) Package
# ##############################################################################

# start
cd

mkdir $ios_build_static/include
mkdir $ios_build_static/include/SuperAwesome
find "$static_lib_folder/SuperAwesomeSDKUnity/Classes/" -iname '*.h' -exec cp \{\} $ios_build_static/include/SuperAwesome/ \;
cp $static_lib_folder/SuperAwesomeSDKUnity/$sourcefile $ios_build_static/include/SuperAwesome/
cp "$workspace/sa-mobile-sdk-ios/Pod/Plugin/Unity/SAUnity.mm" $ios_build_static

# cd $ios_build
# zip -r "lib$xproj-$sdk_version_ios.zip" "static_unity"
# rm -rf static_unity

# exit
cd
