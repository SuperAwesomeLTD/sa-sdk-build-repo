/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAPGSuccessEvent.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASession.h"
#import "SAUtils.h"

@implementation SAPGSuccessEvent

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
                                                                          @"type": @"parentalGateSuccess"
                                                                          }]
                 };
    }
    else {
        return @{};
    }
}

@end
