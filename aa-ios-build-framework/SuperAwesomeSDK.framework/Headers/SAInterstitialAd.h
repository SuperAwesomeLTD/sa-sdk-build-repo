/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SACallback.h"
#import "SAOrientation.h"

@class SAAd;

/**
 * Class that abstracts away the process of loading & displaying
 * an Interstitial type Ad.
 * A subclass of the iOS "UIViewController" class.
 */
@interface SAInterstitialAd : UIViewController

/**
 * Method that loads an ad into the queue.
 * Ads can only be loaded once and then can be reloaded after they've
 * been played.
 *
 * @param placementId   the Ad placement id to load data for
 */
+ (void) load:(NSInteger) placementId;

/**
 * Method that, if an ad data is loaded, will play
 * the content for the user
 *
 * @param placementId   the Ad placement id to play an ad for
 * @param parent        the parent view controller
 */
+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent;

/**
 * Method that returns whether ad data for a certain placement
 * has already been loaded
 *
 * @param placementId   the Ad placement id to check for
 * @return              true or false
 */
+ (BOOL) hasAdAvailable:(NSInteger) placementId;

+ (SAAd*) getAd:(NSInteger) placementId;

/**
 * Method used for testing purposes (and the AwesomeApp) to manually put 
 * an ad in the interstitial ads map
 *
 * @param ad an instance of SAAd
 */
+ (void) setAd: (SAAd*) ad;

/**
 * Group of methods that set ad configuration parameters
 */
+ (void) setCallback:(sacallback)call;
+ (void) enableTestMode;
+ (void) disableTestMode;
+ (void) setConfigurationProduction;
+ (void) setConfigurationStaging;
+ (void) setOrientationAny;
+ (void) setOrientationPortrait;
+ (void) setOrientationLandscape;
+ (void) setTestMode: (BOOL) value;
+ (void) setParentalGate: (BOOL) value;
+ (void) setBumperPage: (BOOL) value;
+ (void) setConfiguration: (NSInteger) value;
+ (void) setOrientation: (SAOrientation) value;
+ (void) disableMoatLimiting;

+ (void) enableBumperPage;
+ (void) disableBumperPage;
+ (void) enableParentalGate;
+ (void) disableParentalGate;


@end
