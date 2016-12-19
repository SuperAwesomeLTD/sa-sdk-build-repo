//
//  SACreative.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

// forward decl
@class SATracking;
@class SADetails;

// guarded import
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

// creative format typedef
typedef NS_ENUM(NSInteger, SACreativeFormat) {
    invalid = -1,
    image = 0,
    video = 1,
    rich = 2,
    tag = 3,
    gamewall = 4
};

// @brief:
// The creative contains essential ad information like format, click url
// and such
@interface SACreative : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger cpm;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) SACreativeFormat creativeFormat;
@property (nonatomic, assign) BOOL live;
@property (nonatomic, assign) BOOL approved;
@property (nonatomic, strong) NSString *customPayload;
@property (nonatomic, strong) NSString *clickUrl;
@property (nonatomic, strong) NSString *installUrl;
@property (nonatomic, strong) NSString *impressionUrl;
@property (nonatomic, strong) NSString *bundleId;
@property (nonatomic, strong) NSMutableArray<SATracking*> *events;

@property (nonatomic, strong) SADetails *details;

@end
