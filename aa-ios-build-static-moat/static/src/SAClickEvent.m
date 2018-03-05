/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAClickEvent.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASession.h"

@implementation SAClickEvent

- (NSString*) getEndpoint {
    return ad ? ad.creative.format == SA_Video ? @"/video/click" : @"/click" : @"";
}

- (NSDictionary*) getQuery {
    if (ad && session) {
        return @{
                 @"placement": @(ad.placementId),
                 @"bundle": [session getBundleId],
                 @"creative": @(ad.creative._id),
                 @"line_item": @(ad.lineItemId),
                 @"ct": @([session getConnectivityType]),
                 @"sdkVersion": [session getVersion],
                 @"rnd": @([session getCachebuster])
                 };
    } else {
        return @{};
    }
}

@end
