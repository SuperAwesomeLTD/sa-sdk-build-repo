//
//  KWSPoints.h
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAJsonParser.h"

@interface KWSPoints : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger totalReceived;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPointsReceivedInCurrentApp;
@property (nonatomic, assign) NSInteger availableBalance;
@property (nonatomic, assign) NSInteger pending;

@end
