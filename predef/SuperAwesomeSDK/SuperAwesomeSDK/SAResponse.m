//
//  SAResponse.m
//  Pods
//
//  Created by Gabriel Coman on 27/09/2016.
//
//

#import "SAResponse.h"

#import "SAAd.h"

@implementation SAResponse

- (id) init {
    if (self = [super init]){
        [self initDefaults];
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defaults
        [self initDefaults];
        
        // take from json
        _placementId = [jsonDictionary safeIntForKey:@"placementId" orDefault:_placementId];
        _status = [jsonDictionary safeIntForKey:@"status" orDefault:_status];
        _format = [jsonDictionary safeIntForKey:@"format" orDefault:_format];
        
        NSArray *adsArray = [jsonDictionary safeArrayForKey:@"ads" orDefault:@[]];
        _ads = [[[NSArray alloc] initWithJsonArray:adsArray andIterator:^id(id item) {
            return [[SAAd alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
    }
    
    return self;
}

- (void) initDefaults {
    _placementId = 0;
    _status = 0;
    _format = invalid;
    _ads = [@[] mutableCopy];
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"placementId": @(_placementId),
             @"status": @(_status),
             @"format": @(_format),
             @"ads": nullSafe([_ads dictionaryRepresentation])
             };
}

- (BOOL) isValid {
    return [_ads count] > 0;
}

@end
