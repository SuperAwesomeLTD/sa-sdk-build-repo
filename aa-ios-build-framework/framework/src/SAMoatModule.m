/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAMoatModule.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SAUtils.h"

#if defined(__has_include)
#if __has_include("SAEvents+Moat.h")
#import "SAEvents+Moat.h"
#endif
#endif

@interface SAMoatModule ()
@property (nonatomic, assign) BOOL moatLimiting;
@property (nonatomic, strong) SAAd *ad;
@end

@implementation SAMoatModule

- (id) initWithAd:(SAAd *)ad {
    if (self = [super init]) {
        
        // init with true
        _moatLimiting = true;
        
        // get the ad
        _ad = ad;
        
        // init MOAT, if available
        SEL selector = NSSelectorFromString(@"initMoat");
        if ([self respondsToSelector:selector]) {
            
            // init moat
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL) = (void*)imp;
            func(self, selector);
        }
    }
    
    return self;
}

/**
 * Method that determines is Moat can be triggered at this point
 *
 * @return true or false
 */
- (BOOL) isMoatAllowed {
    NSInteger moatRandInt = [SAUtils randomNumberBetween:0 maxNumber:100];
    CGFloat moatRand = (CGFloat) (moatRandInt / 100.0f);
    return _ad != nil && ((moatRand < _ad.moat && _moatLimiting) || !_moatLimiting);
}

/**
 * Method that registers a Moat event object,
 * according to the moat specifications
 *
 * @param webplayer the web view used by Moat to register events on
 *                  (and that will contain an ad at runtime)
 * @return          returns a MOAT specific string that will need to be
 *                  inserted in the web view so that the JS moat stuff works
 */
- (NSString*) startMoatTrackingForDisplay:(id)webplayer {
    
    // ad data dictionary
    NSDictionary *moatDict = @{
                               @"advertiser": @(_ad.advertiserId),
                               @"campaign": @(_ad.campaignId),
                               @"line_item": @(_ad.lineItemId),
                               @"creative": @(_ad.creative._id),
                               @"app": @(_ad.appId),
                               @"placement": @(_ad.placementId),
                               @"publisher": @(_ad.publisherId)
                               };
    
    // response variable
    NSString *moatString = @"";
    
    // selector
    SEL selector = NSSelectorFromString(@"internalStartMoatTrackingForDisplay:andAdDictionary:");
    
    // perform selector, if available
    if ([self respondsToSelector:selector] && [self isMoatAllowed]) {
        IMP imp = [self methodForSelector:selector];
        NSString* (*func)(id, SEL, id, NSDictionary*) = (void *)imp;
        moatString = func(self, selector, webplayer, moatDict);
    }
    
    // return
    return moatString;
}

- (BOOL) stopMoatTrackingForDisplay {
    
    // response variable
    BOOL moatResponse = false;
    
    // selector
    SEL selector = NSSelectorFromString(@"internalStopMoatTrackingForDisplay");
    
    // perform selector, if available
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        BOOL (*func)(id, SEL) = (void*) imp;
        moatResponse = func(self, selector);
    }
    
    // return
    return moatResponse;
}

/**
 * Method that registers a Video Moat event
 *
 * @param player    the current AVPlayer needed by Moat to do video tracking
 * @param layer     the current Player layer associated with the video view
 * @return          whether the video moat event started OK
 */
- (BOOL) startMoatTrackingForVideoPlayer:(AVPlayer*) player
                               withLayer:(AVPlayerLayer*) layer
                                 andView:(UIView*) view {
    
    // ad data dictionary
    NSDictionary *moatDict = @{
                               @"advertiser":@(_ad.advertiserId),
                               @"campaign":@(_ad.campaignId),
                               @"line_item":@(_ad.lineItemId),
                               @"creative":@(_ad.creative._id),
                               @"app":@(_ad.appId),
                               @"placement":@(_ad.placementId),
                               @"publisher":@(_ad.publisherId)
                               };
    
    // response variable
    BOOL moatResponse = false;
    
    // selector
    SEL selector = NSSelectorFromString(@"internalStartMoatTrackingForVideoPlayer:withLayer:andView:andAdDictionary:");
    
    // perform selector, if available
    if ([self respondsToSelector:selector] && [self isMoatAllowed]) {
        IMP imp = [self methodForSelector:selector];
        BOOL (*func)(id, SEL, AVPlayer*, AVPlayerLayer*, UIView*, NSDictionary*) = (void *)imp;
        moatResponse = func(self, selector, player, layer, view, moatDict);
    }
    
    // return
    return moatResponse;
}

- (BOOL) stopMoatTrackingForVideoPlayer {
    
    // response variable
    BOOL moatResponse = false;
    
    // selector
    SEL selector = NSSelectorFromString(@"internalStopMoatTrackingForVideoPlayer");
    
    // perform selector, if available
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        BOOL (*func)(id, SEL) = (void*) imp;
        moatResponse = func(self, selector);
    }
    
    // return
    return moatResponse;
    
}

/**
 * Method by which Moat can be fully enforced by disabling
 * any limiting applied to it
 */
- (void) disableMoatLimiting {
    _moatLimiting = false;
}

@end
