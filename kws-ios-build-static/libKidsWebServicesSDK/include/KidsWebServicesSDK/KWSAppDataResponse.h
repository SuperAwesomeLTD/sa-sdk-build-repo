//
//  KWSAppDataResponse.h
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

@class KWSAppData;

@interface KWSAppDataResponse : SABaseObject <SADeserializationProtocol, SASerializationProtocol>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSArray<KWSAppData*> *results;
@end
