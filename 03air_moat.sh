#!/bin/bash -ex

# start
cd

# ##############################################################################
# 1) Start copying JAR libraries for Android build to AIR build
# ##############################################################################

# create dest folders
mkdir "$air_moat_build/android"
mkdir "$air_moat_build/default"

air_sources=(
    "samodelspace.jar"
    "sajsonparser.jar"
    "saevents.jar"
    "savastparser.jar"
    "sautils.jar"
    "sasession.jar"
    "savideoplayer.jar"
    "sawebplayer.jar"
    "saadloader.jar"
    "sanetwork.jar"
    "superawesome-$sdk_version_android.jar"
    "samoatevents.jar"
    "moatlib.jar"
    "saair.jar"
)

for i in {0..13}
do cp "$android_build/${air_sources[$i]}" "$air_moat_build/android"
done

# ##############################################################################
# 2) Copy services (Google)
# ##############################################################################

air_services=(
    "play-services-ads-8.4.0.jar"
    "play-services-base-8.4.0.jar"
    "play-services-basement-8.4.0.jar"
)

for i in {0..2}
do cp "$build_repo/presets/${air_services[$i]}" "$air_moat_build/android"
done

# ##############################################################################
# 3) Copy resources
# ##############################################################################

# start
cd

cd "$air_moat_build/android"
mkdir res
mkdir res/drawable
mkdir res/layout
cd
cp -r "$android_build/superawesome-res/layout/" "$air_moat_build/android/res/layout/"
cp -r "$android_build/superawesome-res/drawable/" "$air_moat_build/android/res/drawable/"

# exit
cd

# ##############################################################################
# 4) Get the Flash library
# ##############################################################################

# start
cd

cp "$workspace/sa-adobeair-sdk/bin/SuperAwesome_AIR.swc" "$air_moat_build/"
cd $air_moat_build
cp SuperAwesome_AIR.swc SuperAwesome_AIR.zip
mkdir tmp
unzip SuperAwesome_AIR.zip -d tmp
cp tmp/library.swf android/
cp tmp/library.swf default/
rm -rf tmp
rm SuperAwesome_AIR.zip

# exit
cd

# ##############################################################################
# 5) Write the extension file
# ##############################################################################

# start
cd

cd $air_moat_build

# write to file
extensionFile="extension.xml"
echo "<extension xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $extensionFile
echo "<id>tv.superawesome.plugins.air</id>" >> $extensionFile
echo "<versionNumber>1.0.0</versionNumber>" >> $extensionFile
echo "<platforms>" >> $extensionFile
echo "<platform name=\"Android-ARM\">" >> $extensionFile
echo "<applicationDeployment> " >> $extensionFile
echo "<nativeLibrary>saair.jar</nativeLibrary>" >> $extensionFile
echo "<initializer>tv.superawesome.plugins.air.SAAIRExtension</initializer>" >> $extensionFile
echo "</applicationDeployment>" >> $extensionFile
echo "</platform>" >> $extensionFile
echo "<platform name=\"default\">" >> $extensionFile
echo "<applicationDeployment/>" >> $extensionFile
echo "</platform>" >> $extensionFile
echo "</platforms>" >> $extensionFile
echo "</extension>" >> $extensionFile

# exit
cd

# ##############################################################################
# 6) Write the paltform file
# ##############################################################################

# start
cd

cd $air_moat_build

platformFile="platform.xml"
echo "<platform xmlns=\"http://ns.adobe.com/air/extension/21.0\">" > $platformFile
echo "<packagedDependencies>" >> $platformFile
for i in {0..12}
do echo "<packagedDependency>${air_sources[$i]}</packagedDependency>" >> $platformFile
done
for i in {0..2}
do echo "<packagedDependency>${air_services[$i]}</packagedDependency>" >> $platformFile
done
echo "</packagedDependencies>" >> $platformFile
echo "<packagedResources>" >> $platformFile
echo "<packagedResource>" >> $platformFile
echo "<packageName>tv.superawesome.sdk</packageName>" >> $platformFile
echo "<folderName>res</folderName>" >> $platformFile
echo "</packagedResource>" >> $platformFile
echo "</packagedResources>" >> $platformFile
echo "</platform>" >> $platformFile

# exit
cd

# ##############################################################################
# 7) Make the build
# ##############################################################################

cd
cd $air_moat_build

/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/21.0.0/bin/adt -package -target ane SuperAwesomeSDK-Moat-$sdk_version_air.ane extension.xml -swc SuperAwesome_AIR.swc -platform Android-ARM -C android . -platformoptions platform.xml -platform default -C default .

# exit
cd
