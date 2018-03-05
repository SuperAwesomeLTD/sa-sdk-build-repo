/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 *  This function makes sure the data you enter in a dictionary object is not
 *  ever going to be NULL or nil; If it's not initialized, a NSNull instance
 *  will be delivered
 *
 *  @param object the object in question
 *
 *  @return either the object or NSNull
 */
__attribute__((unused)) static _Nullable id nullSafe(_Nullable id object) {
    return object ?: [NSNull null];
}

/**
 * This class extensions contains a collection of methods that makes trying
 * to get data from a dictionary "safe" - e.g. you won't get null
 * pointer exceptions and other nice things
 */
@interface NSDictionary (SafeHandling)

/**
 * Extension method that safely extracts a value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid value or nil
 */
- (id _Nullable) safeObjectForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is nil
 * @return      a valid value or default
 */
- (id _Nullable) safeObjectForKey:(id _Nullable)aKey orDefault:(id _Nullable)def;

/**
 * Extension method that safely extracts an int value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid integer or 0
 */
- (NSInteger) safeIntForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts an int value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is 0
 * @return      a valid integer or default
 */
- (NSInteger) safeIntForKey:(id _Nullable)aKey orDefault:(NSInteger) def;

/**
 * Extension method that safely extracts a bool value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid bool or false
 */
- (BOOL) safeBoolForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a bool value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is false
 * @return      a valid bool or default
 */
- (BOOL) safeBoolForKey:(id _Nullable)aKey orDefault:(BOOL) def;

/**
 * Extension method that safely extracts a float value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid float or 0.0F
 */
- (float) safeFloatForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a float value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is 0.0F
 * @return      a valid float or default
 */
- (float) safeFloatForKey:(id _Nullable)aKey orDefault:(float)def;

/**
 * Extension method that safely extracts a double value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid double or 0.0D
 */
- (double) safeDoubleForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a double value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is 0.0D
 * @return      a valid double or default
 */
- (double) safeDoubleForKey:(id _Nullable)aKey orDefault:(double)def;

/**
 * Extension method that safely extracts a string value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid string or nil
 */
- ( NSString* _Nullable) safeStringForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a string value from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is nil
 * @return      a valid string or default
 */
- ( NSString* _Nullable) safeStringForKey:(id _Nullable)aKey orDefault:(NSString* _Nullable)def;

/**
 * Extension method that safely extracts a NSDictionary object from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid dictionary or @{}
 */
- (NSDictionary* _Nullable) safeDictionaryForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a NSDictionary object from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is @{}
 * @return      a valid dictionary is default
 */
- (NSDictionary* _Nullable) safeDictionaryForKey:(id _Nullable)aKey orDefault:(NSDictionary* _Nullable)def;

/**
 * Extension method that safely extracts a NSArray object from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @return      a valid array or @[]
 */
- (NSArray* _Nullable) safeArrayForKey:(id _Nullable)aKey;

/**
 * Extension method that safely extracts a NSDictionary object from a dictionary
 *
 * @param aKey  name of the dictionary key
 * @param def   value to pass as default in case answer is @[]
 * @return      a valid array or default
 */
- (NSArray* _Nullable) safeArrayForKey:(id _Nullable)aKey orDefault:(NSArray* _Nullable)def;


@end
