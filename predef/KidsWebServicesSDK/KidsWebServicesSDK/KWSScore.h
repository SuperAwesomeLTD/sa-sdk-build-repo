//
//  KWSScore.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "SAJsonParser.h"

@interface KWSScore : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger score;
@end
