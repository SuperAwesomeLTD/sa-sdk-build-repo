//
//  KWSCreatedUser.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
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

@class KWSMetadata;

@interface KWSLoggedUser : SABaseObject <SASerializationProtocol, SADeserializationProtocol, NSCoding>
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) KWSMetadata *metadata;

- (void) setIsRegisteredForNotifications:(BOOL) value;
- (BOOL) isRegisteredForNotifications;

@end
