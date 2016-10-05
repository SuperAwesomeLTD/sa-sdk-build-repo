#!/bin/bash -ex

################################################################################
# 1) Move all AARs into JARs
################################################################################

# start
cd

source_folder="$workspace/sa-flash-sdk/bin"

cp "$source_folder/SuperAwesome_Flash.swc" "$flash_build/SuperAwesomeSDK.swc"

# exit
cd
