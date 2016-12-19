//
//  SALoader.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header
#import "SALoader.h"

// guard external imports
#if defined(__has_include)
#if __has_include(<SAModelSpace/SAModelSpace.h>)
#import <SAModelSpace/SAModelSpace.h>
#else
#import "SAModelSpace.h"
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
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SANetwork/SANetwork.h>)
#import <SANetwork/SANetwork.h>
#else
#import "SANetwork.h"
#endif
#endif

// import from local
#import "SAAdParser.h"
#import "SAHTMLParser.h"
#import "SAVASTParser.h"
#import "SAAppWallParser.h"

@interface SALoader ()
@property (nonatomic, strong) SAAdParser *adParser;
@end

@implementation SALoader

- (id) init {
    if (self = [super init]) {
        _adParser = [[SAAdParser alloc] init];
    }
    
    return self;
}

- (void) loadAd:(NSInteger)placementId
    withSession:(SASession *)session
      andResult:(didLoadAd)result  {
    
    // get a reference to the result callback
    __block didLoadAd res = result != NULL ? result : ^(SAResponse* response) {};
    
    // First thing to do is format the AA URL to get an ad, based on specs
    NSString *endpoint = [NSString stringWithFormat:@"%@/ad/%ld", [session getBaseUrl], (long)placementId];
    
    // form the query
    NSDictionary *query = @{@"test": @([session getTestMode]),
                            @"sdkVersion":[session getVersion],
                            @"rnd":@([session getCachebuster]),
                            @"ct":@([session getConnectivityType]),
                            @"bundle":[session getBundleId],
                            @"name":[session getAppName],
                            @"dauid":@([session getDauId]),
                            @"lang": [session getLang],
                            @"device": [session getDevice]
                            // @"preload": @(true)
                            };
    
    // form the header
    NSDictionary *header = @{@"Content-Type":@"application/json",
                             @"User-Agent":[session getUserAgent]};
    
    SARequest *request= [[SARequest alloc] init];
    [request sendGET:endpoint
           withQuery:query
           andHeader:header
        withResponse:^(NSInteger status, NSString *payload, BOOL success) {
            
            // create the response
            __block SAResponse *response = [[SAResponse alloc] init];
            response.status = status;
            response.placementId = placementId;
            
            
            if (!success) {
                res(response);
            } else {
                
                // get the data
                NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                id jsonResult =  [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
                
                // guard against JSON errors of any kind
                if (error != nil) {
                    res(response);
                    return;
                }
                
                if ([jsonResult isKindOfClass:[NSDictionary class]]) {
                    
                    // parse the Ad
                    __block SAAd *parsedAd = [_adParser parseInitialAdFromNetwork:payload
                                                                  withPlacementId:placementId
                                                                       andSession:session];
                    
                    if (!parsedAd) {
                        res(response);
                    }
                    // and get extra data
                    else {
                        
                        // get the format
                        SACreativeFormat type = parsedAd.creative.creativeFormat;
                        
                        // finally, if ad is OK, add an Ad to the response
                        [response.ads addObject:parsedAd];
                        response.format = type;
                        
                        switch (type) {
                            // empty gamewall will also be a dictionary!
                            case gamewall:{
                                [response.ads removeAllObjects];
                                res(response);
                                break;
                            }
                            // parse video
                            case video: {
                                SAVASTParser *vastParser = [[SAVASTParser alloc] init];
                                [vastParser parseVASTURL:parsedAd.creative.details.vast
                                             withSession:session
                                                    done:^(SAAd *vastAd) {
                                    [parsedAd sumAd:vastAd];
                                    res(response);
                                }];
                                break;
                            }
                            // parse HTML data
                            case image:
                            case rich:
                            case tag:
                            case invalid: {
                                parsedAd.creative.details.media = [[SAMedia alloc] init];
                                parsedAd.creative.details.media.html = [SAHTMLParser formatCreativeDataIntoAdHTML:parsedAd];
                                res(response);
                                break;
                            }
                        }
                    }
                    
                } else if ([jsonResult isKindOfClass:[NSArray class]]) {
                    
                    // transform to array
                    NSArray *jsonArray = (NSArray*)jsonResult;
                    
                    // set format as gamewall
                    response.format = gamewall;
                    
                    for (int i = 0; i < [jsonArray count]; i++) {
                        // try to parse the Ad
                        id jsonObject = [jsonArray objectAtIndex:i];
                        
                        // try to decypher the Ad data and add it to the response
                        if (jsonObject != NULL && [jsonObject isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *jsonDict = (NSDictionary*) jsonObject;
                            NSString *jsonString = [jsonDict jsonPreetyStringRepresentation];
                            
                            __block SAAd *parsedAd = [_adParser parseInitialAdFromNetwork:jsonString
                                                                          withPlacementId:placementId
                                                                               andSession:session];
                            parsedAd.creative.details.media = [[SAMedia alloc] init];
                            
                            // add to the response
                            if (parsedAd != NULL && parsedAd.creative.creativeFormat == image) {
                                [response.ads addObject:parsedAd];
                            }
                        }
                    }
                    
                    // now download the results
                    SAAppWallParser *aooWallParser = [[SAAppWallParser alloc] init];
                    [aooWallParser getAppWallResourcesForAds:response.ads andCallback:^{
                        res(response);
                    }];
                    
                } else {
                    res (response);
                }
            }
        }];
}

@end
