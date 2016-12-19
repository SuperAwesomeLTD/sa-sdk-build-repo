//
//  SATracking.h
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

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

@interface SATracking : SABaseObject <SADeserializationProtocol, SASerializationProtocol>
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *URL;
@end
