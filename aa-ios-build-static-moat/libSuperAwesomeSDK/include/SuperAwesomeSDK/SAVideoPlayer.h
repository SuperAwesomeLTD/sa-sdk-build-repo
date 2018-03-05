/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAURLClicker.h"

@class AVPlayer;
@class AVPlayerLayer;

/**
 * VideoPlayer event enum, containing the following events:
 *  - Video_Start:  triggered when a video starts playing
 *  - Video_1_4:    triggered when a video reaches a quarter of 
 *                  its playing duration
 *  - Video_1_2:    triggered when a video reaches half of its playing duration
 *  - Video_3_4:    triggered when a video reaches three quarters of 
 *                  its playing duration
 *  - Video_End:    triggered when a video ends playing
 *  - Video_Error:  triggered anytime there is any kind of error that prevents
 *                  the video from playing
 */
typedef NS_ENUM(NSInteger, SAVideoPlayerEvent) {
    Video_Start = 0,
    Video_1_4 = 1,
    Video_1_2 = 2,
    Video_3_4 = 3,
    Video_End = 4,
    Video_15s = 5,
    Video_Error = 6
};

// callback method for video events
typedef void (^saVideoPlayerDidReceiveEvent)(SAVideoPlayerEvent event);

// callback method for click events
typedef void (^saVideoPlayerDidReceiveClick)();

/**
 * A class that abstracts away all the details of playing a video on iOS
 */
@interface SAVideoPlayer : UIView

/**
 * Method that plays a video from a local location
 *
 * @param file  local URL location
 */
- (void) playWithMediaFile:(NSString*)file;

/**
 * Method that updates the full video frame
 *
 * @param frame the new target frame
 */
- (void) updateToFrame:(CGRect)frame;

/**
 * Method that stops all video content playing and removes the video
 */
- (void) destroy;

/**
 * Method that stops all video content and resets it to 0
 */
- (void) reset;

/**
 * Method that resumes all video playing
 */
- (void) resume;

/**
 * Method that pauses all video playing
 */
- (void) pause;

/**
 * Setter for a new event listener
 *
 * @param handler library user callback implementation
 */
- (void) setEventHandler:(saVideoPlayerDidReceiveEvent)handler;

/**
 * Setter for a new click listener
 *
 * @param handler library user callback implementation
 */
- (void) setClickHandler:(saVideoPlayerDidReceiveClick)handler;

/**
 * Sets whether the video will have a small click button or a full-surface
 * click button
 */
- (void) showSmallClickButton;

/**
 * Getter for the current AVPlayer instance
 *
 * return the current AVPlayer instance used by the SAVideoPlayer
 */
- (AVPlayer*) getPlayer;

/**
 * Getter for the current AVPlayerLayer instance
 *
 * return the current AVPlayerLayer instance used by the SAVideoPlayer
 */
- (AVPlayerLayer*) getPlayerLayer;

@end
