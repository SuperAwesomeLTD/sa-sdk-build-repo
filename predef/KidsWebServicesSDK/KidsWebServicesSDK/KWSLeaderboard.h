//
//  KWSLeaderboard.h
//  Pods
//
//  Created by Gabriel Coman on 05/08/2016.
//
//

#import <Foundation/Foundation.h>
#import "KWSLeader.h"
#import "SAJsonParser.h"

@interface KWSLeaderboard : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, strong) NSArray<KWSLeader*> *results;
@end
