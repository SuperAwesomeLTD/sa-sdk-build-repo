/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

// typical event response (used mostly for testing purposes atm)
typedef void (^saDidFindViewOnScreen) (BOOL success);

@interface SAViewableModule : NSObject

/**
* Method that sends a viewable impression for a view.
* SuperAwesome calculates viewable impression conditions for banner,
* interstitial, etc, ads using IAB standards
*
* @param view       the child view
* @param maxTicks   max ticks to check the view is visible on the screen
*                   before triggering the viewable impression event
* @param response   an instance of the saDidGetEventResponse to
*/
- (void) checkViewableImpressionForView:(UIView*) view
                               andTicks:(NSInteger) maxTicks
                           withResponse:(saDidFindViewOnScreen) response;

/**
 * Shorthand method to send a viewable impression for a Display ad
 *
 * @param view the child view
 */
- (void) checkViewableImpressionForDisplay: (UIView*) view
                               andResponse: (saDidFindViewOnScreen) response;

/**
 * Shorthand method to send a viewable impression for a Video ad
 *
 * @param view the child view
 */
- (void) checkViewableImpressionForVideo: (UIView*) view
                             andResponse: (saDidFindViewOnScreen) response;

/**
 * Method that closes the event object (and disables timers, etc)
 */
- (void) close;

@end
