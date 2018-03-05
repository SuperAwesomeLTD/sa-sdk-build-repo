/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAPGFailEvent.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASession.h"
#import "SAUtils.h"

@implementation SAPGFailEvent

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
                                                                          @"type": @"parentalGateFail"
                                                                          }]
                 };
    }
    else {
        return @{};
    }
}

@end
