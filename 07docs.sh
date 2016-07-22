#!/bin/bash -ex

#
# variables
sdk_company="2016, SuperAwesome Ltd"
sdk_theme_folder="themes"
sdk_themeres_folder="themeres"
sdk_theme="satheme"
sdk_aa_domain="AwesomeAds"
sdk_devsuspport="devsupport@superawesome.tv"
sdk_iosmin="iOS 6.0+"
sdk_androidmin="API 11: Android 3.0 (Honeycomb)"
sdk_author="Gabriel Coman"

doc_folders=(
    "$workspace/sa-mobile-sdk-ios-docs"
    "$workspace/sa-mobile-sdk-android-docs"
    "$workspace/sa-adobeair-sdk-docs"
    "$workspace/sa-flash-sdk-docs"
    "$workspace/sa-unity-sdk-docs"
    "$workspace/sa-web-sdk-docs"
)
sdk_sources=(
    "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios"
    "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-android"
    "https://github.com/SuperAwesomeLTD/sa-adobeair-sdk"
    "https://github.com/SuperAwesomeLTD/sa-flash-sdk"
    "https://github.com/SuperAwesomeLTD/sa-unity-sdk"
    "https://github.com/SuperAwesomeLTD/sa-ads-server"
)
sdk_projects=(
    "iOS SDK"
    "Android SDK"
    "Adobe AIR SDK"
    "Flash SDK"
    "Unity SDK"
    "Web SDK"
)
dest_folders=(
    "sa-mobile-sdk-ios"
    "sa-mobile-sdk-android"
    "sa-adobeair-sdk"
    "sa-flash-sdk"
    "sa-unity-sdk"
    "sa-web-sdk"
)
versions_array=(
    $sdk_version_ios
    $sdk_version_android
    $sdk_version_air
    $sdk_version_flash
    $sdk_version_unity
    $sdk_version_web
)

for i in {0..5}
do
    doc_folder=${doc_folders[$i]}
    sdk_source=${sdk_sources[$i]}
    sdk_project=${sdk_projects[$i]}
    dest_folder=${dest_folders[$i]}
    c_version=${versions_array[$i]}

    # enter folder
    cd $doc_folder
    cd source

    # delete old theme
    rm -rf $sdk_theme_folder
    rm -rf $sdk_themeres_folder

    # get and setup new theme
    rm -rf sa-docs-sphinx-theme
    git clone -b master https://github.com/SuperAwesomeLTD/sa-docs-sphinx-theme.git
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
    sed -i sedbak "s|<sdk_company>|$sdk_company|g" *.*
    sed -i sedbak "s|<sdk_theme_folder>|$sdk_theme_folder|g" *.*
    sed -i sedbak "s|<sdk_themeres_folder>|$sdk_themeres_folder|g" *.*
    sed -i sedbak "s|<sdk_theme>|$sdk_theme|g" *.*
    sed -i sedbak "s|<sdk_aa_domain>|$sdk_aa_domain|g" *.*
    sed -i sedbak "s|<sdk_devsuspport>|$sdk_devsuspport|g" *.*
    sed -i sedbak "s|<sdk_iosmin>|$sdk_iosmin|g" *.*
    sed -i sedbak "s|<sdk_androidmin>|$sdk_androidmin|g" *.*
    sed -i sedbak "s|<sdk_project>|$sdk_project|g" *.*
    sed -i sedbak "s|<sdk_version_ios>|$sdk_version_ios|g" *.*
    sed -i sedbak "s|<sdk_version_android>|$sdk_version_android|g" *.*
    sed -i sedbak "s|<sdk_version_unity>|$sdk_version_unity|g" *.*
    sed -i sedbak "s|<sdk_version_air>|$sdk_version_air|g" *.*
    sed -i sedbak "s|<sdk_version_flash>|$sdk_version_flash|g" *.*
    sed -i sedbak "s|<sdk_version_web>|$sdk_version_web|g" *.*
    sed -i sedbak "s|<sdk_source>|$sdk_source|g" *.*
    sed -i sedbak "s|<sdk_author>|$sdk_author|g" *.*
    find . -name "*.*sedbak" -print0 | xargs -0 rm
    cd ../

    # finally make the sphinx doc and cleanup
    make -f Makefile html
    rm -rf rsource

    # do git stuff
    cdate=$(($(date +'%s * 1000 + %-N / 1000000')))
    echo "Updated to "$c_version" on "$cdate" "  >> "CHANGELOG"
    git status
    git add . --all
    docCommitMessage="Update SDK docs to version "$c_version
    git commit -am "$docCommitMessage"
    git push origin master

    # copy build
    if [ -d ../sa-dev-site/public/extdocs/$dest_folder/ ]
    then
        rm -rf ../sa-dev-site/public/extdocs/$dest_folder/
    fi
    mkdir ../sa-dev-site/public/extdocs/$dest_folder/
    cp -rf build/ ../sa-dev-site/public/extdocs/$dest_folder/

    # exit folder
    cd ../
done

# Upload final documentation
cd sa-dev-site
git status
fullDocCommitMessage="Update SDK docs version"
git commit -am "$fullDocCommitMessage"
git push origin master
git push heroku-production master
