//
//  KWSCreatedUser.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "SAJsonParser.h"

@class KWSMetadata;

@interface KWSLoggedUser : SABaseObject <SASerializationProtocol, SADeserializationProtocol, NSCoding>
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *parentEmail;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSInteger expiresIn;
@property (nonatomic, assign) NSInteger loginDate;
@property (nonatomic, strong) KWSMetadata *metadata;

- (void) setIsRegisteredForNotifications:(BOOL) value;
- (BOOL) isRegisteredForNotifications;

@end
