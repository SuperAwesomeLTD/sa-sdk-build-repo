//
//  Metadata.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import "KWSMetadata.h"

@implementation KWSMetadata

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        _userId = [[jsonDictionary safeObjectForKey:@"userId"] integerValue];
        _appId = [[jsonDictionary safeObjectForKey:@"appId"] integerValue];
        _clientId = [jsonDictionary safeObjectForKey:@"clientId"];
        _scope = [jsonDictionary safeObjectForKey:@"scope"];
        _iat = [[jsonDictionary safeObjectForKey:@"iat"] integerValue];
        _exp = [[jsonDictionary safeObjectForKey:@"exp"] integerValue];
        _iss = [jsonDictionary safeObjectForKey:@"iss"];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _userId = [aDecoder decodeIntegerForKey:@"userId"];
        _appId = [aDecoder decodeIntegerForKey:@"appId"];
        _clientId = [aDecoder decodeObjectForKey:@"clientId"];
        _scope = [aDecoder decodeObjectForKey:@"scope"];
        _iat = [aDecoder decodeIntegerForKey:@"iat"];
        _exp = [aDecoder decodeIntegerForKey:@"exp"];
        _iss = [aDecoder decodeObjectForKey:@"iss"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_userId forKey:@"userId"];
    [aCoder encodeInteger:_appId forKey:@"appId"];
    [aCoder encodeObject:_clientId forKey:@"clientId"];
    [aCoder encodeObject:_scope forKey:@"scope"];
    [aCoder encodeInteger:_iat forKey:@"iat"];
    [aCoder encodeObject:_iss forKey:@"iss"];
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"userId": @(_userId),
        @"appId": @(_appId),
        @"clientId": nullSafe(_clientId),
        @"scope": nullSafe(_scope),
        @"iat": @(_iat),
        @"exp": @(_exp),
        @"iss": nullSafe(_iss)
    };
}

@end
