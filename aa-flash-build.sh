#!/bin/bash -ex

# build folder for all the jars
build="aa-flash-build"
# project
project="SuperAwesomeSDK"

# rebuild the build folder
rm -rf $build && mkdir $build

################################################################################
# Copy folder
################################################################################

# set source and repo
source=sa-flash-sdk
repository=git@github.com:SuperAwesomeLTD/$source.git

# clone the git repo
rm -rf $source && git clone -b master $repository

# get the project var
this=$(pwd)

################################################################################
# Start building
################################################################################

cd /Applications/Adobe\ Flash\ Builder\ 4.7/sdks/22.0.0/bin
./compc \
	-source-path $this/$source/src \
	-debug=false \
	-output $this/$build/$project.AdobeFlash.swc \
	-include-sources=$this/$source/src \
	-include-file \
		close.png $this/$source/src/resources/close.png \
		mark.png $this/$source/src/resources/mark.png

# cleanup
cd $this
rm -rf $source

# exit
cd
