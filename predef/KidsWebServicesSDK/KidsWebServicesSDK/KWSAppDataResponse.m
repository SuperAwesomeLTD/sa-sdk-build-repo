//
//  KWSAppDataResponse.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSAppDataResponse.h"

#import "KWSAppData.h"

@implementation KWSAppDataResponse

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        _count = [[jsonDictionary safeObjectForKey:@"count"] integerValue];
        _limit = [[jsonDictionary safeObjectForKey:@"limit"] integerValue];
        _offset = [[jsonDictionary safeObjectForKey:@"offset"] integerValue];
        _results = [NSArray arrayWithJsonArray:[jsonDictionary safeObjectForKey:@"results"] andIterator:^id(id item) {
            return [[KWSAppData alloc] initWithJsonDictionary:(NSDictionary*)item];
        }];
    }
    
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"count": @(_count),
             @"limit": @(_limit),
             @"offset": @(_offset),
             @"results": nullSafe([_results dictionaryRepresentation])
             };
}

- (BOOL) isValid {
    return true;
}

@end
