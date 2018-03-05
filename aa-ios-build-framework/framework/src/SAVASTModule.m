/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */


#import "SAVASTModule.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAVASTAd.h"
#import "SAVASTEvent.h"
#import "SAURLEvent.h"

@implementation SAVASTModule

- (id) initWithAd: (SAAd*) ad {
    
    if (self = [super init]) {
        
        _vastError = [@[] mutableCopy];
        _vastImpression = [@[] mutableCopy];
        _vastCreativeView = [@[] mutableCopy];
        _vastStart = [@[] mutableCopy];
        _vastFirstQuartile = [@[] mutableCopy];
        _vastMidpoint = [@[] mutableCopy];
        _vastThirdQuartile = [@[] mutableCopy];
        _vastComplete = [@[] mutableCopy];
        _vastClickTracking = [@[] mutableCopy];
        
        for (SAVASTEvent *event in ad.creative.details.media.vastAd.events) {
            
            if ([event.event rangeOfString:@"vast_click_through"].location != NSNotFound) {
                _vastClickThrough = [[SAURLEvent alloc] initWithUrl:event.URL];
            }
            
            if ([event.event rangeOfString:@"vast_error"].location != NSNotFound) {
                [_vastError addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_impression"].location != NSNotFound) {
                [_vastImpression addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_creativeView"].location != NSNotFound) {
                [_vastCreativeView addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_start"].location != NSNotFound) {
                [_vastStart addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_firstQuartile"].location != NSNotFound) {
                [_vastFirstQuartile addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_midpoint"].location != NSNotFound) {
                [_vastMidpoint addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_thirdQuartile"].location != NSNotFound) {
                [_vastThirdQuartile addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_complete"].location != NSNotFound) {
                [_vastComplete addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            if ([event.event rangeOfString:@"vast_click_tracking"].location != NSNotFound) {
                [_vastClickTracking addObject:[[SAURLEvent alloc] initWithUrl:event.URL]];
            }
            
        }
    }
    
    return self;
    
}

- (NSString*) getVASTClickThroughEvent {
    return _vastClickThrough ? [_vastClickThrough getUrl] : @"";
}


- (void) triggerVASTClickThroughEvent {
    if (_vastClickThrough) {
        [_vastClickThrough triggerEvent];
    }
}

- (void) triggerVASTErrorEvent {
    for (SAURLEvent *event in _vastError) {
        [event triggerEvent];
    }
}

- (void) triggerVASTImpressionEvent {
    for (SAURLEvent *event in _vastImpression) {
        [event triggerEvent];
    }
}

- (void) triggerVASTCreativeViewEvent {
    for (SAURLEvent *event in _vastCreativeView) {
        [event triggerEvent];
    }
}

- (void) triggerVASTStartEvent {
    for (SAURLEvent *event in _vastStart) {
        [event triggerEvent];
    }
}

- (void) triggerVASTFirstQuartileEvent {
    for (SAURLEvent *event in _vastFirstQuartile) {
        [event triggerEvent];
    }
}

- (void) triggerVASTMidpointEvent {
    for (SAURLEvent *event in _vastMidpoint) {
        [event triggerEvent];
    }
}

- (void) triggerVASTThirdQuartileEvent {
    for (SAURLEvent *event in _vastThirdQuartile) {
        [event triggerEvent];
    }
}

- (void) triggerVASTCompleteEvent {
    for (SAURLEvent *event in _vastComplete) {
        [event triggerEvent];
    }
}

- (void) triggerVASTClickTrackingEvent {
    for (SAURLEvent *event in _vastClickTracking) {
        [event triggerEvent];
    }
}

@end
