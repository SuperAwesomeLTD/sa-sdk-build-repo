//
//  User.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import "KWSUser.h"
#import "KWSPermissions.h"
#import "KWSPoints.h"
#import "KWSAddress.h"
#import "KWSApplicationProfile.h"

@implementation KWSUser

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        
        __id = [[jsonDictionary safeObjectForKey:@"id"] integerValue];
        _username = [jsonDictionary safeObjectForKey:@"username"];
        _firstName = [jsonDictionary safeObjectForKey:@"firstName"];
        _lastName = [jsonDictionary safeObjectForKey:@"lastName"];
        _dateOfBirth = [jsonDictionary safeObjectForKey:@"dateOfBirth"];
        _gender = [jsonDictionary safeObjectForKey:@"gender"];
        _phoneNumber = [jsonDictionary safeObjectForKey:@"phoneNumber"];
        _language = [jsonDictionary safeObjectForKey:@"language"];
        _email = [jsonDictionary safeObjectForKey:@"email"];
        _applicationPermissions = [[KWSPermissions alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"applicationPermissions"]];
        _points = [[KWSPoints alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"points"]];
        _address = [[KWSAddress alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"address"]];
        _applicationProfile = [[KWSApplicationProfile alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"applicationProfile"]];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"id": @(__id),
        @"username": nullSafe(_username),
        @"firstName": nullSafe(_firstName),
        @"lastName": nullSafe(_lastName),
        @"dateOfBirth": nullSafe(_dateOfBirth),
        @"gender": nullSafe(_gender),
        @"phoneNumber": nullSafe(_phoneNumber),
        @"language": nullSafe(_language),
        @"email": nullSafe(_email),
        @"applicationPermissions": nullSafe([_applicationPermissions dictionaryRepresentation]),
        @"points": nullSafe([_points dictionaryRepresentation]),
        @"address": nullSafe([_address dictionaryRepresentation]),
        @"applicationProfile": nullSafe([_applicationProfile dictionaryRepresentation])
    };
}

@end
