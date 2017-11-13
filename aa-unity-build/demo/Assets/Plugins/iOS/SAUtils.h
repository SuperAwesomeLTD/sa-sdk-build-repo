/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

// macros to get the system version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 * SAUtils enum defining possible SDK system sizes
 *  - phone: the SDK determined it's a phone-type device
 *  - tablet: the SDK determined it's a tablet-type device
 */
typedef NS_ENUM (NSInteger, SASystemSize) {
    size_phone  = 0,
    size_tablet = 1
};

/**
 * SAUtils enum defining possible connection types
 *  - unknown
 *  - ethernet
 *  - wifi
 *  - cellular_unknown, 2g, 3g, 4g,
 */
typedef NS_ENUM (NSInteger, SAConnectionType) {
    unknown          = 0,
    ethernet         = 1,
    wifi             = 2,
    cellular_unknown = 3,
    cellular_2g      = 4,
    cellular_3g      = 5,
    cellular_4g      = 6
};

@interface SAUtils : NSObject

/**
 * Method that does the math to transform a rectangle into the bounds of
 * another rectangle.
 *
 * @param sourceFrame   the source frame I want to map to
 * @param boundingFrame the bounding frame I want the source to be mapped in
 * @return              the correctly mapped result frame
 */
+ (CGRect) map:(CGRect)sourceFrame into:(CGRect)boundingFrame;

/**
 * Method that checks whether one rect is completely inside another one
 *
 * @param target    the rect I want to test
 * @param frame    the rect I want to test against
 * @return          true or false
 */
+ (BOOL) isRect:(CGRect)target inRect:(CGRect)frame;

/**
 * Method that generates a random integer between two bounds
 *
 * @param min   the lower bound
 * @param max   the upper bound
 * @return      the randomly generated integer
 */
+ (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max;

/**
 * Method that returns a string bounded by a start and end substring
 *
 * @param source    the source string to find a substring in
 * @param start     the starting bounding string
 * @param end       the ending bounding string
 * @return          a substring bounded by "start" and "end" parameters
 */
+ (NSString*) substringIn:(NSString*)source from:(NSString*)start to:(NSString*)end;

/**
 * Method that generates a 32-character alpha-numeric key as a string
 * 
 * @return  a unique key
 */
+ (NSString*) generateUniqueKey;

/**
 * Method that returns what type of device the SDK is running on, either
 * phone or tablet
 * 
 * @return a SASystemSize enum type
 */
+ (SASystemSize) getSystemSize;

/**
 * Method that returns the type of device the SDK is running on as a string
 *
 * @return either the "ios_mobile" or "ios_tablet" strings
 */
+ (NSString*) getVerboseSystemDetails;

/**
 * Method that returns the full path of a file in the documents directory
 *
 * @param fpath the file name
 * @Return      the full file path, including the file name
 */
+ (NSString*) filePathInDocuments:(NSString*)fpath;

/**
 * Method that returns the current User Agent of a UIWebView object
 * 
 * @return a string representing a User Agent
 */
+ (NSString*) getUserAgent;

/**
 * Shorthand method that returns a random integer used as cachebuster
 *
 * @return an random integer between 1000000 and 1500000
 */
+ (NSInteger) getCachebuster;

/**
 * Method that transforms a NSDictionary object into a GET query string
 *
 * @param dict  a NSDictionary containing key-value pairs
 * @return      a valid GET query string as key1=value1&key2=value2 (unencoded)
 */
+ (NSString*) formGetQueryFromDict:(NSDictionary*)dict;

/**
 * Method that transforms an unencoded string into a URI encoded string
 * 
 * @return a URI encoded string
 */
+ (NSString*) encodeURI:(NSString*)stringToEncode;

/**
 * Method that transforms a NSDictionary as an encoded JSON object usable as
 * part of a GET request query
 * 
 * @param dict  a NSDictionary containing key-value pairs
 * @return      an encoded JSON like %7Bkey1%3Avalue1%2Ckey2%3Avalue2%7D+
 */
+ (NSString*) encodeJSONDictionaryFromNSDictionary:(NSDictionary*)dict;

/**
 * Method that decodes HTML entities from an HTML string into a cleaned string.
 *
 * @param string the source string to be decoded
 * @return       the decoded string
 */
+ (NSString*) decodeHTMLEntitiesFrom:(NSString*)string;

/**
 * Method that finds a base URL from a given resource URL
 *
 * @param resourceURL a generic URL
 * @return            from https://example.com/imgs/image1.png to 
 *                    https://example.com/imgs/
 */
+ (NSString*) findBaseURLFromResourceURL:(NSString*)resourceURL;

/**
 * Method that validates a url
 * 
 * @param urlObject a NSObject object that will be tested for:
 *                  - being a NSString instance
 *                  - being non-null and not an instance of NSNull
 *                  - being an actual valid URL
 * @return          true or false
 */
+ (BOOL) isValidURL:(NSObject*) urlObject;

/**
 * Method that validates an email
 * 
 * @param email a NSString object that will be tested for email validity
 * @return      true or false
 */
+ (BOOL) isEmailValid:(NSString*) email;

/**
 * Method that transforms an int (given as a hex) into an UIColor object
 *
 * @param rgbValue to be transformed into a color; given as 0x4f252a
 * @return         an UIColor object
 */
UIColor *UIColorFromHex (int rgbValue);

/**
 * Method that takes three integeres into an UIColor object
 *
 * @param red   component of the color (0 - 255)
 * @param green component of the color (0 - 255)
 * @param blue  component of the color (0 - 255)
 * @return      an UIColor object
 */
UIColor *UIColorFromRGB (NSInteger red, NSInteger green, NSInteger blue);

/**
 * Method that returns the current type of network connectivity
 *
 * @return an enum of type SAConnectionType, containing a valid connection 
 *         status (wifi, 3g, 2g, ethernet, etc) or unknown
 */
+ (SAConnectionType) getNetworkConnectivity;


/**
 * Method used to invoke a method on a target of type "id", with a variable
 * number of arguments.
 *
 * @param method    the method to be invoked, as a string
 * @param target    the object to invoke the method on
 * @param ...       variable number of arguments to be passed to the method
 * @return          an object of type NSValue containing the return value of
 *                  the method being invoked
 */
+ (NSValue*) invoke:(NSString*)method onTarget:(id) target, ...;

/**
 * Method used to invoke a method on a target class, with a variable
 * number of arguments.
 *
 * @param method    the method to be invoked, as a string
 * @param name      the name of the class the method will be invoked on
 * @param ...       variable number of arguments to be passed to the method
 * @return          an object of type NSValue containing the return value of
 *                  the method being invoked
 */
+ (NSValue*) invoke:(NSString*)method onClass:(NSString*) name, ...;


@end
