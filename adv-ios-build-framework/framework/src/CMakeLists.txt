file( GLOB SRCS *.m *.h )
add_library( SuperAwesomeAdvertiserSDK SHARED ${SRCS} )
target_compile_options(SuperAwesomeAdvertiserSDK PUBLIC "-fobjc-arc")
target_compile_options(SuperAwesomeAdvertiserSDK PUBLIC "-fmodules")
target_compile_options(SuperAwesomeAdvertiserSDK PUBLIC "-fembed-bitcode")
set_property(TARGET SuperAwesomeAdvertiserSDK PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "8.0")
set_target_properties( SuperAwesomeAdvertiserSDK PROPERTIES
FRAMEWORK TRUE
FRAMEWORK_VERSION C
MACOSX_FRAMEWORK_IDENTIFIER tv.superawesome.SuperAwesomeAdvertiserSDK
MACOSX_FRAMEWORK_INFO_PLIST Info.plist
MACOSX_RPATH TRUE
PUBLIC_HEADER framework/src/SuperAwesomeAdvertiserSDK.h
)
