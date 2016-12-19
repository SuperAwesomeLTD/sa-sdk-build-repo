//
//  KWSEventStatus.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "SAJsonParser.h"

@interface KWSEventStatus : SABaseObject <SADeserializationProtocol, SASerializationProtocol>
@property (nonatomic, assign) BOOL hasTriggeredEvent;
@end
