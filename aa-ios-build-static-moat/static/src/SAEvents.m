/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAEvents.h"
#import "SAServerModule.h"
#import "SAMoatModule.h"
#import "SAViewableModule.h"
#import "SAVASTModule.h"

@interface SAEvents ()
@end

@implementation SAEvents

- (void) setAd: (SAAd*) ad
    andSession: (SASession*) session {
    
    _serverModule = [[SAServerModule alloc] initWithAd:ad andSession:session];
    _moatModule = [[SAMoatModule alloc] initWithAd:ad];
    _viewableModule = [[SAViewableModule alloc] init];
    _vastModule = [[SAVASTModule alloc] initWithAd:ad];
    
}

- (void) unsetAd {
    
    _serverModule = nil;
    _moatModule = nil;
    [_viewableModule close];
    _viewableModule = nil;
    _vastModule = nil;
    
}

- (void) triggerClickEvent {
    if (_serverModule) {
        [_serverModule triggerClickEvent];
    }
}

- (void) triggerImpressionEvent {
    if (_serverModule) {
        [_serverModule triggerImpressionEvent];
    }
}

- (void) triggerViewableImpressionEvent {
    if (_serverModule) {
        [_serverModule triggeViewableImpressionEvent];
    }
}

- (void) triggerPgOpenEvent {
    if (_serverModule) {
        [_serverModule triggerPgOpenEvent];
    }
}

- (void) triggerPgCloseEvent {
    if (_serverModule) {
        [_serverModule triggerPgCloseEvent];
    }
}

- (void) triggerPgFailEvent {
    if (_serverModule) {
        [_serverModule triggerPgFailEvent];
    }
}

- (void) triggerPgSuccessEvent {
    if (_serverModule) {
        [_serverModule triggerPgSuccessEvent];
    }
}

- (NSString*) getVASTClickThroughEvent {
    return _vastModule ? [_vastModule getVASTClickThroughEvent] : @"";
}

- (void) triggerVASTClickThroughEvent {
    if (_vastModule) {
        [_vastModule triggerVASTClickThroughEvent];
    }
}

- (void) triggerVASTErrorEvent {
    if (_vastModule) {
        [_vastModule triggerVASTErrorEvent];
    }
}

- (void) triggerVASTImpressionEvent {
    if (_vastModule) {
        [_vastModule triggerVASTImpressionEvent];
    }
}

- (void) triggerVASTCreativeViewEvent {
    if (_vastModule) {
        [_vastModule triggerVASTCreativeViewEvent];
    }
}

- (void) triggerVASTStartEvent {
    if (_vastModule) {
        [_vastModule triggerVASTStartEvent];
    }
}

- (void) triggerVASTFirstQuartileEvent {
    if (_vastModule) {
        [_vastModule triggerVASTFirstQuartileEvent];
    }
}

- (void) triggerVASTMidpointEvent {
    if (_vastModule) {
        [_vastModule triggerVASTMidpointEvent];
    }
}

- (void) triggerVASTThirdQuartileEvent {
    if (_vastModule) {
        [_vastModule triggerVASTThirdQuartileEvent];
    }
}

- (void) triggerVASTCompleteEvent {
    if (_vastModule) {
        [_vastModule triggerVASTCompleteEvent];
    }
}

- (void) triggerVASTClickTrackingEvent {
    if (_vastModule) {
        [_vastModule triggerVASTClickTrackingEvent];
    }
}

- (void) checkViewableStatusForDisplay:(UIView*)view
                           andResponse:(saDidFindViewOnScreen) response {

    if (_viewableModule) {
        [_viewableModule checkViewableImpressionForDisplay:view
                                               andResponse:response];
    }
    
}

- (void) checkViewableStatusForVideo:(UIView*)view
                         andResponse:(saDidFindViewOnScreen) response {
    
    if (_viewableModule) {
        [_viewableModule checkViewableImpressionForVideo:view
                                             andResponse:response];
    }
    
}

- (NSString*) startMoatTrackingForDisplay:(id)webplayer {
    return _moatModule ? [_moatModule startMoatTrackingForDisplay:webplayer] : @"";
}

- (BOOL) stopMoatTrackingForDisplay {
    return _moatModule ? [_moatModule stopMoatTrackingForDisplay] : false;
}

- (BOOL) startMoatTrackingForVideoPlayer:(AVPlayer*) player
                               withLayer:(AVPlayerLayer*) layer
                                 andView:(UIView*) view {
    return _moatModule ? [_moatModule startMoatTrackingForVideoPlayer:player withLayer:layer andView:view] : false;
}

- (BOOL) stopMoatTrackingForVideoPlayer {
    return _moatModule ? [_moatModule stopMoatTrackingForVideoPlayer] : false;
}

- (void) disableMoatLimiting {
    if (_moatModule) {
        [_moatModule disableMoatLimiting];
    }
}

@end
