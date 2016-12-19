//
//  KWSAppData.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSAppData.h"

@implementation KWSAppData

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        _name = [jsonDictionary safeObjectForKey:@"name"];
        _value = [[jsonDictionary safeObjectForKey:@"value"] integerValue];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"name": nullSafe(_name),
             @"value": @(_value)
             };
}

- (BOOL) isValid {
    return true;
}

@end
