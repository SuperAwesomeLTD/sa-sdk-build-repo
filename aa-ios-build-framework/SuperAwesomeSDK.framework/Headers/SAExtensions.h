/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Class extension that adds new methods to NSDictionary
 */
@interface NSDictionary (SAExtensions)

/**
 * Extension method that helps with enumerating keys and objects in a 
 * NSDictionary object.
 * 
 * @param block a block containing the key the object and whether the operation
 *              has reached it's end
 * @param end   what to execute at the end of the enumeration operation
 */
- (void) enumerateKeysAndObjectsUsingBlock:(nullable void (^)(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull end))block
                                     atEnd:(nullable void (^)(void))end;

@end

/**
 * Class extension that adds new methods to NSArray
 */
@interface NSArray (SAExtensions)

/**
 * Extension method that filters an array of complex objects (models) by a 
 * string value;
 *
 * @param member the name of the String member var to filter on
 * @param value  the values to include
 * @return       a filtered array
 */
- (nonnull NSArray*) filterBy:(nonnull NSString*) member withValue:(nonnull NSString*) value;

/**
 * Extension method that filters an array of complex objects (models) by a
 * boolean value;
 *
 * @param member the name of the Boolean member var to filter on
 * @param value  the values to include
 * @return       a filtered array
 */
- (nonnull NSArray*) filterBy:(nonnull NSString*) member withBool:(BOOL) value;

/**
 * Extension method that filters an array of complex objects (models) by a
 * integer value;
 *
 * @param member the name of the integer member var to filter on
 * @param value  the values to include
 * @return       a filtered array
 */
- (nonnull NSArray*) filterBy:(nonnull NSString*) member withInt:(NSInteger) value;

/**
 * Extension method that removes all elements from an array, except the first
 * one, if it exists.
 
 * @return an array withered down to just it's first element
 */
- (nonnull NSArray*) removeAllButFirstElement;

@end

/**
 * Class extension that adds new methods to UIAlertController
 */
@interface UIAlertController (SAExtensions)

/**
 * Extension method that just "shows" an alert controller
 */
- (void)show;

/**
 * Extension method that just "shows" an alert controller
 * 
 * @param animated whether it should be animated or not
 */
- (void)show:(BOOL)animated;

@end

/**
 * Class extension that adds new methods to NSString
 */
@interface NSString (SAExtensions)

/**
 * Extension method for NSString that decodes HTML entities from an HTML
 * string into a cleaned string.
 *
 * @return a cleaned string, without any HTML entities
 */
- (NSString* _Nonnull) stringByDecodingHTMLEntities;

@end
