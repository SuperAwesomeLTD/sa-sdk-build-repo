//
//  SAParser.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header file
#import "SAAdParser.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SATracking.h>)
#import <SAModelSpace/SATracking.h>
#else
#import "SATracking.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

// parser implementation
@implementation SAAdParser

- (SAAd*) parseInitialAdFromNetwork:(NSString*)jsonString
                    withPlacementId:(NSInteger)placementId
                         andSession:(SASession *)session {
    
    SAAd *ad = [[SAAd alloc] initWithJsonString:jsonString];
    ad.placementId = placementId;
    
    ad.creative.creativeFormat = invalid;
    if (ad.creative.format != nil && [ad.creative.format isEqualToString:@"image_with_link"]) {
        ad.creative.creativeFormat = image;
    }
    if (ad.creative.format != nil && [ad.creative.format isEqualToString:@"video"]) {
        ad.creative.creativeFormat = video;
    }
    if (ad.creative.format != nil && [ad.creative.format rangeOfString:@"rich_media"].location != NSNotFound) {
        ad.creative.creativeFormat = rich;
    }
    if (ad.creative.format != nil && [ad.creative.format rangeOfString:@"tag"].location != NSNotFound) {
        ad.creative.creativeFormat = tag;
    }
    if (ad.creative.format != nil && [ad.creative.format rangeOfString:@"gamewall"].location != NSNotFound) {
        ad.creative.creativeFormat = gamewall;
    }
    
    // create the tracking URL
    NSDictionary *trackjson = @{
        @"placement":@(ad.placementId),
        @"line_item":@(ad.lineItemId),
        @"creative":@(ad.creative._id),
        @"ct":@([session getConnectivityType]),
        @"sdkVersion":[session getVersion],
        @"rnd":@([session getCachebuster])
    };
    SATracking *trackingEvt = [[SATracking alloc] init];
    trackingEvt.event = @"sa_tracking";
    trackingEvt.URL = [NSString stringWithFormat:@"%@/%@click?%@",
                       [session getBaseUrl],
                       (ad.creative.creativeFormat == video ? @"video/" : @""),
                       [SAUtils formGetQueryFromDict:trackjson]];
    
    NSDictionary *saimprjson = @{
        @"placement": @(ad.placementId),
        @"creative": @(ad.creative._id),
        @"line_item": @(ad.lineItemId),
        @"sdkVersion": [session getVersion],
        @"rnd": @([session getCachebuster]),
        @"no_image": @(true)
    };
    
    SATracking *saImpressionEvt = [[SATracking alloc] init];
    saImpressionEvt.event = @"sa_impr";
    saImpressionEvt.URL = [NSString stringWithFormat:@"%@/impression?%@",
                           [session getBaseUrl],
                           [SAUtils formGetQueryFromDict:saimprjson]];
    
    // get the viewbale impression URL
    NSDictionary *imprjson = @{
        @"sdkVersion":[session getVersion],
        @"rnd":@([session getCachebuster]),
        @"ct":@([session getConnectivityType]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type":@"viewable_impression"
        } jsonCompactStringRepresentation]]
    };
    SATracking *viewableImpression = [[SATracking alloc] init];
    viewableImpression.event = @"viewable_impr";
    viewableImpression.URL = [NSString stringWithFormat:@"%@/event?%@",
                                [session getBaseUrl],
                                [SAUtils formGetQueryFromDict:imprjson]];
    
    // get the parental gate URL
    NSDictionary *pgjsonfail = @{
        @"sdkVersion":[session getVersion],
        @"rnd":@([session getCachebuster]),
        @"ct":@([session getConnectivityType]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type": @"parentalGateFail"
        } jsonCompactStringRepresentation]]
    };
    SATracking *parentalGateFail = [[SATracking alloc] init];
    parentalGateFail.event = @"pg_fail";
    parentalGateFail.URL = [NSString stringWithFormat:@"%@/event?%@",
                                        [session getBaseUrl],
                                        [SAUtils formGetQueryFromDict:pgjsonfail]];
    
    NSDictionary *pgjsonclose = @{
                                 @"sdkVersion":[session getVersion],
                                 @"rnd":@([session getCachebuster]),
                                 @"ct":@([session getConnectivityType]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateClose"
                                                               } jsonCompactStringRepresentation]]
                                 };
    SATracking *parentalGateClose = [[SATracking alloc] init];
    parentalGateClose.event = @"pg_close";
    parentalGateClose.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonclose]];
    
    NSDictionary *pgjsonopen = @{
                                 @"sdkVersion":[session getVersion],
                                 @"rnd":@([session getCachebuster]),
                                 @"ct":@([session getConnectivityType]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateOpen"
                                                               } jsonCompactStringRepresentation]]
                                 };
    SATracking *parentalGateOpen = [[SATracking alloc] init];
    parentalGateOpen.event = @"pg_open";
    parentalGateOpen.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonopen]];
    
    NSDictionary *pgjsonsuccess = @{
                                 @"sdkVersion":[session getVersion],
                                 @"rnd":@([session getCachebuster]),
                                 @"ct":@([session getConnectivityType]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateSuccess"
                                                               } jsonCompactStringRepresentation]]
                                 };
    SATracking *parentalGateSuccess = [[SATracking alloc] init];
    parentalGateSuccess.event = @"pg_success";
    parentalGateSuccess.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonsuccess]];
    
    [ad.creative.events addObject:trackingEvt];
    [ad.creative.events addObject:viewableImpression];
    [ad.creative.events addObject:parentalGateSuccess];
    [ad.creative.events addObject:parentalGateOpen];
    [ad.creative.events addObject:parentalGateClose];
    [ad.creative.events addObject:parentalGateFail];
    [ad.creative.events addObject:saImpressionEvt];
    
    // add the impression
    if (ad.creative.impressionUrl != NULL && (NSNull*)ad.creative.impressionUrl != [NSNull null]) {
        SATracking *impression = [[SATracking alloc] init];
        impression.URL = ad.creative.impressionUrl;
        impression.event = @"impression";
        [ad.creative.events addObject:impression];
    }
    
    // add the install
    if (ad.creative.installUrl != NULL && (NSNull*)ad.creative.installUrl != [NSNull null]) {
        SATracking *install = [[SATracking alloc] init];
        install.URL = ad.creative.installUrl;
        install.event = @"install";
        [ad.creative.events addObject:install];
    }
    
    // get the cdn URL
    switch (ad.creative.creativeFormat) {
        case gamewall:
        case image: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.image];
            break;
        }
        case video: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.video];
            break;
        }
        case rich: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.url];
            break;
        }
        case invalid:
        case tag: {break;}
    }
    
    // valdate ad
    if ([ad isValid]) return ad;
    return nil;

}

@end
