//
//  KWSLeader.h
//  Pods
//
//  Created by Gabriel Coman on 28/07/2016.
//
//

#import <UIKit/UIKit.h>

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

@interface KWSLeader : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *user;

@end
