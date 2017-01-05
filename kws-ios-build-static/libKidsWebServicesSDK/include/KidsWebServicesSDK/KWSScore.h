//
//  KWSScore.h
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

@interface KWSScore : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger score;
@end
