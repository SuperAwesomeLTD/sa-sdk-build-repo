#!/bin/bash -ex

# build folder for all the jars
build="aa-ios-build-framework-moat"
# project
project="SuperAwesomeSDK"

# # create build folder & subfolders
# rm -rf $build && mkdir $build
# mkdir $build/framework
# mkdir $build/framework/src
#
# ################################################################################
# # Download and copy all the intermediate ios source & header files
# ################################################################################
#
# sources=(
#     "sa-mobile-lib-ios-adloader"
#     "sa-mobile-lib-ios-events"
#     "sa-mobile-lib-ios-jsonparser"
#     "sa-mobile-lib-ios-modelspace"
#     "sa-mobile-lib-ios-network"
#     "sa-mobile-lib-ios-session"
#     "sa-mobile-lib-ios-utils"
#     "sa-mobile-lib-ios-videoplayer"
#     "sa-mobile-lib-ios-webplayer"
# 		"sa-mobile-lib-ios-vastparser"
# 		"sa-mobile-lib-ios-parentalgate"
# 		"sa-mobile-lib-ios-bumper"
# 		"sa-mobile-sdk-ios"
# )
#
# for i in {0..12}
# do
# 	source=${sources[$i]}
# 	repository=git@github.com:SuperAwesomeLTD/$source.git
#
# 	# clone the git repo
# 	rm -rf $source && git clone -b master $repository
#
# 	# copy header files from the Pod Classes folder
# 	find "$source/Pod/Classes/" -iname '*.h' -exec cp \{\} $build/framework/src \;
# 	# copy source files from the Pod Classes folder
#   find "$source/Pod/Classes/" -iname '*.m' -exec cp \{\} $build/framework/src \;
#
# 	# if [ -d "$source/Pod/Plugin/Moat" ]; then
# 	# 	find "$source/Pod/Plugin/Moat" -iname '*.h' -exec cp \{\} $build/framework/src \;
# 	# 	find "$source/Pod/Plugin/Moat" -iname '*.m' -exec cp \{\} $build/framework/src \;
# 	# fi
#
# 	if [ -d "$source/Pod/Libraries" ]; then
# 	  cp -r "$source/Pod/Libraries/MoatFramework.framework" $build
# 	fi
#
# 	# remove the source
# 	rm -rf $source/
# done
#
#
# ################################################################################
# # Create additional files (CMake, headers, etc)
# ################################################################################
#
# cd $build
#
# # create and copy the main SDK header
# sourcefile=framework/src/"$project.h"
# echo "#import <UIKit/UIKit.h>" > $sourcefile
# files=($(cd framework/src/ && ls *.h))
# for item in ${files[*]}
# 	do echo "#import \"$item\"" >> $sourcefile
# done
#
# # create the first CMakeLists.txt file
# cmakelists=framework/"CMakeLists.txt"
# echo "cmake_minimum_required(VERSION 2.8.6)" > $cmakelists
# echo "project($project)" >> $cmakelists
# echo "set(DEVROOT \"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer\")" >> $cmakelists
# echo "set(SDKROOT \"\${DEVROOT}/SDKs/iPhoneOS.sdk\")" >> $cmakelists
# echo "if(EXISTS \${SDKROOT})" >> $cmakelists
# echo "set(CMAKE_OSX_SYSROOT \"\${SDKROOT}\")" >> $cmakelists
# echo "else()" >> $cmakelists
# echo "message(\"Warning, iOS Base SDK path not found: \" ${SDKROOT})" >> $cmakelists
# echo "endif()" >> $cmakelists
# echo "set(CMAKE_OSX_ARCHITECTURES \"\$(ARCHS_STANDARD)\")" >> $cmakelists
# echo "set(CMAKE_OSX_DEPLOYMENT_TARGET \"iOS 8.0\")" >> $cmakelists
# echo "set(CMAKE_XCODE_EFFECTIVE_PLATFORMS \"-iphoneos;-iphonesimulator\")" >> $cmakelists
# echo "include_directories(\${CMAKE_CURRENT_SOURCE_DIR})" >> $cmakelists
# echo "add_subdirectory( src )" >> $cmakelists
#
# # create the second CMakeLists.txt file
# cmakelists2=framework/src/"CMakeLists.txt"
# echo "file( GLOB SRCS *.m *.h )" > $cmakelists2
# echo "add_library( $project SHARED \${SRCS} )" >> $cmakelists2
# echo "target_compile_options($project PUBLIC \"-fobjc-arc\")" >> $cmakelists2
# echo "target_compile_options($project PUBLIC \"-fmodules\")" >> $cmakelists2
# echo "target_compile_options($project PUBLIC \"-fembed-bitcode\")" >> $cmakelists2
# echo "set_property(TARGET $project PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET \"8.0\")" >> $cmakelists2
# echo "set_target_properties( $project PROPERTIES" >> $cmakelists2
# echo "FRAMEWORK TRUE" >> $cmakelists2
# echo "FRAMEWORK_VERSION C" >> $cmakelists2
# echo "MACOSX_FRAMEWORK_IDENTIFIER tv.superawesome.$project" >> $cmakelists2
# echo "MACOSX_FRAMEWORK_INFO_PLIST Info.plist" >> $cmakelists2
# echo "MACOSX_RPATH TRUE" >> $cmakelists2
# echo "PUBLIC_HEADER $sourcefile" >> $cmakelists2
# echo "XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY \"\""
# echo ")" >> $cmakelists2
#
# # create plist file
# plist=framework/"Info.plist"
# echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $plist
# echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $plist
# echo "<plist version=\"1.0\">" >> $plist
# echo "<dict>" >> $plist
# echo "<key>CFBundleDevelopmentRegion</key>" >> $plist
# echo "<string>en</string>" >> $plist
# echo "<key>CFBundleExecutable</key>" >> $plist
# echo "<string>\$(EXECUTABLE_NAME)</string>" >> $plist
# echo "<key>CFBundleIdentifier</key>" >> $plist
# echo "<string>tv.superawesome.$project</string>" >> $plist
# echo "<key>CFBundleInfoDictionaryVersion</key>" >> $plist
# echo "<string>6.0</string>" >> $plist
# echo "<key>CFBundleName</key>" >> $plist
# echo "<string>\$(PRODUCT_NAME)</string>" >> $plist
# echo "<key>CFBundlePackageType</key>" >> $plist
# echo "<string>FMWK</string>" >> $plist
# echo "<key>CFBundleShortVersionString</key>" >> $plist
# echo "<string>1.0</string>" >> $plist
# echo "<key>CFBundleSignature</key>" >> $plist
# echo "<string>????</string>" >> $plist
# echo "<key>CFBundleVersion</key>" >> $plist
# echo "<string>\$(CURRENT_PROJECT_VERSION)</string>" >> $plist
# echo "<key>NSPrincipalClass</key>" >> $plist
# echo "<string></string>" >> $plist
# echo "</dict>" >> $plist
# echo "</plist>" >> $plist
#
# cd ../
#
# # ##############################################################################
# # Use CMake to create the project
# # ##############################################################################
#
# cd $build/framework
#
# # create the XCode static lib project
# /Applications/CMake.app/Contents/bin/cmake -G Xcode .
# # build for simulator
# /usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator
# # build for phone
# /usr/bin/xcodebuild -target $project ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos
#
# cd ../
#
# # create the new framework folder
# mkdir $project.framework
# mkdir $project.framework/Headers
# # copy the plist
# cp framework/src/Release-iphoneos/$project.framework/Info.plist $project.framework/Info.plist
#
# # do a lipo to unite the iphone & simulator libs
# lipo \
# 	-create \
# 	"framework/src/Release-iphoneos/$project.framework/$project" \
# 	"framework/src/Release-iphonesimulator/$project.framework/$project" \
# 	-output "$project.framework/$project"
#
# # copy headers
# find framework/src/ -iname '*.h' -exec cp \{\} $project.framework/Headers/ \;

# ##############################################################################
# Join libraries
# ##############################################################################

archs=(i386 x86_64 armv7 arm64)
libraries=($project.framework/$project MoatFramework.framework/MoatFramework)

cd $build

for library in ${libraries[*]}
do
	lipo -info $library
	# Extract individual architectures for this library
	for arch in ${archs[*]}
    do
      lipo -extract $arch $library -o ${library}_${arch}
    done
done

# Combine results of the same architecture into a library for that architecture
source_combined=""
for arch in ${archs[*]}
do
    source_libraries=""

    for library in ${libraries[*]}
    do
      source_libraries="${source_libraries} ${library}_${arch}"
    done

    libtool -static ${source_libraries} -o "${1}${arch}"
    source_combined="${source_combined} ${1}_${arch}"

    # Delete intermediate files
    rm ${source_libraries}
done

# Merge the combined library for each architecture into a single fat binary
lipo -create $source_combined -o $project.full

# # Delete intermediate files
# rm lib$project.a
# rm libSUPMoatMobileAppKit.a
# rm ${source_combined}
#
# cd ../..

##############################################################################
# Finish & cleanup
##############################################################################

# cd $build
#
# zip
# zip -r $project.iOS.full.framework.zip $project.framework
#
# # delete
# rm -rf framework
# rm -rf $project.framework
#
# # exit
# cd
