//
//  SABannerAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SABannerAd.h"

// guarded imports
#if defined(__has_include)
#if __has_include(<SAModelSpace/SAModelSpace.h>)
#import <SAModelSpace/SAModelSpace.h>
#else
#import "SAModelSpace.h"
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
#if __has_include(<SAAdLoader/SAAdLoader.h>)
#import <SAAdLoader/SAAdLoader.h>
#else
#import "SAAdLoader.h"
#endif
#endif

// local imports
#import "SuperAwesome.h"
#import "SAParentalGate.h"

@interface SABannerAd ()

// main state vars
@property (nonatomic, strong) sacallback callback;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

// events
@property (nonatomic, strong) SASession *session;
@property (nonatomic, strong) SAEvents *events;

// current ad
@property (nonatomic, strong) SAAd *ad;

// subviews
@property (nonatomic, strong) SAWebPlayer *webplayer;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIButton *padlock;

// aux state vats
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, assign) BOOL canPlay;

@end

@implementation SABannerAd

////////////////////////////////////////////////////////////////////////////////
// MARK: View lifecycle
////////////////////////////////////////////////////////////////////////////////

- (id) init {
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void) initialize {
    _canPlay = true;
    _isParentalGateEnabled = true;
    _events = [[SAEvents alloc] init];
    _session = [[SASession alloc] init];
    _callback = ^(NSInteger placement, SAEvent event) {};
    self.backgroundColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
}

- (void) loadSubviews {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // start events
    [_events setAd:_ad];
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self andAd:_ad];
    
    // add the sawebview
    _webplayer = [[SAWebPlayer alloc] initWithFrame:CGRectZero];
    
    // setup the ad size
    [_webplayer setAdSize:CGSizeMake(_ad.creative.details.width, _ad.creative.details.height)];
    
    // moat tracking
    NSString *moatString = [_events moatEventForWebPlayer:_webplayer];
    NSLog(@"%@", moatString);
    
    // form the full HTML string and play it!
    NSString *fullHTMLToLoad = [_ad.creative.details.media.html stringByReplacingOccurrencesOfString:@"_MOAT_" withString:moatString];
    
    // add callbacks for web player events
    [_webplayer setEventHandler:^(SAWebPlayerEvent event) {
        switch (event) {
            case Web_Start: {
                // send callback
                weakSelf.callback(weakSelf.ad.placementId, adShown);
                
                // if the banner has a separate impression URL, send that as well for 3rd party tracking
                [weakSelf.events sendAllEventsForKey:@"impression"];
                // [weakSelf.events sendAllEventsForKey:@"sa_impr"];
                
                // send viewable impression
                [weakSelf.events sendViewableImpressionForDisplay:weakSelf];
                
                break;
            }
            case Web_Error: {
                // send callback
                weakSelf.callback(weakSelf.ad.placementId, adFailedToShow);
                break;
            }
        }
    }];
    
    // add callbacks for clicks
    [_webplayer setClickHandler:^(NSURL *url) {
        // get the going to URL
        weakSelf.destinationURL = [url absoluteString];
        
        if (weakSelf.isParentalGateEnabled) {
            [weakSelf.gate show];
        } else {
            [weakSelf click];
        }
    }];
    
    // add the webplayer as a subview
    [self addSubview:_webplayer];
    
    // add the padlock
    _padlock = [[UIButton alloc] initWithFrame:CGRectZero];
    [_padlock setImage:[SAImageUtils padlockImage] forState:UIControlStateNormal];
    [_padlock addTarget:self action:@selector(padlockAction) forControlEvents:UIControlEventTouchUpInside];
    if ([self shouldShowPadlock]) {
        [_webplayer addSubview:_padlock];
    }
    
    // resize
    [self resize:self.frame];
    
    // finally play!
    [_webplayer loadAdHTML:fullHTMLToLoad];
    
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Class public interface
////////////////////////////////////////////////////////////////////////////////

- (void) load:(NSInteger)placementId {
    
    // reset playability
    _canPlay = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // change session
    [_session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
    
    // load ad
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:placementId withSession:_session andResult:^(SAResponse *response) {

        // set can play
        weakSelf.canPlay = [response isValid];

        // assign new ad
        weakSelf.ad = [response isValid] ? [response.ads objectAtIndex:0] : nil;
        
        
        NSLog(@"%@", [response jsonPreetyStringRepresentation]);
        
        // call the callback
        weakSelf.callback (placementId, [response isValid] ? adLoaded : adFailedToLoad);
    }];
}

- (void) play {
    
    if (_ad && _ad.creative.creativeFormat != video && _canPlay) {
        
        // reset play-ability
        _canPlay = false;
        
        // load subviews
        [self loadSubviews];
        
    } else {
        // failure callback
        _callback (0, adFailedToShow);
    }
}

- (void) setAd:(SAAd *)ad {
    _ad = ad;
}

- (void) nullAd {
    _ad = NULL;
}

- (BOOL) hasAdAvailable {
    return _ad != NULL;
}

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
}

- (void) close {
    // callback
    _callback (_ad.placementId, adClosed);
    
    // close events
    [_events close];
    
    // remove all stuffs
    [_webplayer removeFromSuperview];
    _webplayer = nil;
    [_padlock removeFromSuperview];
    _padlock = nil;
    _gate = nil;
    [self nullAd];
}

- (void) click {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
    // callback
    _callback (_ad.placementId, adClicked);
    
    // events
    if ([_destinationURL rangeOfString:[_session getBaseUrl]].location == NSNotFound) {
        [_events sendAllEventsForKey:@"sa_tracking"];
    }
    
    // send the install e vent (if this is a CPI campaign)
    [_events sendAllEventsForKey:@"install"];
    
    // open URL
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resize:(CGRect)toframe {
    
    // new frame
    self.frame = toframe;
    
    // new webplayer frame
    CGRect frame = [SAAux mapOldFrame:CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height)
                             toNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    // rearrange the webview
    [_webplayer updateToFrame:frame];
    
    // rearrange the padlock
    _padlock.frame = CGRectMake(0, 0, 67, 25);
    [self bringSubviewToFront:_padlock];
}

- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Setters & getters
////////////////////////////////////////////////////////////////////////////////

- (void) setCallback:(sacallback)callback {
    _callback = callback ? callback : _callback;
}

- (void) enableParentalGate {
    [self setParentalGate:true];
}

- (void) disableParentalGate {
    [self setParentalGate:false];
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

// generic method

- (void) setTestMode: (BOOL) value {
    [_session setTestMode:value];
}

- (void) setParentalGate: (BOOL) value {
    _isParentalGateEnabled = value;
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


@end
