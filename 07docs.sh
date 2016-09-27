#!/bin/bash -ex

#
# variables
sdk_company="2016, SuperAwesome Ltd"
sdk_theme_folder="themes"
sdk_themeres_folder="themeres"
sdk_theme="satheme"
sdk_aa_domain="AwesomeAds"
sdk_kws_domain="KWS"
sdk_devsuspport="devsupport@superawesome.tv"
sdk_iosmin="iOS 6.0+"
sdk_androidmin="API 11: Android 3.0 (Honeycomb)"
sdk_author="Gabriel Coman"

# create a docs folder
if [ -d docs ]
then
    rm -rf docs
fi
mkdir docs

docs_repos=(
	"git@github.com:SuperAwesomeLTD/sa-mobile-sdk-ios-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-mobile-sdk-android-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-adobeair-sdk-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-flash-sdk-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-unity-sdk-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-web-sdk-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-kws-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-kws-ios-sdk-docs.git"
	"git@github.com:SuperAwesomeLTD/sa-kws-android-sdk-docs.git"
)
sdk_sources=(
    "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios"
    "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-android"
    "https://github.com/SuperAwesomeLTD/sa-adobeair-sdk"
    "https://github.com/SuperAwesomeLTD/sa-flash-sdk"
    "https://github.com/SuperAwesomeLTD/sa-unity-sdk"
    "https://github.com/SuperAwesomeLTD/sa-ads-server"
    "https://github.com/SuperAwesomeLTD/sa-kws-api"
    "https://github.com/SuperAwesomeLTD/sa-kws-ios-sdk-objc"
    "https://github.com/SuperAwesomeLTD/sa-kws-android-sdk"
)
sdk_projects=(
    "iOS SDK"
    "Android SDK"
    "Adobe AIR SDK"
    "Flash SDK"
    "Unity SDK"
    "Web SDK"
    "Web SDK"
    "iOS SDK"
    "Android SDK"
)
dest_folders=(
    "sa-mobile-sdk-ios"
    "sa-mobile-sdk-android"
    "sa-adobeair-sdk"
    "sa-flash-sdk"
    "sa-unity-sdk"
    "sa-web-sdk"
    "sa-kws"
    "sa-kws-ios-sdk"
    "sa-kws-android-sdk"
)
versions_array=(
    $sdk_version_ios
    $sdk_version_android
    $sdk_version_air
    $sdk_version_flash
    $sdk_version_unity
    $sdk_version_web
    $sdk_kws_version_web
    $sdk_kws_version_ios
    $sdk_kws_version_android
)

for i in {0..8}
do
    doc_repo=${docs_repos[$i]}
    sdk_source=${sdk_sources[$i]}
    sdk_project=${sdk_projects[$i]}
    dest_folder=${dest_folders[$i]}
		ldoc_repo=$dest_folder"-docs"
    c_version=${versions_array[$i]}

		# clone
		cd docs
		git clone -b master $doc_repo
		cd $ldoc_repo
		cd source

		# delete old theme
    rm -rf $sdk_theme_folder
    rm -rf $sdk_themeres_folder

		# get and setup new theme
    rm -rf sa-docs-sphinx-theme
    git clone -b master git@github.com:SuperAwesomeLTD/sa-docs-sphinx-theme.git
    mkdir $sdk_theme_folder
    mkdir $sdk_theme_folder/$sdk_theme
    mkdir $sdk_themeres_folder
    cp -rf sa-docs-sphinx-theme/* $sdk_theme_folder/$sdk_theme/
    cp sa-docs-sphinx-theme/static/img/* $sdk_themeres_folder/
    rm -rf sa-docs-sphinx-theme

		cd ../

		# create temporary rsource folder
    rm -rf rsource
    mkdir rsource
    cp -rf source/* rsource

		# replace variables in rsource
    cd rsource
    sed -i.sedbak "s|<sdk_company>|$sdk_company|g" *.*
    sed -i.sedbak "s|<sdk_theme_folder>|$sdk_theme_folder|g" *.*
    sed -i.sedbak "s|<sdk_themeres_folder>|$sdk_themeres_folder|g" *.*
    sed -i.sedbak "s|<sdk_theme>|$sdk_theme|g" *.*
    sed -i.sedbak "s|<sdk_aa_domain>|$sdk_aa_domain|g" *.*
    sed -i.sedbak "s|<sdk_kws_domain>|$sdk_kws_domain|g" *.*
    sed -i.sedbak "s|<sdk_devsuspport>|$sdk_devsuspport|g" *.*
    sed -i.sedbak "s|<sdk_iosmin>|$sdk_iosmin|g" *.*
    sed -i.sedbak "s|<sdk_androidmin>|$sdk_androidmin|g" *.*
    sed -i.sedbak "s|<sdk_project>|$sdk_project|g" *.*
    sed -i.sedbak "s|<sdk_version_ios>|$sdk_version_ios|g" *.*
    sed -i.sedbak "s|<sdk_version_android>|$sdk_version_android|g" *.*
    sed -i.sedbak "s|<sdk_version_unity>|$sdk_version_unity|g" *.*
    sed -i.sedbak "s|<sdk_version_air>|$sdk_version_air|g" *.*
    sed -i.sedbak "s|<sdk_version_flash>|$sdk_version_flash|g" *.*
    sed -i.sedbak "s|<sdk_version_web>|$sdk_version_web|g" *.*
    sed -i.sedbak "s|<sdk_version_kws>|$sdk_version_kws|g" *.*
    sed -i.sedbak "s|<sdk_version_kws_ios>|$sdk_version_kws_ios|g" *.*
    sed -i.sedbak "s|<sdk_version_kws_android>|$sdk_version_kws_android|g" *.*
    sed -i.sedbak "s|<sdk_source>|$sdk_source|g" *.*
    sed -i.sedbak "s|<sdk_author>|$sdk_author|g" *.*
    find . -name "*.*sedbak" -print0 | xargs -0 rm
    cd ../

		# finally make the sphinx doc and cleanup
    make -f Makefile html
    rm -rf rsource

		# copy build
    if [ -d ../../../sa-dev-site/public/extdocs/$dest_folder/ ]
    then
        rm -rf ../../../sa-dev-site/public/extdocs/$dest_folder/
    fi
    mkdir ../../../sa-dev-site/public/extdocs/$dest_folder/
    cp -rf build/ ../../../sa-dev-site/public/extdocs/$dest_folder/
    rm -rf ../../../sa-dev-site/public/extdocs/$dest_folder-docs/

		# go back
		cd ../..

done

cd
cd $workspace/

# Upload final documentation
cd sa-dev-site
git status
fullDocCommitMessage="Update SDK docs version"
git add public/extdocs/
git commit -am "$fullDocCommitMessage"
git push origin master
git push heroku-production master
