//
//  SADetails.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

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

// local import
#import "SAMedia.h"

@interface SADetails : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placementFormat;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *zipFile;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *cdnUrl;
@property (nonatomic, strong) NSString *vast;

@property (nonatomic, strong) SAMedia *media;

@end
