/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@interface SALoadScreen : NSObject

/**
 * Getter for the current instance
 *
 * @return the current instance
 */
+ (instancetype) getInstance;

/**
 * Public method that creates and shows a loading screen
 */
- (void) show;

/**
 * Public method that dismisses a loading screen
 */
- (void) hide;

@end
