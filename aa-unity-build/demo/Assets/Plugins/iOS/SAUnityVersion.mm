/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAUnityCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SAVersion.h>)
#import <SuperAwesomeSDK/SAVersion.h>
#else
#import "SAVersion.h"
#endif
#endif

extern "C" {
    
    /**
     * Unity to native iOS method that overrides the current version & sdk
     * strings so that this will get reported correctly in the dashboard.
     *
     * @param versionString pointer to an array of chars containing the version
     * @param sdkString     pointer to an array of chars containing the sdk
     */
    void SuperAwesomeUnityVersionSetVersion (const char *versionString, const char *sdkString) {
        
        NSString *version = [NSString stringWithUTF8String:versionString];
        NSString *sdk = [NSString stringWithUTF8String:sdkString];
        
        [SAVersion overrideVersion:version];
        [SAVersion overrideSdk:sdk];
        
    }
}
