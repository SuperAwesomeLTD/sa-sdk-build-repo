//
//  User.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
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

@class KWSPermissions;
@class KWSAddress;
@class KWSPoints;
@class KWSApplicationProfile;

/**
 *  Represents a basic user profile in KWS
 */
@interface KWSUser : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) KWSAddress *address;
@property (nonatomic, strong) KWSPoints *points;
@property (nonatomic, strong) KWSPermissions *applicationPermissions;
@property (nonatomic, strong) KWSApplicationProfile *applicationProfile;

@end
