#!/bin/bash -ex

# build folder for all the jars
build="aa-android-moat-build"
# project
project="SuperAwesomeSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

sources=(
		"sa-mobile-sdk-android"
    "sa-mobile-lib-android-adloader"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-events"
    "sa-mobile-lib-android-jsonparser"
    "sa-mobile-lib-android-modelspace"
    "sa-mobile-lib-android-network"
    "sa-mobile-lib-android-session"
    "sa-mobile-lib-android-utils"
    "sa-mobile-lib-android-videoplayer"
		"sa-mobile-lib-android-vastparser"
    "sa-mobile-lib-android-webplayer"
		"sa-mobile-lib-android-parentalgate"
		"sa-mobile-lib-android-bumper"
)

destinations=(
		"superawesome-base"
		"saadloader"
		"saevents"
		"samoatevents"
		"sajsonparser"
    "samodelspace"
    "sanetwork"
		"sasession"
		"sautils"
		"savideoplayer"
		"savastparser"
    "sawebplayer"
		"saparentalgate"
		"sabumperpage"
)

for i in {0..13}
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
	if [ $destination = "superawesome-base" ]
	then

		# copy main SDK & AIR lib
		cp superawesome-base/build/outputs/aar/superawesome-base-release.aar ../$build/superawesome-base.zip

		# goto build/android folder
		cd ../$build

		# unzip the superawesome sdk
		unzip superawesome-base.zip -d superawesome-base && rm superawesome-base.zip
		cp superawesome-base/classes.jar superawesome-base.jar && rm -rf superawesome-base

	# case when it's one of the libraries
	else

		# copy outputs into the build folder
		cp $destination/build/outputs/aar/$destination-release.aar ../$build/$destination.zip

		# try finding the moatlib and copying  it
		if [ -f $destination/libs/moatlib.jar ]
		then
			cp $destination/libs/moatlib.jar ../$build/moatlib.jar
		fi

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
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk.publisher\">" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.INTERNET\" />" >> $androidManifest
echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\"/>" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.publisher.SAVideoAd\" android:label=\"SAFullscreenVideoAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.publisher.SAInterstitialAd\" android:label=\"SAInterstitialAd\" android:theme=\"@android:style/Theme.Black.NoTitleBar.Fullscreen\" android:configChanges=\"keyboardHidden|orientation|screenSize\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.lib.sabumperpage.SABumperPage\" android:label=\"SABumperPage\" android:configChanges=\"keyboardHidden|orientation|screenSize\" android:theme=\"@android:style/Theme.Holo.Dialog.NoActionBar\" android:excludeFromRecents=\"true\"/>" >> $androidManifest
echo "</application>" >> $androidManifest
echo "</manifest>" >> $androidManifest

cd ../

################################################################################
# Final step - create different versions of this thing
################################################################################

# goto build
cd $build

zip -r $project.Android.full.jars.zip *

rm *.jar
rm AndroidManifest.xml

# exit
cd
