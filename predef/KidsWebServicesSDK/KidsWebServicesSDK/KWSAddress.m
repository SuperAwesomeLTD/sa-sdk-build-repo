//
//  KWSAddress.m
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import "KWSAddress.h"

@implementation KWSAddress

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _street = [jsonDictionary safeObjectForKey:@"street"];
        _city = [jsonDictionary safeObjectForKey:@"city"];
        _postCode = [jsonDictionary safeObjectForKey:@"postCode"];
        _country = [jsonDictionary safeObjectForKey:@"country"];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"street": nullSafe(_street),
        @"city": nullSafe(_city),
        @"postCode": nullSafe(_postCode),
        @"country": nullSafe(_country)
    };
}

@end
