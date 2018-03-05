/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAResponse.h"
#import "SAAd.h"

@implementation SAResponse

/**
 * Base init method
 *
 * @return a new instance of the object
 */
- (id) init {
    if (self = [super init]){
        [self initDefaults];
    }
    return self;
}

/**
 * Overridden "initWithJsonDictionary" init method from the
 * SADeserializationProtocol protocol that describes how this model gets
 * initialised from the fields of a NSDictionary object (create from a
 * JSON string)
 *
 * @return a new instance of the object
 */
- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defaults
        [self initDefaults];
        
        // take from json
        _placementId = [jsonDictionary safeIntForKey:@"placementId" orDefault:_placementId];
        _status = [jsonDictionary safeIntForKey:@"status" orDefault:_status];
        
        NSInteger format = [jsonDictionary safeIntForKey:@"format" orDefault:0];
        _format = getSACreativeFormatFromInt(format);
        
        NSArray *adsArray = [jsonDictionary safeArrayForKey:@"ads" orDefault:@[]];
        _ads = [[[NSArray alloc] initWithJsonArray:adsArray andIterator:^id(id item) {
            return [[SAAd alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
    }
    
    return self;
}

/**
 * Overridden "isValid" method from the SADeserializationProtocol protocol
 *
 * @return true or false
 */
- (BOOL) isValid {
    BOOL allAdsValid = true;
    
    for (SAAd *ad in _ads) {
        if (![ad isValid]) {
            allAdsValid = false;
            break;
        }
    }
    
    return [_ads count] > 0 && allAdsValid;
}

/**
 * Overridden "dictionaryRepresentation" method from the
 * SADeserializationProtocol protocol that describes how this model is
 * going to get translated to a dictionary
 *
 * @return a NSDictionary object representing all the members of this object
 */
- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"placementId": @(_placementId),
             @"status": @(_status),
             @"format": @(_format),
             @"ads": nullSafe([_ads dictionaryRepresentation])
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    _placementId = 0;
    _status = 0;
    _format = SA_Invalid;
    _ads = [@[] mutableCopy];
}

@end
