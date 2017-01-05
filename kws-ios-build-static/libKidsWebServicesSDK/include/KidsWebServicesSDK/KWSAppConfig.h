//
//  KWSAppConfig.h
//  Pods
//
//  Created by Gabriel Coman on 04/01/2017.
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

@interface KWSAppConfig : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, assign) NSInteger _id;
@end
