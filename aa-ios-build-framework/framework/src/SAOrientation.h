/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Enum defining possible orientations a fullscreen ad may be found in:
 * - ANY:       the ad can be viewed in any orientation and will not try to lock it
 * - PORTRAIT:  the ad will lock it's orientation in portrait mode, 
 *              no matter what the app orientation is
 * - LANDSCAPE: the ad will lock it's orientation in landscape mode,
 *              no matter what the app orientation is
 */
typedef NS_ENUM(NSInteger, SAOrientation) {
    ANY = 0,
    PORTRAIT = 1,
    LANDSCAPE = 2
};

/**
 * Static inline method that sets the orientation starting from an integer
 * 
 * @param orientation   the integer value 
 * @return an enum, based on the int value being passed
 */
static inline SAOrientation getOrientationFromInt (int orientation) {
    return orientation == 2 ? LANDSCAPE : orientation == 1 ? PORTRAIT : ANY;
}
