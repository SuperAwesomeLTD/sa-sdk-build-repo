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
     * Adds a callback to the SAGameWall static method class
     */
    void SuperAwesomeUnitySAAppWallCreate () {
        [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendAdCallback(@"SAAppWall", placementId, @"adLoaded"); break;
                case adEmpty: sendAdCallback(@"SAAppWall", placementId, @"adEmpty"); break;
                case adFailedToLoad: sendAdCallback(@"SAAppWall", placementId, @"adFailedToLoad"); break;
                case adAlreadyLoaded: sendAdCallback(@"SAAppWall", placementId, @"adAlreadyLoaded"); break;
                case adShown: sendAdCallback(@"SAAppWall", placementId, @"adShown"); break;
                case adFailedToShow: sendAdCallback(@"SAAppWall", placementId, @"adFailedToShow"); break;
                case adClicked: sendAdCallback(@"SAAppWall", placementId, @"adClicked"); break;
                case adEnded: sendAdCallback(@"SAAppWall", placementId, @"adEnded"); break;
                case adClosed: sendAdCallback(@"SAAppWall", placementId, @"adClosed"); break;
            }
        }];
    }
    
    /**
     * Native method called from Unity.
     * Load a gamewall ad.
     *
     * @param placementId   the placement id to try to load an ad for
     * @param configuration production = 0 / staging = 1
     * @param test          true / false
     */
    void SuperAwesomeUnitySAAppWallLoad (int placementId, int configuration, bool test) {
        [SAAppWall setTestMode:test];
        [SAAppWall setConfiguration:getConfigurationFromInt(configuration)];
        [SAAppWall load: placementId];
    }
    
    /**
     * Native method called from Unity.
     * Check to see if there's an ad available for the GameWall
     *
     * @return true / false
     */
    bool SuperAwesomeUnitySAAppWallHasAdAvailable(int placementId) {
        return [SAAppWall hasAdAvailable: placementId];
    }
    
    /**
     * Native method called from Unity.
     * Play a GameWall Ad
     *
     * @param placementId           true / false
     * @param isParentalGateEnabled true / false
     * @param isBumperPageEnabled   true / false
     */
    void SuperAwesomeUnitySAAppWallPlay (int placementId, bool isParentalGateEnabled, bool isBumperPageEnabled) {
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAAppWall setParentalGate:isParentalGateEnabled];
        [SAAppWall setBumperPage:isBumperPageEnabled];
        [SAAppWall play: placementId fromVC: root];
    }
    
}
