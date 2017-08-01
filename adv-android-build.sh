#!/bin/bash -ex

# build folder for all the jars
build="adv-android-build"
# project
project="SuperAwesomeAdvertiserSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

sources=(
		"sa-mobile-sdk-advertiser-android"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-utils"
)

destinations=(
		"superawesomeadvertiser"
		"sajsonparser"
    "samodelspace"
    "sanetwork"
		"sautils"
)

for i in {0..4}
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

	# case when it's the main superawesome SDK
	if [ $destination = "superawesomeadvertiser" ]
	then

		# copy main SDK & AIR lib
		cp superawesomeadvertiser/build/outputs/aar/superawesomeadvertiser-release.aar ../$build/superawesomeadvertiser.zip

		# goto build/android folder
		cd ../$build

		# unzip the superawesome sdk
		unzip superawesomeadvertiser.zip -d superawesomeadvertiser && rm superawesomeadvertiser.zip
		cp superawesomeadvertiser/classes.jar superawesomeadvertiser.jar && rm -rf superawesomeadvertiser

	# case when it's one of the libraries
	else

		# copy outputs into the build folder
		cp $destination/build/outputs/aar/$destination-release.aar ../$build/$destination.zip

		# go to where the zip is
		cd ../$build

		# unzip the library thing
		unzip $destination.zip -d $destination && rm $destination.zip
		cp $destination/classes.jar $destination.jar && rm -rf $destination

	fi

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
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk.advertiser\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<service android:name=\"tv.superawesome.lib.sanetwork.asynctask.SAAsyncTask\$SAAsync\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\"/>" >> $androidManifest
echo "<receiver android:name=\"tv.superawesome.sdk.advertiser.SAVerifyInstall\" android:exported=\"false\" android:permission=\"tv.superawesome.sdk.SuperAwesomeSDK\">" >> $androidManifest
echo "<intent-filter><action android:name=\"com.android.vending.INSTALL_REFERRER\"/></intent-filter>" >> $androidManifest
echo "</receiver>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

cd ../

################################################################################
# Final step - create different versions of this thing
################################################################################

# goto build
cd $build

zip -r $project.Android.base.jars.zip *

rm *.jar
rm AndroidManifest.xml

# exit
cd
