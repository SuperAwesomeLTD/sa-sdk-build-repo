#!/bin/bash -ex

# build folder for all the jars
build="kws-android-parent-build"
# project
project="KidsWebServicesParentSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

sources=(
		"sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-utils"
    "sa-kws-parent-android-sdk"
)

destinations=(
		"sajsonparser"
    "sanetwork"
		"sautils"
		"kwsparentsdk"
)

for i in {0..3}
do
	# form vars for each library
	source=${sources[$i]}
	destination=${destinations[$i]}
	repository=git@github.com:SuperAwesomeLTD/$source.git

	# clone the git repo
	rm -rf $source && git clone -b master $repository

	# go to the new android project folder
	cd $source

	# add local properties
	localProperties="local.properties"
	echo "sdk.dir=/Users/gabriel.coman/Library/Android/sdk" >> $localProperties

	# clean and build the whole project
	./gradlew build

	# copy outputs into the build folder
	cp $destination/build/outputs/aar/$destination-release.aar ../$build/$destination.zip

	# case when it's the main Parent SDK, copy all addtional libs needed
	if [ $destination = "kwsparentsdk" ]
	then
		# copy external things
		cp -r $destination/libs/* ../$build/

		# get volley
		git clone https://android.googlesource.com/platform/frameworks/volley
		cd volley
		git checkout 008e0cc
		android update project -p .
		ant jar
		cp bin/volley.jar ../../$build/volley.jar
		cd ../
	fi

	# go to where the zip is
	cd ../$build

	# unzip the library thing
	unzip $destination.zip -d $destination && rm $destination.zip
	cp $destination/classes.jar $destination.jar && rm -rf $destination

	# exit to main folder
	cd ../

	# delete the source
	rm -rf $source
done

################################################################################
# Add a manifest file to the build
################################################################################

cd $build

androidManifest="AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"kws.superawesome.tv.kwsparentsdk\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<application android:allowBackup=\"true\">" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sanetwork.asynctask.SAAsyncTask\$SAAsync\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\"/>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

cd ../

################################################################################
# Final step - create different versions of this thing
################################################################################

# goto build
cd $build

zip -r $project.Android.jars.zip *

rm *.jar
rm AndroidManifest.xml

# exit
cd
