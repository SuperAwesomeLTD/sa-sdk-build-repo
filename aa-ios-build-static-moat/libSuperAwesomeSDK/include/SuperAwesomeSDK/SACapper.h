/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Class that abstracts away generating a distinct ID called "DAU ID", 
 * which consists of:
 * - the Advertising ID int
 * - a random ID
 * - the package name
 * each hashed and then XOR-ed together
 */
@interface SACapper : NSObject

/**
 * Public method that gets the current DAU ID and returns it to
 * the library user.
 *
 * @return an Integer representing a device+app specific integer ID used
 *         in frequency capping by the ad server
 */
- (NSUInteger) getDauId;

@end
