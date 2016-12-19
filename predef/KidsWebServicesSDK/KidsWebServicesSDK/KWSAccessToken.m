//
//  KWSTokenResponse.m
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "KWSAccessToken.h"

@implementation KWSAccessToken

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        _token_type = [jsonDictionary objectForKey:@"token_type"];
        _access_token = [jsonDictionary objectForKey:@"access_token"];
        _expires_in = [[jsonDictionary objectForKey:@"expires_in"] integerValue];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _token_type = [aDecoder decodeObjectForKey:@"token_type"];
        _access_token = [aDecoder decodeObjectForKey:@"access_token"];
        _expires_in = [aDecoder decodeIntegerForKey:@"expires_in"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_token_type forKey:@"token_type"];
    [aCoder encodeObject:_access_token forKey:@"access_token"];
    [aCoder encodeInteger:_expires_in forKey:@"expires_in"];
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"token_type": nullSafe(_token_type),
        @"access_token": nullSafe(_access_token),
        @"expires_in": @(_expires_in)
    };
}

@end
