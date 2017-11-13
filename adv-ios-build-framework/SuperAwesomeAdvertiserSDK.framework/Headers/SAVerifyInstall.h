/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAInstall.h"
#import "SAAdvUtils.h"

@interface SAVerifyInstall : NSObject

/**
 * Singleton method to get the only existing instance
 *
 * @return an instance of the SACPI class
 */
+ (instancetype) getInstance;

/**
 * Main class method that handles all the aspects of properly sending 
 * an /install event
 * This method also assumes a production session, so users 
 * won't have to set their own session.
 *
 * @param response a callback block of type saDidCountAnInstall
 */
- (void) handleInstall: (saDidCountAnInstall) response;

/**
 * Main class method that handles all the aspects of properly sending
 * an /install event
 * This method also assumes a production session, so users
 * won't have to set their own session.
 *
 * @param target        the target bundle ID
 * @param configuration either production or staging
 * @param response      a callback block of type saDidCountAnInstall
 */
- (void) handleInstall: (NSString*) target
      andConfiguration: (SAdvConfiguration) configuration
          withResponse: (saDidCountAnInstall) response;

@end
