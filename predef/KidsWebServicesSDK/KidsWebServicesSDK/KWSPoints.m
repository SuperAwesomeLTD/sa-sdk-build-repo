//
//  KWSPoints.m
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import "KWSPoints.h"

@implementation KWSPoints

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _totalReceived = [[jsonDictionary safeObjectForKey:@"totalReceived"] integerValue];
        _total = [[jsonDictionary safeObjectForKey:@"total"] integerValue];
        _totalPointsReceivedInCurrentApp = [[jsonDictionary safeObjectForKey:@"totalPointsReceivedInCurrentApp"] integerValue];
        _availableBalance = [[jsonDictionary safeObjectForKey:@"availableBalance"] integerValue];
        _pending = [[jsonDictionary safeObjectForKey:@"pending"] integerValue];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"totalReceived": @(_totalReceived),
        @"total": @(_total),
        @"totalPointsReceivedInCurrentApp": @(_totalPointsReceivedInCurrentApp),
        @"availableBalance": @(_availableBalance),
        @"pending": @(_pending)
    };
}

@end
