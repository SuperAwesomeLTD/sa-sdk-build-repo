/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAUnityCallback.h"

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else
#import "SuperAwesome.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

extern "C" {
    
    /**
     * Native method called from Unity.
     * Add a callback to the SAVideoAd static class
     */
    void SuperAwesomeUnitySAVideoAdCreate () {
        [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendAdCallback(@"SAVideoAd", placementId, @"adLoaded"); break;
                case adEmpty: sendAdCallback(@"SAVideoAd", placementId, @"adEmpty"); break;
                case adFailedToLoad: sendAdCallback(@"SAVideoAd", placementId, @"adFailedToLoad"); break;
                case adAlreadyLoaded: sendAdCallback(@"SAVideoAd", placementId, @"adAlreadyLoaded"); break;
                case adShown: sendAdCallback(@"SAVideoAd", placementId, @"adShown"); break;
                case adFailedToShow: sendAdCallback(@"SAVideoAd", placementId, @"adFailedToShow"); break;
                case adClicked: sendAdCallback(@"SAVideoAd", placementId, @"adClicked"); break;
                case adEnded: sendAdCallback(@"SAVideoAd", placementId, @"adEnded"); break;
                case adClosed: sendAdCallback(@"SAVideoAd", placementId, @"adClosed"); break;
            }
        }];
    }
    
    /**
     * Native method called from Unity.
     * Load a video ad
     *
     * @param placementId   placement id
     * @param configuration production = 0 / staging = 1
     * @param test          true / false
     */
    void SuperAwesomeUnitySAVideoAdLoad(int placementId, int configuration, bool test) {
        [SAVideoAd setTestMode:test];
        [SAVideoAd setConfiguration:getConfigurationFromInt(configuration)];
        [SAVideoAd load: placementId];
    }
    
    /**
     * Native method called from Unity.
     * Check to see if there is an video ad available
     *
     * @return true / false
     */
    bool SuperAwesomeUnitySAVideoAdHasAdAvailable(int placementId) {
        return [SAVideoAd hasAdAvailable: placementId];
    }
    
    /**
     * Native method called from Unity.
     * Play a video ad
     *
     * @param isParentalGateEnabled         true / false
     * @param isBumperPageEnabled           true / false
     * @param shouldShowCloseButton         true / false
     * @param shouldShowSmallClickButton    true / false
     * @param shouldAutomaticallyCloseAtEnd true / false
     * @param orientation                   ANY = 0 / PORTRAIT = 1 / LANDSCAPE = 2
     */
    void SuperAwesomeUnitySAVideoAdPlay(int placementId, bool isParentalGateEnabled, bool isBumperPageEnabled, bool shouldShowCloseButton, bool shouldShowSmallClickButton, bool shouldAutomaticallyCloseAtEnd, int orientation) {
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAVideoAd setParentalGate:isParentalGateEnabled];
        [SAVideoAd setBumperPage:isBumperPageEnabled];
        [SAVideoAd setCloseButton:shouldShowCloseButton];
        [SAVideoAd setSmallClick:shouldShowSmallClickButton];
        [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
        [SAVideoAd setOrientation: getOrientationFromInt (orientation)];
        [SAVideoAd play: placementId fromVC: root];
    }
    
}
