//
//  KWSEventStatus.m
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSEventStatus.h"


@implementation KWSEventStatus

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _hasTriggeredEvent = [[jsonDictionary objectForKey:@"hasTriggeredEvent"] boolValue];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"hasTriggeredEvent": @(_hasTriggeredEvent)
             };
}

@end
