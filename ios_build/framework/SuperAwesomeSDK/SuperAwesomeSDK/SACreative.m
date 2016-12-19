//
//  SACreative.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SACreative.h"

// imports
#import "SATracking.h"
#import "SADetails.h"

@implementation SACreative

- (id) init {
    if (self = [super init]) {
        [self initDefaults];
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defaults
        [self initDefaults];
        
        // take from json
        __id = [jsonDictionary safeIntForKey:@"id" orDefault:__id];
        _name = [jsonDictionary safeStringForKey:@"name" orDefault:_name];
        _cpm = [jsonDictionary safeIntForKey:@"cpm" orDefault:_cpm];
        _format = [jsonDictionary safeStringForKey:@"format" orDefault:_format];
        _creativeFormat = [jsonDictionary safeIntForKey:@"creativeFormat" orDefault:_creativeFormat];
        _customPayload = [jsonDictionary safeStringForKey:@"customPayload" orDefault:_customPayload];
        _live = [jsonDictionary safeBoolForKey:@"live" orDefault:_live];
        _approved = [jsonDictionary safeBoolForKey:@"approved" orDefault:_approved];
        _clickUrl = [jsonDictionary safeStringForKey:@"click_url" orDefault:_clickUrl];
        _impressionUrl = [jsonDictionary safeStringForKey:@"impression_url" orDefault:_impressionUrl];
        _installUrl = [jsonDictionary safeStringForKey:@"installUrl" orDefault:_installUrl];
        _bundleId = [jsonDictionary safeStringForKey:@"bundleId" orDefault:_bundleId];
        
        NSArray *eventsArr = [jsonDictionary safeArrayForKey:@"events" orDefault:@[]];
        _events = [[[NSArray alloc] initWithJsonArray:eventsArr andIterator:^id(id item) {
            return [[SATracking alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
        
        
        NSDictionary *detailsDict = [jsonDictionary safeDictionaryForKey:@"details" orDefault:nil];
        if (detailsDict) {
            _details = [[SADetails alloc] initWithJsonDictionary:detailsDict];
        }
    }
    return self;
}

- (void) initDefaults {
    
    // setup defaults
    __id = 0;
    _name = nil;
    _cpm = 0;
    _format = nil;
    _creativeFormat = invalid;
    _live = true;
    _approved = true;
    _customPayload = nil;
    _clickUrl = nil;
    _installUrl = nil;
    _impressionUrl = nil;
    _bundleId = nil;
    
    // details & events
    _details = [[SADetails alloc] init];
    _events = [@[] mutableCopy];
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"id": @(__id),
             @"name": nullSafe(_name),
             @"cpm": @(_cpm),
             @"format": nullSafe(_format),
             @"creativeFormat": @(_creativeFormat),
             @"customPayload": nullSafe(_customPayload),
             @"live": @(_live),
             @"approved": @(_approved),
             @"click_url": nullSafe(_clickUrl),
             @"impression_url": nullSafe(_impressionUrl),
             @"installUrl": nullSafe(_installUrl),
             @"bundleId": nullSafe(_bundleId),
             @"events": nullSafe([_events dictionaryRepresentation]),
             @"details": nullSafe([_details dictionaryRepresentation])
             };
}

@end
