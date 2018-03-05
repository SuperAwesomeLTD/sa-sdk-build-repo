file( GLOB SRCS *.m *.h )
add_library( SuperAwesomeSDK SHARED ${SRCS} )
target_compile_options(SuperAwesomeSDK PUBLIC "-fobjc-arc")
target_compile_options(SuperAwesomeSDK PUBLIC "-fmodules")
target_compile_options(SuperAwesomeSDK PUBLIC "-fembed-bitcode")
set_property(TARGET SuperAwesomeSDK PROPERTY XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "8.0")
set_target_properties( SuperAwesomeSDK PROPERTIES
FRAMEWORK TRUE
FRAMEWORK_VERSION C
MACOSX_FRAMEWORK_IDENTIFIER tv.superawesome.SuperAwesomeSDK
MACOSX_FRAMEWORK_INFO_PLIST Info.plist
MACOSX_RPATH TRUE
PUBLIC_HEADER framework/src/SuperAwesomeSDK.h
)
