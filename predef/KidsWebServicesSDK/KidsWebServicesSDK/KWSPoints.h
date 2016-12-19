//
//  KWSPoints.h
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

@interface KWSPoints : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger totalReceived;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPointsReceivedInCurrentApp;
@property (nonatomic, assign) NSInteger availableBalance;
@property (nonatomic, assign) NSInteger pending;

@end
