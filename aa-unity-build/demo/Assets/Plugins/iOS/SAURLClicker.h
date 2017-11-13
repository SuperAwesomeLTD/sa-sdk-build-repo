/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Class that subclasses UIView. It will be used by SAVideoPlayer to draw a
 * clicker button over each video.
 */
@interface SAURLClicker : UIButton

// clicker property that dictates if it's going to be covering the whole
// video area or just be a small button in the bottom-left part of the video
@property (nonatomic, assign) BOOL shouldShowSmallClickButton;

@end
