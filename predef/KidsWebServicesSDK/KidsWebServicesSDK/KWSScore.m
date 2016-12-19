//
//  KWSScore.m
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSScore.h"

@implementation KWSScore

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _rank = [[jsonDictionary safeObjectForKey:@"rank"] integerValue];
        _score = [[jsonDictionary safeObjectForKey:@"score"] integerValue];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"rank": @(_rank),
             @"score": @(_score)
             };
}

@end
