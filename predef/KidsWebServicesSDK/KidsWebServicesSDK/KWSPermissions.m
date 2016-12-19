//
//  KWSPermissions.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import "KWSPermissions.h"

@implementation KWSPermissions

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _accessAddress = [jsonDictionary safeObjectForKey:@"accessAddress"];
        _accessPhoneNumber = [jsonDictionary safeObjectForKey:@"accessPhoneNumber"];
        _accessFirstName = [jsonDictionary safeObjectForKey:@"accessFirstName"];
        _accessLastName = [jsonDictionary safeObjectForKey:@"accessLastName"];
        _accessEmail = [jsonDictionary safeObjectForKey:@"accessEmail"];
        _accessStreetAddress = [jsonDictionary safeObjectForKey:@"accessStreetAddress"];
        _accessCity = [jsonDictionary safeObjectForKey:@"accessCity"];
        _accessPostalCode = [jsonDictionary safeObjectForKey:@"accessPostalCode"];
        _accessCountry = [jsonDictionary safeObjectForKey:@"accessCountry"];
        _sendPushNotification = [jsonDictionary safeObjectForKey:@"sendPushNotification"];
        _sendNewsletter = [jsonDictionary safeObjectForKey:@"sendNewsletter"];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"accessAddress": nullSafe(_accessAddress),
        @"accessPhoneNumber": nullSafe(_accessPhoneNumber),
        @"accessFirstName": nullSafe(_accessFirstName),
        @"accessLastName": nullSafe(_accessLastName),
        @"accessEmail": nullSafe(_accessEmail),
        @"accessStreetAddress": nullSafe(_accessStreetAddress),
        @"accessCity": nullSafe(_accessCity),
        @"accessPostalCode": nullSafe(_accessPostalCode),
        @"accessCountry": nullSafe(_accessCountry),
        @"sendPushNotification": nullSafe(_sendPushNotification),
        @"sendNewsletter": nullSafe(_sendNewsletter)
    };
}

@end
