/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SACreative.h"

@class SAAd;

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
 * Class that defines an ad server response in AwesomeAds.
 * Each response can contain:
 *  - a placement id (that the ad request was made to)
 *  - the status of the network request
 *  - the general format of the ad / ads in the response; if there's a single ad in the list, the
 *    format is the same; if there are multiple it should only be appwall
 *  - a list of ads; usually used for appwall
 */
@interface SAResponse : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger         	placementId;
@property (nonatomic, assign) SACreativeFormat      format;
@property (nonatomic, assign) NSInteger             status;
@property (nonatomic, strong) NSMutableArray<SAAd*> *ads;

@end
