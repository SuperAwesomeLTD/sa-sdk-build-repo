//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 01/09/2016.
//
//

#import "SAVideoAd.h"

// local imports
#import "SAParentalGate.h"
#import "SuperAwesome.h"

// guarded imports
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
#if __has_include(<SAModelSpace/SATracking.h>)
#import <SAModelSpace/SATracking.h>
#else
#import "SATracking.h"
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


@interface SAVideoAd ()

// aux
@property (nonatomic, assign) BOOL isOKToClose;
@property (nonatomic, strong) NSString *destinationURL;

// views
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIButton *padlock;
@property (nonatomic, strong) SAVideoPlayer *player;

// events
@property (nonatomic, strong) SAEvents *events;

// the ad
@property (nonatomic, strong) SAAd *ad;

// hold the prev status bar hidden or not
@property (nonatomic, assign) BOOL previousStatusBarHiddenValue;

@end

@implementation SAVideoAd

// dictionary of ads
static NSMutableDictionary *ads;

// other static vars needed for state 
static sacallback callback = ^(NSInteger placementId, SAEvent event) {};
static BOOL isParentalGateEnabled = true;
static BOOL shouldAutomaticallyCloseAtEnd = true;
static BOOL shouldShowCloseButton = true;
static BOOL shouldShowSmallClickButton = false;
static BOOL isTestingEnabled = false;
static SAOrientation orientation = ANY;
static SAConfiguration configuration = PRODUCTION;

////////////////////////////////////////////////////////////////////////////////
// MARK: VC lifecycle
////////////////////////////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // get the status bar value
    _previousStatusBarHiddenValue = [[UIApplication sharedApplication] isStatusBarHidden];
    
    // get main static vars into local ones
    __block sacallback _callbackL = [SAVideoAd getCallback];
    __block BOOL _isParentalGateEnabledL = [SAVideoAd getIsParentalGateEnabled];
    __block BOOL _shouldAutomaticallyCloseAtEndL = [SAVideoAd getShouldAutomaticallyCloseAtEnd];
    __block BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    __block BOOL _shouldShowSmallClickButtonL = [SAVideoAd getShouldShowSmallClickButton];
    __block BOOL _shouldShowPadlockL = [self shouldShowPadlock];
    
    // start events
    _events = [[SAEvents alloc] init];
    [_events setAd:_ad];
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self andAd:_ad];
    
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
                [weakSelf.events sendAllEventsForKey:@"impression"];
                [weakSelf.events sendAllEventsForKey:@"start"];
                [weakSelf.events sendAllEventsForKey:@"creativeView"];
                
                // send viewable impression
                [weakSelf.events sendViewableImpressionForVideo:weakSelf.player];
                
                // moat
                [weakSelf.events moatEventForVideoPlayer:[weakSelf.player getPlayer]
                                               withLayer:[weakSelf.player getPlayerLayer]
                                                 andView:[weakSelf view]];
                
                // callback
                _callbackL(weakSelf.ad.placementId, adShown);
                
                break;
            }
            case Video_1_4: {
                [weakSelf.events sendAllEventsForKey:@"firstQuartile"];
                break;
            }
            case Video_1_2: {
                [weakSelf.events sendAllEventsForKey:@"midpoint"];
                break;
            }
            case Video_3_4: {
                [weakSelf.events sendAllEventsForKey:@"thirdQuartile"];
                break;
            }
            case Video_End: {
                
                // close the Pg
                [weakSelf.gate close];
                
                // send complete events
                [weakSelf.events sendAllEventsForKey:@"complete"];
                
                // close video
                if (_shouldAutomaticallyCloseAtEndL) {
                    [weakSelf close];
                }
                
                break;
            }
            case Video_Error: {
                
                // send errors
                [weakSelf.events sendAllEventsForKey:@"error"];
                
                // close
                [weakSelf close];
                
                // send callback
                _callbackL(weakSelf.ad.placementId, adFailedToShow);
                
                break;
            }
        }
    }];
    
    // set click handler for player
    [_player setClickHandler:^{
        
        if (_isParentalGateEnabledL) {
            [weakSelf.gate show];
        } else {
            [weakSelf click];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
    if (_ad.creative.details.media.isOnDisk) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_ad.creative.details.media.playableDiskUrl];
        [_player playWithMediaFile:finalDiskURL];
    } else {
        NSURL *url = [NSURL URLWithString:_ad.creative.details.media.playableMediaUrl];
        [_player playWithMediaURL:url];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHiddenValue
                                            withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self resize:CGRectMake(0, 0, size.width, size.height)];
}

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

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    SAOrientation orientationL = [SAVideoAd getOrientation];
    switch (orientationL) {
        case ANY: return UIInterfaceOrientationMaskAll;
        case PORTRAIT: return UIInterfaceOrientationMaskPortrait;
        case LANDSCAPE: return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return true;
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Aux Instance method
////////////////////////////////////////////////////////////////////////////////

- (void) close {
    if (_isOKToClose) {
        
        // call delegate
        sacallback _callbackL = [SAVideoAd getCallback];
        _callbackL(_ad.placementId, adClosed);
        
        // close
        [_events close];
        
        // null the ad
        // @warn: static
        [SAVideoAd removeAdFromLoadedAds:_ad];
        
        // destroy the player
        [_player destroy];
        _player = NULL;
        
        // destroy the padlock
        [_padlock removeFromSuperview];
        _padlock = nil;
        
        // destroy the gate
        _gate = nil;
        
        // dismiss VC
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) resize: (CGRect) frame {
    // get locl vars from static
    BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    
    // setup close button
    _closeBtn.frame = _shouldShowCloseButtonL ? CGRectMake(frame.size.width - 40.0f, 0, 40.0f, 40.0f) : CGRectZero;
    [self.view bringSubviewToFront:_closeBtn];
    
    // rearrange the player frame
    [_player updateToFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    // rearrange the padlock
    _padlock.frame = CGRectMake(0, 0, 67, 25);
}

- (void) click {
    // get delegate
    sacallback _callbackL = [SAVideoAd getCallback];
    
    // call delegate
    _callbackL(_ad.placementId, adClicked);
    
    // call trackers
    [_events sendAllEventsForKey:@"click_tracking"];
    [_events sendAllEventsForKey:@"custom_clicks"];
    [_events sendAllEventsForKey:@"install"];
    
    // setup the current click URL
    for (SATracking *tracking in _ad.creative.events) {
        if ([tracking.event rangeOfString:@"click_through"].location != NSNotFound) {
            _destinationURL = tracking.URL;
        }
    }
    
    // go to URL
    if (_destinationURL) {
        NSURL *url = [NSURL URLWithString:_destinationURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
}

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
}

- (void) pause {
    [_player pause];
}

- (void) resume {
    [_player resume];
}

- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Class public interface
////////////////////////////////////////////////////////////////////////////////

+ (void) load:(NSInteger) placementId {
    
    // create dictionary
    if (ads == NULL) {
        ads = [@{} mutableCopy];
    }
    
    // if  there's no object around
    if ([ads objectForKey:@(placementId)] == NULL) {
        
        // set a placeholder
        [ads setObject:@(true) forKey:@(placementId)];
        
        // form a new session
        SASession *session = [[SASession alloc] init];
        [session setTestMode:isTestingEnabled];
        [session setConfiguration:configuration];
        [session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
        
        // get the loader
        SALoader *loader = [[SALoader alloc] init];
        [loader loadAd:placementId withSession:session andResult:^(SAResponse *response) {
            
            // perform more complex validity check
            BOOL isValid = [response isValid];
            SAAd *first = isValid ? [response.ads objectAtIndex:0] : nil;
            isValid = first != nil && isValid && first.creative.details.media.isOnDisk;
            
            // add to the array queue
            if (isValid) {
                NSLog(@"%@", [first jsonPreetyStringRepresentation]);
                [ads setObject:first forKey:@(placementId)];
            }
            // remove
            else {
                [ads removeObjectForKey:@(placementId)];
            }
            
            // callback
            callback(placementId, isValid ? adLoaded : adFailedToLoad);
        }];
        
    } else {
        callback (placementId, adFailedToLoad);
    }
}

+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent {
    
    // find out if the ad is loaded
    SAAd *adL = [ads objectForKey:@(placementId)];
    
    // try to start the view controller (if there is one ad that's OK)
    if (adL && adL.creative.creativeFormat == video) {
        
        SAVideoAd *newVC = [[SAVideoAd alloc] init];
        newVC.ad = adL;
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        callback(placementId, adFailedToShow);
    }
}

+ (BOOL) hasAdAvailable: (NSInteger) placementId {
    id object = [ads objectForKey:@(placementId)];
    return object != NULL && [object isKindOfClass:[SAAd class]];
}

+ (void) removeAdFromLoadedAds:(SAAd*)ad {
    [ads removeObjectForKey:@(ad.placementId)];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Setters & getters
// Some are exposed externally (mainly setters) but some are only internally
// Main role for them is to handle working with static variables inside this
// module.
////////////////////////////////////////////////////////////////////////////////

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

// generic methods

+ (void) setTestMode: (BOOL) value {
    isTestingEnabled = value;
}

+ (void) setParentalGate: (BOOL) value {
    isParentalGateEnabled = value;
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

// private static getters

+ (sacallback) getCallback {
    return callback;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
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

@end
