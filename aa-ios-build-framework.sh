#!/bin/bash -ex

# build folder for all the jars
build="aa-ios-build-framework"
# project
project="SuperAwesomeSDK"

# create build folder & subfolders
rm -rf $build && mkdir $build
mkdir $build/framework
mkdir $build/framework/src

################################################################################
# Download and copy all the intermediate ios source & header files
################################################################################

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
		"sa-mobile-lib-ios-vastparser"
		"sa-mobile-sdk-ios"
)

for i in {0..10}
do
	source=${sources[$i]}
	repository=git@github.com:SuperAwesomeLTD/$source.git

	# clone the git repo
	rm -rf $source && git clone -b master $repository

	# copy header files from the Pod Classes folder
	find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/framework/src \;
	# copy source files from the Pod Classes folder
  find "$source/Pod/Classes/" -iname '*.m' -exec cp \{\} $build/framework/src \;

	# remove the source
	rm -rf $source/
done


################################################################################
# Create additional files (CMake, headers, etc)
################################################################################

cd $build

# create and copy the main SDK header
sourcefile=framework/src/"$project.h"
echo "#import <UIKit/UIKit.h>" > $sourcefile
files=($(cd framework/src/ && ls *.h))
for item in ${files[*]}
	do echo "#import \"$item\"" >> $sourcefile
done

# create the first CMakeLists.txt file
cmakelists=framework/"CMakeLists.txt"
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
echo "set(CMAKE_OSX_DEPLOYMENT_TARGET \"iOS 8.0\")" >> $cmakelists
echo "set(CMAKE_XCODE_EFFECTIVE_PLATFORMS \"-iphoneos;-iphonesimulator\")" >> $cmakelists
echo "include_directories(\${CMAKE_CURRENT_SOURCE_DIR})" >> $cmakelists
echo "add_subdirectory( src )" >> $cmakelists

# create the second CMakeLists.txt file
cmakelists2=framework/src/"CMakeLists.txt"
echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
echo "add_library( $project SHARED \${SRCS} )" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2
echo "set_property(TARGET $project PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET \"8.0\")" >> $cmakelists2
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
plist=framework/"Info.plist"
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

cd ../

# ##############################################################################
# Use CMake to create the project
# ##############################################################################

cd $build/framework

# create the XCode static lib project
/Applications/CMake.app/Contents/bin/cmake -G Xcode .
# build for simulator
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
# build for phone
/usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos

cd ../

# create the new framework folder
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

# zip
zip -r $project.iOS.framework.zip $project.framework

# delete
rm -rf framework
rm -rf $project.framework

# exit
cd
