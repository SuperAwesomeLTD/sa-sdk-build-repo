/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAPGCloseEvent.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASession.h"
#import "SAUtils.h"

@implementation SAPGCloseEvent

- (NSString*) getEndpoint {
    return @"/event";
}

- (NSDictionary*) getQuery {
    if (ad && session) {
        return @{
                 @"sdkVersion": [session getVersion],
                 @"ct": @([session getConnectivityType]),
                 @"bundle": [session getBundleId],
                 @"rnd": @([session getCachebuster]),
                 @"data": [SAUtils encodeJSONDictionaryFromNSDictionary:@{
                         @"placement": @(ad.placementId),
                         @"line_item": @(ad.lineItemId),
                         @"creative": @(ad.creative._id),
                         @"type": @"parentalGateClose"
                         }]
                 };
    }
    else {
        return @{};
    }
}

@end
