//
//  KWSAppData.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
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

@interface KWSAppData : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger value;
@end
