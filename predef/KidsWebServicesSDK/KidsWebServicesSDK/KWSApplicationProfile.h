//
//  KWSApplicationProfile.h
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import <Foundation/Foundation.h>

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

@interface KWSApplicationProfile : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger avatarId;
@property (nonatomic, assign) NSInteger customField1;
@property (nonatomic, assign) NSInteger customField2;
@property (nonatomic, assign) NSInteger customField3;
@property (nonatomic, assign) NSInteger customField4;
@property (nonatomic, assign) NSInteger customField5;

@end
