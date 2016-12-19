//
//  KWSLeader.m
//  Pods
//
//  Created by Gabriel Coman on 28/07/2016.
//
//

#import "KWSLeader.h"

@implementation KWSLeader

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        _rank = [[jsonDictionary safeObjectForKey:@"rank"] integerValue];
        _score = [[jsonDictionary safeObjectForKey:@"score"] integerValue];
        _user = [jsonDictionary safeObjectForKey:@"user"];
    }
    
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"rank": @(_rank),
        @"score": @(_score),
        @"user": nullSafe(_user)
    };
}

@end
