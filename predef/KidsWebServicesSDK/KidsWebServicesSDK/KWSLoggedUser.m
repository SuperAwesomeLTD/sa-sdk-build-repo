//
//  KWSCreatedUser.m
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "KWSLoggedUser.h"
#import "KWSMetadata.h"
#import "KWSAux.h"

@interface KWSLoggedUser ()
@property (nonatomic, assign) BOOL isRegisteredForRM;
@end

@implementation KWSLoggedUser

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        _expiresIn = 86400;
        _loginDate = 0;
        
        __id = [[jsonDictionary safeObjectForKey:@"id"] integerValue];
        _username = [jsonDictionary safeObjectForKey:@"username"];
        _parentEmail = [jsonDictionary safeObjectForKey:@"parentEmail"];
        _country = [jsonDictionary safeObjectForKey:@"country"];
        _accessToken = [jsonDictionary safeObjectForKey:@"access_token"];
        _token = [jsonDictionary safeObjectForKey:@"token"];
        _dateOfBirth = [jsonDictionary safeObjectForKey:@"dateOfBirth"];
        _expiresIn = [[jsonDictionary safeObjectForKey:@"expires_in"] integerValue];
        _loginDate = [[jsonDictionary safeObjectForKey:@"loginDate"] integerValue];
        _isRegisteredForRM = [jsonDictionary safeBoolForKey:@"isRegisteredForRM"];
        _metadata = [KWSAux processMetadata:_accessToken];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        __id = [aDecoder decodeIntegerForKey:@"_id"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _parentEmail = [aDecoder decodeObjectForKey:@"parentEmail"];
        _country = [aDecoder decodeObjectForKey:@"country"];
        _accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        _token = [aDecoder decodeObjectForKey:@"token"];
        _dateOfBirth = [aDecoder decodeObjectForKey:@"dateOfBirth"];
        _expiresIn = [aDecoder decodeIntegerForKey:@"expires_in"];
        _loginDate = [aDecoder decodeIntegerForKey:@"loginDate"];
        _isRegisteredForRM = [aDecoder decodeBoolForKey:@"isRegisteredForRM"];
        _metadata = [aDecoder decodeObjectForKey:@"metadata"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:__id forKey:@"_id"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_parentEmail forKey:@"parentEmail"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_accessToken forKey:@"access_token"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_dateOfBirth forKey:@"dateOfBirth"];
    [aCoder encodeInteger:_expiresIn forKey:@"expires_in"];
    [aCoder encodeInteger:_loginDate forKey:@"loginDate"];
    [aCoder encodeBool:_isRegisteredForRM forKey:@"isRegisteredForRM"];
    [aCoder encodeObject:_metadata forKey:@"metadata"];
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"id": @(__id),
        @"username": nullSafe(_username),
        @"parentEmail": nullSafe(_parentEmail),
        @"country": nullSafe(_country),
        @"access_token": nullSafe(_accessToken),
        @"token": nullSafe(_token),
        @"dateOfBirth": nullSafe(_dateOfBirth),
        @"expires_in": @(_expiresIn),
        @"loginDate": @(_loginDate),
        @"isRegisteredForRM": @(_isRegisteredForRM),
        @"metadata": nullSafe([_metadata dictionaryRepresentation])
    };
}

// TODO: this has to be better
- (BOOL) isValid {
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    NSInteger nowMinusExp = now - _expiresIn;
    return nowMinusExp <= _loginDate;
}


- (void) setIsRegisteredForNotifications:(BOOL) value {
    _isRegisteredForRM = value;
}

- (BOOL) isRegisteredForNotifications {
    return _isRegisteredForRM;
}

@end
