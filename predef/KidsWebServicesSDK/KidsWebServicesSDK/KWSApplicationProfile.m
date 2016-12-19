//
//  KWSApplicationProfile.m
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import "KWSApplicationProfile.h"

@implementation KWSApplicationProfile

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _username = [jsonDictionary safeObjectForKey:@"username"];
        _avatarId = [[jsonDictionary safeObjectForKey:@"avatarId"] integerValue];
        _customField1 = [[jsonDictionary safeObjectForKey:@"customField1"] integerValue];
        _customField2 = [[jsonDictionary safeObjectForKey:@"customField2"] integerValue];
        _customField3 = [[jsonDictionary safeObjectForKey:@"customField3"] integerValue];
        _customField4 = [[jsonDictionary safeObjectForKey:@"customField4"] integerValue];
        _customField5 = [[jsonDictionary safeObjectForKey:@"customField5"] integerValue];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"username": nullSafe(_username),
        @"avatarId": @(_avatarId),
        @"customField1": @(_customField1),
        @"customField2": @(_customField2),
        @"customField3": @(_customField3),
        @"customField4": @(_customField4),
        @"customField5": @(_customField5)
    };
}

@end
