/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <Foundation/Foundation.h>

@class SADetails;

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
 * An enum that defines the number of formats an ad can be in
 *  - invalid:  defined by the SDK in case of some error
 *  - image:    the creative is a simple banner image
 *  - video:    the creative is a video that must be streamed
 *  - rich:     a mini-HTML page with user interaction
 *  - tag:      a rich-media (usually) served as a JS file via a 3rd party service
 *  - appwall:  a pop-up with links to games
 */
typedef NS_ENUM (NSInteger, SACreativeFormat) {
    SA_Invalid = 0,
    SA_Image   = 1,
    SA_Video   = 2,
    SA_Rich    = 3,
    SA_Tag     = 4,
    SA_Appwall = 5
};

/**
 * This external static method is used to init the SACreativeFormat enum
 * starting from an integer value.
 *
 * @param format an int that will get translated to an enum
 * @return       a new SACreativeFormat variable.
 *               - if format == 5 -> then appwall
 *               - if format == 4 -> then tag
 *               - if format == 3 -> then rich
 *               - if format == 2 -> then video
 *               - if format == 1 -> then image
 *               - else invalid
 */
static inline SACreativeFormat getSACreativeFormatFromInt (NSInteger format) {
    if (format == 5) return SA_Invalid;
    if (format == 4) return SA_Tag;
    if (format == 3) return SA_Rich;
    if (format == 2) return SA_Video;
    if (format == 1) return SA_Image;
    return SA_Invalid;
}

/**
 * This external static method is used to init the SACreativeFormat enum
 * starting from a string value.
 *
 * @param format an int that will get translated to an enum
 * @return       a new SACreativeFormat variable.
 *               - if format contains "gamewall" or "appwall" -> then appwall
 *               - if format contains "tag" -> then tag
 *               - if format contains "rich_media" -> then rich
 *               - if format equals "video" -> then video
 *               - if format equals "image_with_link" -> then image
 *               - else invalid
 */
static inline SACreativeFormat getSACreativeFormatFromString (NSString *format) {
    if (format == nil) return SA_Invalid;
    if ([format isEqualToString:@"image_with_link"]) return SA_Image;
    if ([format isEqualToString:@"video"]) return SA_Video;
    if ([format rangeOfString:@"rich_media"].location != NSNotFound) return SA_Rich;
    if ([format rangeOfString:@"tag"].location != NSNotFound) return SA_Tag;
    if ([format rangeOfString:@"gamewall"].location != NSNotFound) return SA_Appwall;
    if ([format rangeOfString:@"appwall"].location != NSNotFound) return SA_Appwall;
    return SA_Invalid;
}

/**
 * This external static method is used to return a string based on a 
 * SACreativeFormat enum value.
 *
 * @param format an SACreativeFormat value
 * @return       a new NSString object based on the SACreativeFormat
 *               - if format is SA_Image --> then "image_with_link"
 *               - if format is SA_Video --> then "video"
 *               - if format is SA_Rich --> then "rich_media"
 *               - if format is SA_Tag --> then "tag"
 *               - if format is SA_AppWall --> then "appwall"
 *               - elese just return "invalid"
 */
static inline NSString* getStringFromSACreativeFormat (SACreativeFormat format) {
    if (format == SA_Image) return @"image_with_link";
    if (format == SA_Video) return @"video";
    if (format == SA_Rich) return @"rich_media";
    if (format == SA_Tag) return @"tag";
    if (format == SA_Appwall) return @"appwall";
    return @"invalid";
}

/**
 * Class that contains creative info, such as:
 *  - creative id and name
 *  - cpm (not really relevant for the SDK)
 *  - format (video, tag, rich media, image, etc)
 *  - live & approved
 *  - a custom payload
 *  - click url
 *  - external impression, click counter & install url
 *  - bundle Id
 *  - a list of events to be triggered on different stages of ad execution
 *  - a SADetails object
 *
 */
@interface SACreative : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, assign) NSInteger                     _id;
@property (nonatomic, strong) NSString                      *name;
@property (nonatomic, assign) NSInteger                     cpm;
@property (nonatomic, assign) SACreativeFormat              format;
@property (nonatomic, assign) BOOL                          live;
@property (nonatomic, assign) BOOL                          approved;
@property (nonatomic, assign) BOOL                          bumper;
@property (nonatomic, strong) NSString                      *payload;

@property (nonatomic, strong) NSString                      *clickUrl;
@property (nonatomic, strong) NSString                      *clickCounterUrl;
@property (nonatomic, strong) NSString                      *installUrl;
@property (nonatomic, strong) NSString                      *impressionUrl;

@property (nonatomic, strong) NSMutableArray<NSString*>     *osTarget;

@property (nonatomic, strong) NSString                      *bundle;
@property (nonatomic, strong) SADetails                     *details;

@end
