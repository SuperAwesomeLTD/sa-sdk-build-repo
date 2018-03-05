/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAVASTEvent;
@class SAVASTMedia;

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
 * Enum that defines the types of VAST ads available
 *  - Invalid: when a valid vast ad could not be found
 *  - InLine: when a direct vast ad could be found (which should also contain a video)
 *  - Wrapper: when the current vast tag should redirect to another one down the line
 */
typedef NS_ENUM (NSInteger, SAVASTAdType) {
    SA_Invalid_VAST = 0,
    SA_InLine_VAST  = 1,
    SA_Wrapper_VAST = 2
};

/**
 * This external static method is used to init the SAVASTAdType enum
 * starting from an integer value.
 *
 * @param type an int that will get translated to an enum
 * @return     a new SAVASTAdType variable.
 *             - if type == 2 -> then SA_Wrapper
 *             - if type == 1 -> then SA_InLine
 *             - else SA_Invalid
 */
static inline SAVASTAdType getSAVASTAdTypeFromInt (NSInteger type) {
    return type == 2 ? SA_Wrapper_VAST : type == 1 ? SA_InLine_VAST : SA_Invalid_VAST;
}

/**
 * Class that represents a VAST Ad
 *  - a VAST URL redirect
 *  - a VAST type (starting out as Invalid, but should either be InLine or Wrapper)
 *  - a media URL
 *  - an array of vast tracking elements
 */
@interface SAVASTAd : SABaseObject

@property (nonatomic, strong) NSString                      *redirect;
@property (nonatomic, assign) SAVASTAdType                  type;
@property (nonatomic, strong) NSString                      *url;
@property (nonatomic, strong) NSMutableArray <SAVASTMedia*> *media;
@property (nonatomic, strong) NSMutableArray <SAVASTEvent*> *events;

/**
 * Specific method that sums two ads together
 *
 * @param toBeAdded the ad that's going to be added
 */
- (void) sumAd: (SAVASTAd*) toBeAdded;

@end
