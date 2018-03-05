/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAImpressionEvent.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASession.h"

@implementation SAImpressionEvent

- (NSString*) getEndpoint {
    return @"/impression";
}

- (NSDictionary*) getQuery {
    if (ad && session) {
        return @{
                 @"placement": @(ad.placementId),
                 @"creative": @(ad.creative._id),
                 @"line_item": @(ad.lineItemId),
                 @"sdkVersion": [session getVersion],
                 @"bundle": [session getBundleId],
                 @"ct": @([session getConnectivityType]),
                 @"no_image": @(true),
                 @"rnd": @([session getCachebuster])
                 };
    }
    else {
        return @{};
    }
}

@end
