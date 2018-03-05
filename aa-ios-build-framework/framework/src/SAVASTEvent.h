/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/SABaseObject.h>)
#import <SAJsonParser/SABaseObject.h>
#else
#import "SABaseObject.h"
#endif
#endif

/**
 * Class that defines a tracking element in AwesomeAds.
 * Each tracking element contains an:
 *  - event name (a string)
 *  - an URL to be hit
 */
@interface SAVASTEvent : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *URL;

@end
