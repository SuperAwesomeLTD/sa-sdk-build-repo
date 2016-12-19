//
//  SATracking.m
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

#import "SATracking.h"

@implementation SATracking

- (id) init{
    if (self = [super init]){
        [self initDefaults];
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defs
        [self initDefaults];
        
        // take from json
        _event = [jsonDictionary safeStringForKey:@"event" orDefault:_event];
        _URL = [jsonDictionary safeStringForKey:@"URL" orDefault:_URL];
    }
    return self;
}

- (void) initDefaults {
    _event = nil;
    _URL = nil;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"event": nullSafe(_event),
             @"URL": nullSafe(_URL)
             };
}

@end
