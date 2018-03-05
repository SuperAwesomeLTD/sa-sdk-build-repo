/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Class that subclasses UIView. It will be used by SAVideoPlayer to draw a
 * timer on top of the video, in the lower-left part of the video surface.
 */

@interface SACronograph : UIView

/**
 * Method that updates the timer's text view to display the current time.
 *
 * @param remaining an integer representing the number of seconds the
                    video has to play 
 */
- (void) setTime:(NSInteger) remaining;

@end
