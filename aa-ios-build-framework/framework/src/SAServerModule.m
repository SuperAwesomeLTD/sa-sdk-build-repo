/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */


#import "SAServerModule.h"
#import "SAAd.h"
#import "SASession.h"
#import "SAClickEvent.h"
#import "SAImpressionEvent.h"
#import "SAViewableImpressionEvent.h"
#import "SAPGOpenEvent.h"
#import "SAPGFailEvent.h"
#import "SAPGCloseEvent.h"
#import "SAPGSuccessEvent.h"

@interface SAServerModule ()
@end

@implementation SAServerModule

- (id) initWithAd: (SAAd*) ad
       andSession: (SASession*) session {
    
    if (self = [super init]) {
        
        _clickEvent = [[SAClickEvent alloc] initWithAd:ad andSession:session];
        _impressionEvent = [[SAImpressionEvent alloc] initWithAd:ad andSession:session];
        _viewableImpressionEvent = [[SAViewableImpressionEvent alloc] initWithAd:ad andSession:session];
        _pgOpenEvent = [[SAPGOpenEvent alloc] initWithAd:ad andSession:session];
        _pgFailEvent = [[SAPGFailEvent alloc] initWithAd:ad andSession:session];
        _pgCloseEvent = [[SAPGCloseEvent alloc] initWithAd:ad andSession:session];
        _pgSuccessEvent = [[SAPGSuccessEvent alloc] initWithAd:ad andSession:session];
    }
    
    return self;
}

- (void) triggerClickEvent {
    if (_clickEvent) {
        [_clickEvent triggerEvent];
    }
}

- (void) triggerImpressionEvent {
    if (_impressionEvent) {
        [_impressionEvent triggerEvent];
    }
}

- (void) triggeViewableImpressionEvent {
    if (_viewableImpressionEvent) {
        [_viewableImpressionEvent triggerEvent];
    }
}

- (void) triggerPgOpenEvent {
    if (_pgOpenEvent) {
        [_pgOpenEvent triggerEvent];
    }
}

- (void) triggerPgFailEvent {
    if (_pgFailEvent) {
        [_pgFailEvent triggerEvent];
    }
}

- (void) triggerPgCloseEvent {
    if (_pgCloseEvent) {
        [_pgCloseEvent triggerEvent];
    }
}

- (void) triggerPgSuccessEvent {
    if (_pgSuccessEvent) {
        [_pgSuccessEvent triggerEvent];
    }
}

@end
