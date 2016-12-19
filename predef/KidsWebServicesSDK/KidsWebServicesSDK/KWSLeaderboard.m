//
//  KWSLeaderboard.m
//  Pods
//
//  Created by Gabriel Coman on 05/08/2016.
//
//

#import "KWSLeaderboard.h"

@implementation KWSLeaderboard

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        _count = [[jsonDictionary safeObjectForKey:@"count"] integerValue];
        _offset = [[jsonDictionary safeObjectForKey:@"offset"] integerValue];
        _limit = [[jsonDictionary safeObjectForKey:@"limit"] integerValue];
        _results = [NSArray arrayWithJsonArray:[jsonDictionary safeObjectForKey:@"results"] andIterator:^id(id item) {
            return [[KWSLeader alloc] initWithJsonDictionary:(NSDictionary*)item];
        }];
    }
    
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"count": @(_count),
        @"offset": @(_offset),
        @"limit": @(_limit),
        @"results": nullSafe([_results dictionaryRepresentation])
    };
}

- (BOOL) isValid {
    return true;
}

@end
