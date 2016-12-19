//
//  SAEvents.m
//  Pods
//
//  Created by Gabriel Coman on 26/02/2016.
//
//

#import "SAEvents.h"

// guarded imports
#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SANetwork/SANetwork.h>)
#import <SANetwork/SANetwork.h>
#else
#import "SANetwork.h"
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
#if __has_include(<SAUtils/SAExtensions.h>)
#import <SAUtils/SAExtensions.h>
#else
#import "SAExtensions.h"
#endif
#endif

// try to import moat
#if defined(__has_include)
#if __has_include("SAEvents+Moat.h")
#import "SAEvents+Moat.h"
#endif
#endif

#define MAX_DISPLAY_TICKS 1
#define MAX_VIDEO_TICKS 2

@interface SAEvents ()
@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) SANetwork *network;
@property (nonatomic, strong) NSTimer *viewabilityTimer;
@property (nonatomic, assign) BOOL moatLimiting;
@end

@implementation SAEvents

- (id) init {
    if (self = [super init]) {
        _network = [[SANetwork alloc] init];
        _moatLimiting = true;
    }
    
    return self;
}

- (void) setAd:(SAAd *)ad {
    _ad = ad;
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Normal events
////////////////////////////////////////////////////////////////////////////////

- (void) sendEventToURL:(NSString *)url withResponse:(saEventResponse)response {
    [_network sendGET:url
            withQuery:@{}
            andHeader:@{@"Content-Type":@"application/json",
                        @"User-Agent":[SAUtils getUserAgent]}
         withResponse:^(NSInteger status, NSString *payload, BOOL success) {
             if (response != nil) {
                 response(success, status);
             }
         }];
}

- (void) sendEventToURL:(NSString *)url {
    [self sendEventToURL:url withResponse:nil];
}

- (void) sendAllEventsForKey:(NSString*)key withResponse:(saEventResponse)response {
    // safety check
    if (_ad == NULL || key == nil || key == (NSString*)[NSNull null]) {
        if (response != nil) {
            response(false, 0);
        }
        return;
    }
    
    // get the necessary events
    NSArray *tracks = [_ad.creative.events filterBy:@"event" withValue:key];
    NSMutableArray *urls = [@[] mutableCopy];
    for (id track in tracks) {
        NSString *url = [track valueForKey:@"URL"];
        if (url != NULL && ((NSNull*)url != [NSNull null]) && ![url isEqualToString:@""]) {
            [urls addObject:url];
        }
    }
    
    // some vars to keep track of events
    __block NSInteger max = [urls count];
    __block NSInteger successful = 0;
    __block NSInteger current = 0;
    
    // send events
    if (max > 0) {
        for (NSString *url in urls) {
            [self sendEventToURL:url withResponse:^(BOOL success, NSInteger status) {
                // increment
                successful += success ? 1 : 0;
                current += 1;
                
                // once you reach the end
                if (current == max && response != nil) {
                    response (current == successful ? true : false, current == successful ? 200 : 0);
                }
            }];
        }
    } else {
        if (response != nil) {
            response (false, 0);
        }
    }
}

- (void) sendAllEventsForKey:(NSString*)key {
    [self sendAllEventsForKey:key withResponse:nil];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Viewable Impression
////////////////////////////////////////////////////////////////////////////////

- (void) sendViewableImpressionForView:(UIView*) view andTicks:(NSInteger) maxTicks withResponse:(saEventResponse)response {
    
    // safety check
    if (_ad == nil || view == nil) {
        if (response != nil) {
            response (false, 0);
        }
        return;
    }
    
    // destroy previosus timer, if it exists
    if (_viewabilityTimer != NULL) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = NULL;
    }
    
    // start timer
    __block NSInteger ticks = 0;
    __block NSInteger cticks = 0;
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:[NSBlockOperation blockOperationWithBlock:^{
        
        if (ticks >= maxTicks) {
            [_viewabilityTimer invalidate];
            _viewabilityTimer = nil;
            
            // success case
            if (cticks == maxTicks) {
                [self sendAllEventsForKey:@"viewable_impr" withResponse:response];
            }
            // error case
            else {
                if (response != nil) {
                    response (false, 0);
                }
            }
        } else {
            ticks++;
            
            CGRect childR = view.frame;
            CGRect superR = CGRectMake(0, 0, view.superview.frame.size.width, view.superview.frame.size.height);
            CGRect screenR = [UIScreen mainScreen].bounds;
            
            if ([SAUtils isRect:childR inRect:screenR] && [SAUtils isRect:childR inRect:superR]) {
                cticks++;
            }
            
            NSLog(@"[AA :: Info] Tick %ld/%ld - Viewability Count %ld/%ld", (long)ticks, (long)maxTicks, (long)cticks, (long)maxTicks);
        }
        
    }] selector:@selector(main) userInfo:nil repeats:YES];
    
    // fire the timer
    [_viewabilityTimer fire];
    
}

- (void) sendViewableImpressionForDisplay:(UIView*) view {
    [self sendViewableImpressionForView:view andTicks:MAX_DISPLAY_TICKS withResponse:nil];
}

- (void) sendViewableImpressionForVideo:(UIView*) view {
    [self sendViewableImpressionForView:view andTicks:MAX_VIDEO_TICKS withResponse:nil];
}

- (void) close {
    if (_viewabilityTimer != NULL) {
        [_viewabilityTimer invalidate];
    }
    
    _viewabilityTimer = NULL;
    _network = NULL;
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Handle Moat events
////////////////////////////////////////////////////////////////////////////////

- (NSString*) moatEventForWebPlayer:(id)webplayer {
    
    if ((_moatLimiting && [SAUtils randomNumberBetween:0 maxNumber:100] >= 80) || _ad == nil){
        return @"";
    }
    
    // form the moat dictionary
    NSDictionary *moatDict = @{
                               @"advertiser": @(_ad.advertiserId),
                               @"campaign": @(_ad.campaignId),
                               @"line_item": @(_ad.lineItemId),
                               @"creative": @(_ad.creative._id),
                               @"app": @(_ad.app),
                               @"placement": @(_ad.placementId),
                               @"publisher": @(_ad.publisherId)
                               };
    
    // invoke the Moat event
    NSString *moatString = @"";
    SEL selector = NSSelectorFromString(@"sendDisplayMoatEvent:andAdDictionary:");
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        NSString* (*func)(id, SEL, id, NSDictionary*) = (void *)imp;
        moatString = func(self, selector, webplayer, moatDict);
    }
    
        // return the moat-ified string
    return moatString;
}

- (void) moatEventForVideoPlayer:(AVPlayer*)player withLayer:(AVPlayerLayer*)layer andView:(UIView*)view {
    
    if ((_moatLimiting && [SAUtils randomNumberBetween:0 maxNumber:100] >= 80) || _ad == nil) {
        return;
    }
    
    // also get the moat dict, another needed parameter
    NSDictionary *moatDict = @{
                               @"advertiser":@(_ad.advertiserId),
                               @"campaign":@(_ad.campaignId),
                               @"line_item":@(_ad.lineItemId),
                               @"creative":@(_ad.creative._id),
                               @"app":@(_ad.app),
                               @"placement":@(_ad.placementId),
                               @"publisher":@(_ad.publisherId)
                               };
    
    // invoke the moat event
    [SAUtils invoke:@"sendVideoMoatEvent:andLayer:andView:andAdDictionary:" onTarget:self, player, layer, view, moatDict];
    
}

- (void) disableMoatLimiting {
    _moatLimiting = false;
}

@end
