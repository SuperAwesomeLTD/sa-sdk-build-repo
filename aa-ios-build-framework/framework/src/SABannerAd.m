/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SABannerAd.h"

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
#if __has_include(<SAWebPlayer/SAWebPlayer.h>)
#import <SAWebPlayer/SAWebPlayer.h>
#else
#import "SAWebPlayer.h"
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

// local imports
#import "SuperAwesome.h"
#import "SAVersion.h"

@interface SABannerAd ()

// main state vars
@property (nonatomic, strong) sacallback         callback;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;
@property (nonatomic, assign) IBInspectable BOOL isBumperPageEnabled;

// events
@property (nonatomic, strong) SASession          *session;
@property (nonatomic, strong) SAEvents           *events;

// current ad
@property (nonatomic, strong) SAAd               *ad;

// subviews
@property (nonatomic, strong) SAWebPlayer        *webplayer;
@property (nonatomic, strong) UIButton           *padlock;

// aux state vats
@property (nonatomic, assign) BOOL               canPlay;
@property (nonatomic, assign) BOOL               firstPlay;
@property (nonatomic, assign) BOOL               isClosed;
@property (nonatomic, assign) BOOL               moatLimiting;

@end

@implementation SABannerAd

/**
 * Custom init for code-based initialization
 *
 * @return a new instance of SABannerAd
 */
- (id) init {
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

/**
 * Custom init for XIB base initialization
 *
 * @return a new instance of SABannerAd
 */
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

/**
 * Custom init for code-based initialization with a frame
 *
 * @return a new instance of SABannerAd
 */
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

/**
 * Method that actually inits the banner, creates new obejcts and sets the
 * default values.
 */
- (void) initialize {
    // set "canPlay" to true when building the first banner
    _canPlay = true;
    _firstPlay = true;
    _isClosed = false;
    _moatLimiting = true;
    
    // init the events and session obkects
    _events = [[SAEvents alloc] init];
    _session = [[SASession alloc] init];
    
    // set a default callback, so that it's never null and I don't have to
    // do a null check everytime I want to call it
    _callback = ^(NSInteger placement, SAEvent event) {};
    
    // set default banner parameters
    [self setParentalGate:SA_DEFAULT_PARENTALGATE];
    [self setBumperPage:SA_DEFAULT_BUMPERPAGE];
    [self setTestMode:SA_DEFAULT_TESTMODE];
    [self setConfiguration:SA_DEFAULT_CONFIGURATION];
    [self setColor:SA_DEFAULT_BGCOLOR];
}

- (void) load:(NSInteger)placementId {
    
    // first close any existing ad
    if (!_firstPlay) {
        [self close];
    }
    
    // reset playability
    _canPlay = false;
    _isClosed = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // change session
    [_session setVersion:[SAVersion getSdkVersion]];
    
    // load ad
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:placementId withSession:_session andResult:^(SAResponse *response) {

        if (response.status != 200) {
            weakSelf.callback(placementId, adFailedToLoad);
        } else {
            // set can play
            weakSelf.canPlay = [response isValid];
            
            // assign new ad
            weakSelf.ad = [response isValid] ? [response.ads objectAtIndex:0] : nil;
            
            // call the callback
            if (weakSelf.callback != NULL) {
                weakSelf.callback (placementId, [response isValid] ? adLoaded : adEmpty);
            } else {
                NSLog(@"Banner Ad callback not implemented. Should have been either adLoaded or adEmpty");
            }
        }
    }];
}

- (void) play {
    
    if (_ad && _ad.creative.format != SA_Video && _canPlay && !_isClosed) {
        
        // reset play-ability
        _canPlay = false;
        _firstPlay = false;
        
        // get a weak self reference
        __weak typeof (self) weakSelf = self;
        
        // start events
        [_events setAd:_ad andSession:_session];
        if (!_moatLimiting) {
            [_events disableMoatLimiting];
        }
        
        // add the sawebview
        _webplayer = [[SAWebPlayer alloc] initWithContentSize:CGSizeMake(_ad.creative.details.width, _ad.creative.details.height)
                                               andParentFrame:self.frame];
        
        // moat tracking
        NSString *moatString = [_events startMoatTrackingForDisplay:[_webplayer getWebView]];
        NSLog(@"MOAT String is %@", moatString);
        
        // form the full HTML string and play it!
        NSString *fullHTMLToLoad = [_ad.creative.details.media.html stringByReplacingOccurrencesOfString:@"_MOAT_" withString:moatString];
        
        // add callbacks for web player events
        [_webplayer setEventHandler:^(SAWebPlayerEvent event) {
            switch (event) {
                case saWeb_Start: {
                    // send callback
                    weakSelf.callback(weakSelf.ad.placementId, adShown);
                    
                    // send viewable impression
                    [weakSelf.events checkViewableStatusForDisplay:weakSelf andResponse:^(BOOL success) {
                        
                        // only in case of success trigger event
                        if (success) {
                            [weakSelf.events triggerViewableImpressionEvent];
                        }
                    }];
                    
                    break;
                }
                case saWeb_Error: {
                    // send callback
                    if (weakSelf.callback != NULL) {
                        weakSelf.callback(weakSelf.ad.placementId, adFailedToShow);
                    } else {
                        NSLog(@"Banner Ad callback not implemented. Should have been adFailedToShow");
                    }
                    break;
                }
            }
        }];
        
        // add callbacks for clicks
        [_webplayer setClickHandler:^(NSURL *url) {
            
            // only call the next part (either pg or click) if the click
            // url is valid, else do nothong
            if (url && [url absoluteString]) {
                if (weakSelf.isParentalGateEnabled) {
                    
                    [SAParentalGate setPgOpenCallback:^{
                        [weakSelf.events triggerPgOpenEvent];
                    }];
                    [SAParentalGate setPgCanceledCallback:^{
                        [weakSelf.events triggerPgCloseEvent];
                    }];
                    [SAParentalGate setPgFailedCallback:^{
                        [weakSelf.events triggerPgFailEvent];
                    }];
                    [SAParentalGate setPgSuccessCallback:^{
                        [weakSelf.events triggerPgSuccessEvent];
                        [weakSelf click:[url absoluteString]];
                    }];
                    [SAParentalGate play];
                } else {
                    [weakSelf click: [url absoluteString]];
                }
            }
        
        }];
        
        // add the webplayer as a subview
        [self addSubview:_webplayer];
        
        // add the padlock
        _padlock = [[UIButton alloc] initWithFrame:CGRectZero];
        [_padlock setImage:[SAImageUtils padlockImage] forState:UIControlStateNormal];
        [_padlock addTarget:self action:@selector(padlockAction) forControlEvents:UIControlEventTouchUpInside];
        if (_ad.isPadlockVisible) {
            [_webplayer addSubview:_padlock];
        }
        
        // resize
        [self resize:self.frame];
        
        // finally play!
        [_webplayer loadHTML:fullHTMLToLoad witBase:_ad.creative.details.base];
        
        // add a notification of sorts
        [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:
         ^(NSNotification * note) {
             
             // resize
             [weakSelf resize:weakSelf.frame];
         }];
        
    } else {
        // failure callback
        if (_callback != NULL) {
            _callback (0, adFailedToShow);
        } else {
            NSLog(@"Banner Ad callback not implemented. Event would have been adFailedToShow");
        }
    }
}

- (void) setAd:(SAAd*) ad {
    _ad = ad;
}

/**
 * Internal method that nulls the ad
 */
- (void) nullAd {
    _ad = NULL;
}

- (BOOL) hasAdAvailable {
    return _ad != NULL;
}

- (SAAd*) getAd {
    return _ad;
}

- (void) close {
    // callback
    if (_callback != NULL) {
        _callback (_ad.placementId, adClosed);
    } else {
        NSLog(@"Banner Ad callback not implemented. Event would have been adClosed");
    }
    
    // stop moat
    [_events stopMoatTrackingForDisplay];
    
    // close events
    [_events unsetAd];
    
    // remove all stuffs
    [_webplayer removeFromSuperview];
    _webplayer = nil;
    [_padlock removeFromSuperview];
    _padlock = nil;
    [self nullAd];
    
    // can play
    _isClosed = true;
    
    // remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification"
                                                  object:nil];
}

/**
 * Method that is called when a user clicks / taps on an ad
 */
- (void) click: (NSString*) destination {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    if (_isBumperPageEnabled || _ad.creative.bumper) {
        [SABumperPage setCallback:^{
            [weakSelf handleUrl:destination];
        }];
        [SABumperPage play];
    }
    else {
        [self handleUrl:destination];
    }
}

- (void) handleUrl: (NSString*) destination {
    //
    // log this
    NSLog(@"[AA :: INFO] Trying to go to: %@", destination);
    
    //
    // send callback
    if (_callback != NULL) {
        _callback (_ad.placementId, adClicked);
    } else {
        NSLog(@"Banner Ad callback not implemented. Event would have been adClicked");
    }
    
    //
    // trigger click evt
    if (_session && [destination rangeOfString:[_session getBaseUrl]].location == NSNotFound) {
        [_events triggerClickEvent];
    }
    
    //
    // open browser & goto url
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:destination]];
    
}

- (void) resize:(CGRect)toframe {
    
    // new frame
    self.frame = toframe;
    
    // rearrange the webview
    [_webplayer updateParentFrame:toframe];
    
    CGRect contentRect = CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height);
    CGRect result = [_webplayer map:contentRect into:toframe];
    CGFloat scaleX = result.size.width / _ad.creative.details.width;
    CGFloat scaleY = result.size.height / _ad.creative.details.height;
    
    // rearrange the padlock
    CGFloat x = (toframe.size.width - _ad.creative.details.width * scaleX) / 2;
    CGFloat y = (toframe.size.height - _ad.creative.details.height * scaleY) / 2;
    
    _padlock.frame = CGRectMake(x, y, 67, 25);
    [self bringSubviewToFront:_padlock];
}

/**
 * Method called when the user clicks on a padlock
 */
- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
}

- (BOOL) isClosed {
    return _isClosed;
}

- (void) setCallback:(sacallback)callback {
    _callback = callback ? callback : _callback;
}

- (void) enableParentalGate {
    [self setParentalGate:true];
}

- (void) disableParentalGate {
    [self setParentalGate:false];
}

- (void) enableBumperPage {
    [self setBumperPage:true];
}

- (void) disableBumperPage {
    [self setBumperPage:false];
}

- (void) enableTestMode {
    [self setTestMode:true];
}

- (void) disableTestMode {
    [self setTestMode:false];
}

- (void) setConfigurationProduction {
    [self setConfiguration:PRODUCTION];
}

- (void) setConfigurationStaging {
    [self setConfiguration:STAGING];
}

- (void) setColorTransparent {
    [self setColor:true];
}

- (void) setColorGray {
    [self setColor:false];
}

- (void) setTestMode: (BOOL) value {
    [_session setTestMode:value];
}

- (void) setParentalGate: (BOOL) value {
    _isParentalGateEnabled = value;
}

- (void) setBumperPage: (BOOL) value {
    _isBumperPageEnabled = value;
}

- (void) setConfiguration: (NSInteger) value {
    [_session setConfiguration:value];
}

- (void) setColor: (BOOL) value {
    if (value) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
    }
}

- (void) disableMoatLimiting {
    _moatLimiting = false;
}


@end
