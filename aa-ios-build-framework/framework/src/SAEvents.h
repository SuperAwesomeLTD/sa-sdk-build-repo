/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class SASession;
@class AVPlayer;
@class AVPlayerLayer;
@class SAMoatModule;
@class SAServerModule;
@class SAVASTModule;

#import "SAViewableModule.h"

/**
 * Class that abstracts away the sending of events to the ad server. 
 * It also handles triggering and disabling Moat Events
 */
@interface SAEvents : NSObject

@property (nonatomic, strong) SAServerModule *serverModule;
@property (nonatomic, strong) SAViewableModule *viewableModule;
@property (nonatomic, strong) SAVASTModule *vastModule;
@property (nonatomic, strong) SAMoatModule *moatModule;

- (void) setAd: (SAAd*) ad
    andSession: (SASession*) session;

- (void) unsetAd;

- (void) triggerClickEvent;
- (void) triggerImpressionEvent;
- (void) triggerViewableImpressionEvent;
- (void) triggerPgOpenEvent;
- (void) triggerPgCloseEvent;
- (void) triggerPgFailEvent;
- (void) triggerPgSuccessEvent;
- (NSString*) getVASTClickThroughEvent;
- (void) triggerVASTClickThroughEvent;
- (void) triggerVASTErrorEvent;
- (void) triggerVASTImpressionEvent;
- (void) triggerVASTCreativeViewEvent;
- (void) triggerVASTStartEvent;
- (void) triggerVASTFirstQuartileEvent;
- (void) triggerVASTMidpointEvent;
- (void) triggerVASTThirdQuartileEvent;
- (void) triggerVASTCompleteEvent;
- (void) triggerVASTClickTrackingEvent;
- (void) checkViewableStatusForDisplay:(UIView*)view andResponse:(saDidFindViewOnScreen) response;
- (void) checkViewableStatusForVideo:(UIView*)view andResponse:(saDidFindViewOnScreen) response;
- (NSString*) startMoatTrackingForDisplay:(id)webplayer;
- (BOOL) stopMoatTrackingForDisplay;
- (BOOL) startMoatTrackingForVideoPlayer:(AVPlayer*) player withLayer:(AVPlayerLayer*) layer andView:(UIView*) view;
- (BOOL) stopMoatTrackingForVideoPlayer;
- (void) disableMoatLimiting;


@end
