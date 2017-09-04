#!/bin/bash -ex

# build folder for all the jars
build="ag-android-build"
# project
project="SAAgeGateSDK"

# create the build folder
rm -rf $build && mkdir $build

################################################################################
# Build all the android libraries (as jars) and resources
################################################################################

# form vars for each library
source="sa-mobile-sdk-agegate-android"
destination="saagegate"
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

# go to where the zip is
cd ../$build

# unzip the library thing
unzip $destination.zip -d $destination && rm $destination.zip
cp $destination/classes.jar $destination.jar && rm -rf $destination

# exit to main folder
cd ../

# delete the source
rm -rf $source

################################################################################
# Add a manifest file to the build
################################################################################

cd $build

androidManifest="AndroidManifest.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $androidManifest
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"tv.superawesome.sdk.agegate\">" >> $androidManifest
echo "<application>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.agegate.SAAgeGate\" android:label=\"SAAgeGate\" android:configChanges=\"keyboardHidden|orientation|screenSize\" android:theme=\"@android:style/Theme.Holo.Dialog.NoActionBar\" android:excludeFromRecents=\"true\"/>" >> $androidManifest
echo "<activity android:name=\"tv.superawesome.sdk.agegate.SAAgeInput\" android:theme=\"@android:style/Theme.Translucent.NoTitleBar\"/>" >> $androidManifest
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
