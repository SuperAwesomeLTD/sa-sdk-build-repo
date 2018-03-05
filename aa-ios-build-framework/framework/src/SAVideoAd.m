/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVideoAd.h"
#import "SAParentalGate.h"
#import "SuperAwesome.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
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
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
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
#if __has_include(<SAAdLoader/SALoader.h>)
#import <SAAdLoader/SALoader.h>
#else
#import "SALoader.h"
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
#if __has_include(<SAVideoPlayer/SAVideoPlayer.h>)
#import <SAVideoPlayer/SAVideoPlayer.h>
#else
#import "SAVideoPlayer.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SABumperPage/SABumperPage.h>)
#import <SABumperPage/SABumperPage.h>
#else
#import "SABumperPage.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAParentalGate/SAParentalGate.h>)
#import <SAParentalGate/SAParentalGate.h>
#else
#import "SAParentalGate.h"
#endif
#endif

#import "SAVersion.h"


@interface SAVideoAd ()

// aux
@property (nonatomic, assign) BOOL           isOKToClose;

// views
@property (nonatomic, strong) UIButton       *closeBtn;
@property (nonatomic, strong) UIButton       *padlock;
@property (nonatomic, strong) SAVideoPlayer  *player;

// events
@property (nonatomic, strong) SAEvents       *events;

// the ad
@property (nonatomic, strong) SAAd           *ad;

// hold the prev status bar hidden or not
@property (nonatomic, assign) BOOL           previousStatusBarHiddenValue;

@property (nonatomic, assign) BOOL           videoEnded;

@end

@implementation SAVideoAd

// dictionary of ads
static NSMutableDictionary                  *ads;

// current static session
static SASession                            *session;

// other static vars needed for state
static sacallback callback                  = ^(NSInteger placementId, SAEvent event) {};
static sacallback forceloadcallback         = ^(NSInteger placementId, SAEvent event){};
static BOOL isTestingEnabled                = SA_DEFAULT_TESTMODE;
static BOOL isParentalGateEnabled           = SA_DEFAULT_PARENTALGATE;
static BOOL isBumperPageEnabled             = SA_DEFAULT_BUMPERPAGE;
static BOOL shouldAutomaticallyCloseAtEnd   = SA_DEFAULT_CLOSEATEND;
static BOOL shouldShowCloseButton           = SA_DEFAULT_CLOSEBUTTON;
static BOOL shouldShowSmallClickButton      = SA_DEFAULT_SMALLCLICK;
static SAOrientation orientation            = SA_DEFAULT_ORIENTATION;
static SAConfiguration configuration        = SA_DEFAULT_CONFIGURATION;
static BOOL isMoatLimitingEnabled           = SA_DEFAULT_MOAT_LIMITING_STATE;

/**
 * Overridden UIViewController "viewDidLoad" method in which the ad is setup
 * and redrawn to look good.
 */
- (void) viewDidLoad {
    [super viewDidLoad];
    
    // here video is not yet loaded
    _videoEnded = false;
    
    // get the status bar value
    _previousStatusBarHiddenValue = [[UIApplication sharedApplication] isStatusBarHidden];
    
    // get main static vars into local ones
    __block sacallback _callbackL = [SAVideoAd getCallback];
    __block BOOL _isParentalGateEnabledL = [SAVideoAd getIsParentalGateEnabled];
    __block BOOL _shouldAutomaticallyCloseAtEndL = [SAVideoAd getShouldAutomaticallyCloseAtEnd];
    __block BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    if (!_shouldShowCloseButtonL && _videoEnded) _shouldShowCloseButtonL = true;
    __block BOOL _shouldShowSmallClickButtonL = [SAVideoAd getShouldShowSmallClickButton];
    __block BOOL _shouldShowPadlockL = _ad.isPadlockVisible;
    __block BOOL _isMoatLimitingEnabledL = [SAVideoAd getMoatLimitingState];
    
    // start events
    _events = [[SAEvents alloc] init];
    [_events setAd:_ad andSession:session];
    if (!_isMoatLimitingEnabledL) {
        [_events disableMoatLimiting];
    }
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // create the player
    _player = [[SAVideoPlayer alloc] initWithFrame:CGRectZero];
    if (_shouldShowSmallClickButtonL) {
        [_player showSmallClickButton];
    }
    
    // set event handler for player
    [_player setEventHandler:^(SAVideoPlayerEvent event) {
        switch (event) {
            case Video_Start: {
                
                // is OK to close
                weakSelf.isOKToClose = true;
                
                // send vast ad impressions
                [weakSelf.events triggerVASTImpressionEvent];
                [weakSelf.events triggerVASTCreativeViewEvent];
                [weakSelf.events triggerVASTStartEvent];
                
                // send viewable impression
                [weakSelf.events checkViewableStatusForVideo:weakSelf.player andResponse:^(BOOL success) {
                    if (success) {
                        [weakSelf.events triggerViewableImpressionEvent];
                    }
                }];
                
                // moat
                [weakSelf.events startMoatTrackingForVideoPlayer:[weakSelf.player getPlayer]
                                                       withLayer:[weakSelf.player getPlayerLayer]
                                                         andView:[weakSelf view]];
                
                // callback
                if (_callbackL != NULL) {
                    _callbackL(weakSelf.ad.placementId, adShown);
                } else {
                    NSLog(@"Video Ad callback not implemented. Event would have been adShown");
                }
                
                break;
            }
            case Video_1_4: {
                [weakSelf.events triggerVASTFirstQuartileEvent];
                break;
            }
            case Video_1_2: {
                [weakSelf.events triggerVASTMidpointEvent];
                break;
            }
            case Video_3_4: {
                [weakSelf.events triggerVASTThirdQuartileEvent];
                break;
            }
            case Video_End: {
                
                // trigger ad ended
                if (_callbackL != NULL) {
                    _callbackL(weakSelf.ad.placementId, adEnded);
                } else {
                    NSLog(@"Video Ad callback not implemented. Event would have been adEnded");
                }
                
                // send complete events
                [weakSelf.events triggerVASTCompleteEvent];
                
                // make btn visible
                weakSelf.videoEnded = true;
                [weakSelf.closeBtn setHidden:false];
                [weakSelf.closeBtn setFrame:CGRectMake(weakSelf.view.frame.size.width - 40.0f, 0, 40.0f, 40.0f)];
                [weakSelf.view bringSubviewToFront:weakSelf.closeBtn];
                
                // close video
                if (_shouldAutomaticallyCloseAtEndL) {
                    [weakSelf close];
                }
                
                break;
            }
            case Video_15s: {
                // do nothing
                break;
            }
            case Video_Error: {
                
                // can close video
                weakSelf.isOKToClose = true;
                
                // send errors
                [weakSelf.events triggerVASTErrorEvent];
                
                // close
                [weakSelf close];
                
                // send callback
                if (_callbackL != NULL) {
                    _callbackL(weakSelf.ad.placementId, adFailedToShow);
                } else {
                    NSLog(@"Video Ad callback not implemented. Event would have been adFailedToShow");
                }
                
                break;
            }
        }
    }];
    
    // set click handler for player
    [_player setClickHandler:^{
        
        // get a potential destination
        NSString *destination = [weakSelf.events getVASTClickThroughEvent];
        
        // only go forward if the destination url is not null
        if (destination) {
            if (_isParentalGateEnabledL) {
                
                [SAParentalGate setPgOpenCallback:^{
                    [weakSelf pause];
                    [weakSelf.events triggerPgOpenEvent];
                }];
                [SAParentalGate setPgCanceledCallback:^{
                    [weakSelf resume];
                    [weakSelf.events triggerPgCloseEvent];
                }];
                [SAParentalGate setPgFailedCallback:^{
                    [weakSelf resume];
                    [weakSelf.events triggerPgFailEvent];
                }];
                [SAParentalGate setPgSuccessCallback:^{
                    [weakSelf pause];
                    [weakSelf.events triggerPgSuccessEvent];
                    [weakSelf click:destination];
                }];
                [SAParentalGate play];
                
            } else {
                [weakSelf click: destination];
            }
        }
        
    }];
    
    // add subview
    [self.view addSubview:_player];
    
    // add the padlock
    _padlock = [[UIButton alloc] initWithFrame:CGRectZero];
    [_padlock setImage:[SAImageUtils padlockImage] forState:UIControlStateNormal];
    [_padlock addTarget:self action:@selector(padlockAction) forControlEvents:UIControlEventTouchUpInside];
    if (_shouldShowPadlockL) {
        [self.view addSubview:_padlock];
    }
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeBtn setHidden:!_shouldShowCloseButtonL];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAImageUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
}

/**
 * Overridden UIViewController "didReceiveMemoryWarning" method
 */
- (void)didReceiveMemoryWarning {
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
    
    // set status bar hidden
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
    
    // apply the resize
    [self resize:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    
    // actually start playing the video
    if (_ad.creative.details.media.isDownloaded) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_ad.creative.details.media.path];
        [_player playWithMediaFile:finalDiskURL];
    }
}

/**
 * Overridden UIViewController "viewWillDisappear" method in which I reset the
 * status bar state
 *
 * @param animated whether the view will disappeared animated or not
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
 * Overridden UIViewController "supportedInterfaceOrientations" method in which
 * I set the supported orientations
 *
 * @return valid orientations for this view controller
 */
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
    
    SAOrientation orientationL = [SAVideoAd getOrientation];
    
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
- (BOOL) shouldAutorotate {
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
    if (_isOKToClose) {
        
        // call delegate
        sacallback _callbackL = [SAVideoAd getCallback];
        if (_callbackL != NULL) {
            _callbackL(_ad.placementId, adClosed);
        } else {
            NSLog(@"Video Ad callback not implemented. Event would have been adClosed");
        }
        
        // moat end
        [_events stopMoatTrackingForVideoPlayer];
    
        // close
        [_events unsetAd];
        
        // null the ad
        [ads removeObjectForKey:@(_ad.placementId)];
        
        // destroy the player
        [_player destroy];
        _player = NULL;
        
        // destroy the padlock
        [_padlock removeFromSuperview];
        _padlock = nil;
        
        // close the PG
        [SAParentalGate close];
        
        // dismiss VC
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 * Method that resizes the ad and it's banner SABannerAd object
 *
 * @param frame the new frame to resize to
 */
- (void) resize: (CGRect) frame {
    // get locl vars from static
    BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    if (!_shouldShowCloseButtonL && _videoEnded) _shouldShowCloseButtonL = true;
    
    // setup close button
    _closeBtn.frame = _shouldShowCloseButtonL ? CGRectMake(frame.size.width - 40.0f, 0, 40.0f, 40.0f) : CGRectZero;
    [self.view bringSubviewToFront:_closeBtn];
    
    // rearrange the player frame
    [_player updateToFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    // rearrange the padlock
    _padlock.frame = CGRectMake(0, 0, 67, 25);
}

/**
 * Method that is called when a user clicks / taps on an ad
 */
- (void) click: (NSString*) destination {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    BOOL _isBumperPageEnabledL = [SAVideoAd getIsBumperPageEnabled];
    
    if (_isBumperPageEnabledL || _ad.creative.bumper) {
        [SABumperPage setCallback:^{
            [weakSelf handleUrl:destination];
        }];
        [SABumperPage play];
    } else {
        [self handleUrl:destination];
    }
}

- (void) handleUrl: (NSString*) destination {
    
    NSLog(@"[AA :: INFO] Trying to go to: %@", destination);
    
    //
    // get delegate
    sacallback _callbackL = [SAVideoAd getCallback];
    
    //
    // call delegate
    if (_callbackL != NULL) {
        _callbackL(_ad.placementId, adClicked);
    } else {
        NSLog(@"Video Ad callback not implemented. Event would have been adClicked");
    }
    
    //
    // send all events for vast click tracking
    [_events triggerVASTClickTrackingEvent];
    
    //
    // open browser & goto url
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:destination]];
}

/**
 * Method that pauses the video
 */
- (void) pause {
    [_player pause];
}

/**
 * Method that resumes the video
 */
- (void) resume {
    [_player resume];
}

/**
 * Method called when the user clicks on a padlock
 */
- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
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
        session = [[SASession alloc] init];
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
                    NSLog(@"Video Ad callback not implemented. Event would have been adFailedToLoad");
                }
            }
            else {
                // perform more complex validity check
                BOOL isValid = [response isValid];
                SAAd *first = isValid ? [response.ads objectAtIndex:0] : nil;
                isValid = first != nil && isValid && first.creative.details.media.isDownloaded;
                
                // add to the array queue
                if (isValid) {
                    [ads setObject:first forKey:@(placementId)];
                }
                // remove
                else {
                    [ads removeObjectForKey:@(placementId)];
                }
                
                // callback
                if (callback != NULL) {
                    callback(placementId, isValid ? adLoaded : adEmpty);
                } else {
                    NSLog(@"Video Ad callback not implemented. Event would have been either adLoaded or adEmpty");
                }
                
                if (forceloadcallback != NULL) {
                    forceloadcallback(placementId, isValid ? adLoaded : adEmpty);
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
            NSLog(@"Video Ad callback not implemented. Event would have been adAlreadyLoaded");
        }
    }
}

+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent {
    
    // find out if the ad is loaded
    id adL = [ads objectForKey:@(placementId)];
    
    // try to start the view controller (if there is one ad that's OK)
    if (adL && [adL isKindOfClass:[SAAd class]] && ((SAAd*)adL).creative.format == SA_Video) {
        
        // prepare vc
        SAVideoAd *newVC = [[SAVideoAd alloc] init];
        newVC.ad = (SAAd*)adL;
        
        // remove ad (mark it as played)
        [ads removeObjectForKey:@(placementId)];
        
        // present vc
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        if (callback != NULL) {
            callback(placementId, adFailedToShow);
        } else {
            NSLog(@"Video Ad callback not implemented. Event would have been adFailedToShow");
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
    [self setParentalGate:false];
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

+ (void) enableCloseButton {
    [self setCloseButton:true];
}

+ (void) disableCloseButton {
    [self setCloseButton:false];
}

+ (void) enableSmallClickButton {
    [self setSmallClick:true];
}

+ (void) disableSmallClickButton {
    [self setSmallClick:false];
}

+ (void) enableCloseAtEnd {
    [self setCloseAtEnd:true];
}

+ (void) disableCloseAtEnd {
    [self setCloseAtEnd:false];
}

+ (void) setTestMode: (BOOL) value {
    isTestingEnabled = value;
}

+ (void) setParentalGate: (BOOL) value {
    isParentalGateEnabled = value;
}

+ (void) setBumperPage:(BOOL)value {
    isBumperPageEnabled = value;
}

+ (void) setConfiguration: (NSInteger) value {
    configuration = value;
}

+ (void) setOrientation: (SAOrientation) value {
    orientation = value;
}

+ (void) setCloseButton: (BOOL) value {
    shouldShowCloseButton = value;
}

+ (void) setSmallClick: (BOOL) value {
    shouldShowSmallClickButton = value;
}

+ (void) setCloseAtEnd: (BOOL) value {
    shouldAutomaticallyCloseAtEnd = value;
}

+ (sacallback) getCallback {
    return callback;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
}

+ (BOOL) getIsBumperPageEnabled {
    return isBumperPageEnabled;
}

+ (BOOL) getShouldAutomaticallyCloseAtEnd {
    return shouldAutomaticallyCloseAtEnd;
}

+ (BOOL) getShouldShowCloseButton {
    return shouldShowCloseButton;
}

+ (BOOL) getShouldShowSmallClickButton {
    return shouldShowSmallClickButton;
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
