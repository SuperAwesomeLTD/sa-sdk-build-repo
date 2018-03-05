/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class AVPlayer;
@class AVPlayerLayer;
@class SUPMoatWebTracker;
@class SUPMoatVideoTracker;

@interface SAMoatModule : NSObject

@property (nonatomic, strong) SUPMoatVideoTracker *videoTracker;
@property (nonatomic, strong) SUPMoatWebTracker *webTracker;

- (id) initWithAd: (SAAd*) ad;

/**
 * Method that registers a Moat event object,
 * according to the moat specifications
 *
 * @param webplayer the web view used by Moat to register events on
 *                  (and that will contain an ad at runtime)
 * @return          returns a MOAT specific string that will need to be
 *                  inserted in the web view so that the JS moat stuff works
 */
- (NSString*) startMoatTrackingForDisplay:(id)webplayer;

/**
 * Stop moat tracking for display (web view) ads
 */
- (BOOL) stopMoatTrackingForDisplay;

/**
 * Method that registers a Video Moat event
 *
 * @param player    the current AVPlayer needed by Moat to do video tracking
 * @param layer     the current Player layer associated with the video view
 * @return          whether the video moat event started OK
 */
- (BOOL) startMoatTrackingForVideoPlayer:(AVPlayer*) player
                               withLayer:(AVPlayerLayer*) layer
                                 andView:(UIView*) view;

/**
 * Stop moat tracking for video ads
 */
- (BOOL) stopMoatTrackingForVideoPlayer;

/**
 * Method by which Moat can be fully enforced by disabling
 * any limiting applied to it
 */
- (void) disableMoatLimiting;

@end
