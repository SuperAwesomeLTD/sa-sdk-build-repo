/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * This class contains methods that make sure that the CPI code gets 
 * executed just once.
 */
@interface SAOnce : NSObject

/**
 * Method that checks if the local preferences objects contains 
 * the SA CPI Key.
 *
 * @return true if present, false otherwise
 */
- (BOOL) isCPISent;

/**
 * Method that sets the CPI install event as being sent by putting 
 * "true" under the local preferences KEY key.
 
 * @return true if operation OK, false otherwise
 */
- (BOOL) setCPISent;

/**
 * Aux method (used mostly for testing) that resets the CPI sent KEY 
 * in the shared preferences.
 *
 * @return true if operation OK, false otherwise
 */
- (BOOL) resetCPISent;

@end
