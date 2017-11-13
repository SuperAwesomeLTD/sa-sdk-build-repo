//
//  SAAdvUtils.h
//  Pods
//
//  Created by Gabriel Coman on 28/07/2017.
//
//

#import <UIKit/UIKit.h>

/**
 * This enum holds the two possible ad server configurations the
 * SDK should respond to:
 *  - PRODUCTION
 *  - STAGING
 */
typedef NS_ENUM(NSInteger, SAdvConfiguration) {
    advPRODUCTION  = 0,
    advSTAGING     = 1
};

@interface SAAdvUtils : NSObject

/**
 * Returns the current Bundle ID
 *
 * @return: the current app's bundle id (com.test.exampel)
 */
+ (NSString*) getBundleId;

/**
 * Returns the current User Agent
 *
 * @return: "Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19"
 */
+ (NSString*) getUserAgent;

/**
 * This method takes a NSDictionary paramter and returns it as a valid
 * GET query string (e.g. a JSON { "name": "John", "age": 23 }
 * would become "name=John&age=23"
 *
 * @param dict  a NSDictionary object to be transformed into a
 *              GET query string
 * @return      a valid GET query string
 */
+ (NSString*) formGetQueryFromDict:(NSDictionary *)dict;

@end
