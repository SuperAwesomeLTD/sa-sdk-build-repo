//
//  KWSEventStatus.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

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

@interface KWSEventStatus : SABaseObject <SADeserializationProtocol, SASerializationProtocol>
@property (nonatomic, assign) BOOL hasTriggeredEvent;
@end
