/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Class full of static methods that serve images saved as Strings
 */
@interface SAImageUtils : NSObject

/**
 * Static method that returns a "close" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) closeImage;

/**
 * Static method that returns a "padlock" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) padlockImage;

/**
 * Static method that returns a "game wall background" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) gameWallBackground;

/**
 * Static method that returns a "game wall close" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) gameWallClose;

/**
 * Static method that returns a "game wall data" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) gameWallAppData;

/**
 * Static method that returns a "game wall header" image from a string
 *
 * @return new UIImage instance
 */
+ (UIImage*) gameWallHeader;

@end
