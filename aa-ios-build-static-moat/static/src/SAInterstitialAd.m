/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAInterstitialAd.h"
#import "SABannerAd.h"
#import "SuperAwesome.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAResponse.h>)
#import <SAModelSpace/SAResponse.h>
#else
#import "SAResponse.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAImageUtils.h>)
#import <SAUtils/SAImageUtils.h>
#else
#import "SAImageUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAEvents/SAEvents.h>)
#import <SAEvents/SAEvents.h>
#else
#import "SAEvents.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAAdLoader/SALoader.h>)
#import <SAAdLoader/SALoader.h>
#else
#import "SALoader.h"
#endif
#endif

#import "SAVersion.h"


@interface SAInterstitialAd ()

// views
@property (nonatomic, strong) SABannerAd *banner;
@property (nonatomic, strong) SAAd       *ad;
@property (nonatomic, strong) UIButton   *closeBtn;

// hold the prev status bar hidden or not
@property (nonatomic, assign) BOOL       previousStatusBarHiddenValue;

@end

@implementation SAInterstitialAd

// current loaded ad
static NSMutableDictionary           *ads;

// other vars that need to be set statically
static sacallback callback           = ^(NSInteger placementId, SAEvent event) {};
static BOOL isParentalGateEnabled    = SA_DEFAULT_PARENTALGATE;
static BOOL isBumperPageEnabled      = SA_DEFAULT_BUMPERPAGE;
static BOOL isTestingEnabled         = SA_DEFAULT_TESTMODE;
static SAOrientation orientation     = SA_DEFAULT_ORIENTATION;
static SAConfiguration configuration = SA_DEFAULT_CONFIGURATION;
static BOOL isMoatLimitingEnabled    = SA_DEFAULT_MOAT_LIMITING_STATE;

/**
 * Overridden UIViewController "viewDidLoad" method in which the ad is setup
 * and redrawn to look good.
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    // get the status bar value
    _previousStatusBarHiddenValue = [[UIApplication sharedApplication] isStatusBarHidden];
    
    // get local versions of the static module vars
    sacallback _callbackL    = [SAInterstitialAd getCallback];
    BOOL _isParentalGateEnabledL = [SAInterstitialAd getIsParentalGateEnabled];
    BOOL _isMoatLimitingEnabledL = [SAInterstitialAd getMoatLimitingState];
    BOOL _isBumperPageEnabledL = [SAInterstitialAd getIsBumperPageEnabled];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAImageUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
    
    // create & play banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectZero];
    [_banner setConfiguration:configuration];
    [_banner setTestMode:isTestingEnabled];
    [_banner setCallback:_callbackL];
    [_banner setBumperPage:_isBumperPageEnabledL];
    [_banner setParentalGate:_isParentalGateEnabledL];
    if (!_isMoatLimitingEnabledL) {
        [_banner disableMoatLimiting];
    }
    [_banner setAd:_ad];
    [self.view addSubview:_banner];
}

/**
 * Overridden UIViewController "didReceiveMemoryWarning" method
 */
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * Overridden UIViewController "viewWillAppear" method in which the status bar
 * is set to hidden and further math is applied to get the correct size
 * to resize the ad to
 *
 * @param animated whether the view will appear animated or not
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // status bar hidden
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    // setup coordinates
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGSize currentSize = CGSizeZero;
    UIDeviceOrientation orientation = (NSInteger)[[UIApplication sharedApplication] statusBarOrientation];
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            currentSize = CGSizeMake(bigDimension, smallDimension);
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:{
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown: {
            if (scrSize.width > scrSize.height){
                currentSize = CGSizeMake(bigDimension, smallDimension);
            }
            else {
                currentSize = CGSizeMake(smallDimension, bigDimension);
            }
            break;
        }
        default: {
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
    }
    
    // resize
    [self resize:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    
    // play the ad
    [_banner play];
}

/**
 * Overridden UIViewController "viewWillDisappear" method in which I reset the
 * status bar state
 *
 * @param animated  whether the view will disappeared animated or not
 */
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHiddenValue
                                            withAnimation:UIStatusBarAnimationNone];
}

/**
 * Overridden UIViewController "viewWillTransitionToSize:withTransitionCoordinator:"
 * in which I resize the ad and it's HTML content to fit the new screen layout.
 * 
 * @param size          the new size to transition to
 * @param coordinator   the coordinator used to transition
 */
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self resize:CGRectMake(0, 0, size.width, size.height)];
}

/**
 * Overridden UIViewController "willRotateToInterfaceOrientation:duration:"
 * in which I get the message that the view will rotate and try to help with
 * maths in order to resize the ad
 *
 * @param toInterfaceOrientation the new interface orientation enum value
 * @param duration               duration of the transition
 */
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            [self resize:CGRectMake(0, 0, bigDimension, smallDimension)];
            break;
        }
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationUnknown:
        default: {
            [self resize:CGRectMake(0, 0, smallDimension, bigDimension)];
            break;
        }
    }
}

/**
 * Overridden UIViewController "supportedInterfaceOrientations" method in which
 * I set the supported orientations
 *
 * @return valid orientations for this view controller
 */
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];

    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
    
    SAOrientation orientationL = [SAInterstitialAd getOrientation];
    
    if (orientationL == PORTRAIT) {
        BOOL isOK = false;
        for (NSString *orientation in supportedOrientations) {
            if ([orientation rangeOfString:@"Portrait"].location != NSNotFound) {
                isOK = true;
                break;
            }
        }
        
        return isOK ? UIInterfaceOrientationMaskPortrait : mask;
        
    } else if (orientationL == LANDSCAPE) {
        
        BOOL isOK = false;
        for (NSString *orientation in supportedOrientations) {
            if ([orientation rangeOfString:@"Landscape"].location != NSNotFound) {
                isOK = true;
                break;
            }
        }
        
        return isOK ? UIInterfaceOrientationMaskLandscape : mask;
        
    }
    
    return mask;
}

/**
 * Overridden UIViewController "shouldAutorotateToInterfaceOrientation" method
 * in which I set that the view controller should auto rotate
 *
 * @return true or false
 */
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/**
 * Overridden UIViewController "prefersStatusBarHidden" method
 * in which I set that the view controller prefers a hidden status bar
 *
 * @return true or false
 */
- (BOOL) prefersStatusBarHidden {
    return true;
}

/**
 * Method that is called to close the ad
 */
- (void) close {
    // null ad
    [SAInterstitialAd removeAdFromLoadedAds:_ad];
    
    // close the banner
    [_banner close];
    
    // dismiss the current VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Method that resizes the ad and it's banner SABannerAd object
 * 
 * @param frame the new frame to resize to
 */
- (void) resize: (CGRect) frame {
    // calc proper new frame
    CGFloat tW = frame.size.width;
    CGFloat tH = frame.size.height;
    CGFloat tX = ( frame.size.width - tW ) / 2;
    CGFloat tY = ( frame.size.height - tH) / 2;
    CGRect newR = [SAUtils map:frame into:CGRectMake(tX, tY, tW, tH)];;
    newR.origin.x += tX;
    newR.origin.y += tY;

    // invoke private banner method
    [_banner resize:newR];
    
    // assign new frames & resize
    [_closeBtn setFrame:CGRectMake(frame.size.width - 40.0f, 0, 40.0f, 40.0f)];
    [self.view bringSubviewToFront:_closeBtn];
}

+ (void) load:(NSInteger) placementId {
    
    // create dictionary
    if (ads == NULL) {
        ads = [@{} mutableCopy];
    }
    
    // if the ad data for the placement id doesn't existing in the "ads"
    // hash map, then proceed with loading it
    if ([ads objectForKey:@(placementId)] == NULL) {
        
        // set a placeholder
        [ads setObject:@(true) forKey:@(placementId)];
        
        // form a new session
        SASession *session = [[SASession alloc] init];
        [session setTestMode:isTestingEnabled];
        [session setConfiguration:configuration];
        [session setVersion:[SAVersion getSdkVersion]];
        
        // get the loader
        SALoader *loader = [[SALoader alloc] init];
        [loader loadAd:placementId withSession:session andResult:^(SAResponse *response) {
            
            if (response.status != 200) {
                
                //
                // make sure to remove this cause the ad load failed
                [ads removeObjectForKey:@(placementId)];
                
                //
                // send callback
                if (callback != NULL) {
                    callback(placementId, adFailedToLoad);
                } else {
                    NSLog(@"Interstitial Ad callback not implemented. Event would have been adFailedToLoad");
                }
            }
            else {
                // add to the array queue
                if ([response isValid]) {
                    [ads setObject:[response.ads objectAtIndex:0] forKey:@(placementId)];
                }
                // remove
                else {
                    [ads removeObjectForKey:@(placementId)];
                }
                
                // callback
                if (callback != NULL) {
                    callback(placementId, [response isValid] ? adLoaded : adEmpty);
                } else {
                    NSLog(@"Interstitial Ad callback not implemented. Event would have been either adLoaded or adEmpty");
                }
            }
        }];
        
    }
    // else if the ad data for the placement exists in the "ads" hash map,
    // then notify the user that it already exists and he should just play it
    else {
        if (callback != NULL) {
            callback (placementId, adAlreadyLoaded);
        } else {
            NSLog(@"Interstitial Ad callback not implemented. Event would have been adAlreadyLoaded");
        }
    }
}

+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent {
    
    // find out if the ad is loaded
    id adL = [ads objectForKey:@(placementId)];
    
    // try to start the view controller (if there is one ad that's OK)
    if (adL && [adL isKindOfClass:[SAAd class]] && ((SAAd*)adL).creative.format != SA_Video) {
        
        // prepare vc
        SAInterstitialAd *newVC = [[SAInterstitialAd alloc] init];
        newVC.ad = (SAAd*)adL;
        
        // remove ad (mark it as played)
        [ads removeObjectForKey:@(placementId)];
        
        // present vc
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        if (callback != NULL) {
            callback(placementId, adFailedToShow);
        } else {
            NSLog(@"Interstitial Ad callback not implemented. Event would have been adFailedToShow");
        }
    }
}

+ (BOOL) hasAdAvailable: (NSInteger) placementId {
    id object = [ads objectForKey:@(placementId)];
    return object != NULL && [object isKindOfClass:[SAAd class]];
}

+ (SAAd*) getAd:(NSInteger) placementId {
    
    if ([ads objectForKey:@(placementId)] != NULL) {
        NSObject *obj = [ads objectForKey:@(placementId)];
        if (obj != NULL && [obj isKindOfClass:[SAAd class]]) {
            return (SAAd*) obj;
        } else {
            return NULL;
        }
    }
    else {
        return NULL;
    }
}

+ (void) setAd: (SAAd*) ad {
    
    if (ads == NULL) {
        ads = [@{} mutableCopy];
    }
    
    if (ad != nil && [ad isValid]) {
        [ads setObject:ad forKey:@(ad.placementId)];
    }
}

/**
 * Method that clears an ad from the dictionary of ads, once it has been played
 *
 * @param ad the SAAd object to be cleared
 */
+ (void) removeAdFromLoadedAds:(SAAd*)ad {
    [ads removeObjectForKey:@(ad.placementId)];
}

+ (void) setCallback:(sacallback)call {
    callback = call ? call : callback;
}

+ (void) enableTestMode {
    [self setTestMode:true];
}

+ (void) disableTestMode {
    [self setTestMode:false];
}

+ (void) enableParentalGate {
    [self setParentalGate:true];
}

+ (void) disableParentalGate {
    [self setParentalGate:false];;
}

+ (void) enableBumperPage {
    [self setBumperPage:true];
}

+ (void) disableBumperPage {
    [self setBumperPage:false];
}

+ (void) setConfigurationProduction {
    [self setConfiguration:PRODUCTION];
}

+ (void) setConfigurationStaging {
    [self setConfiguration:STAGING];
}

+ (void) setOrientationAny {
    [self setOrientation:ANY];
}

+ (void) setOrientationPortrait {
    [self setOrientation:PORTRAIT];
}

+ (void) setOrientationLandscape {
    [self setOrientation:LANDSCAPE];
}

+ (void) setTestMode: (BOOL) value {
    isTestingEnabled = value;
}

+ (void) setParentalGate: (BOOL) value {
    isParentalGateEnabled = value;
}

+ (void) setBumperPage: (BOOL) value {
    isBumperPageEnabled = value;
}

+ (void) setConfiguration: (NSInteger) value {
    configuration = value;
}

+ (void) setOrientation: (SAOrientation) value {
    orientation = value;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
}

+ (BOOL) getIsBumperPageEnabled {
    return isBumperPageEnabled;
}

+ (sacallback) getCallback {
    return callback;
}

+ (SAOrientation) getOrientation {
    return orientation;
}

+ (void) disableMoatLimiting {
    isMoatLimitingEnabled = false;
}

+ (BOOL) getMoatLimitingState {
    return isMoatLimitingEnabled;
}
                                    

@end
