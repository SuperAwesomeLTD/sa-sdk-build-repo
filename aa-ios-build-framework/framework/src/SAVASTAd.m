/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVASTAd.h"
#import "SAVASTEvent.h"
#import "SAVASTMedia.h"

@implementation SAVASTAd

/**
 * Base init method
 *
 * @return a new instance of the object
 */
- (id) init {
    if (self = [super init]) {
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
        
        // get simple strings
        _redirect = [jsonDictionary safeStringForKey:@"redirect" orDefault:_redirect];
        _url = [jsonDictionary safeStringForKey:@"url" orDefault:_url];
        
        // read the vast type
        NSInteger type = [jsonDictionary safeIntForKey:@"type" orDefault:0];
        _type = getSAVASTAdTypeFromInt(type);
        
        // get array of media
        NSArray *media = [jsonDictionary safeArrayForKey:@"media" orDefault:@[]];
        _media = [[[NSArray alloc] initWithJsonArray:media andIterator:^id(id item) {
            return [[SAVASTMedia alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
        
        // get array of events
        NSArray *events = [jsonDictionary safeArrayForKey:@"events" orDefault:@[]];
        _events = [[[NSArray alloc] initWithJsonArray:events andIterator:^id(id item) {
            return [[SAVASTEvent alloc] initWithJsonDictionary:(NSDictionary*)item];
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
    return _url != nil && _type != SA_Invalid_VAST && [_media count] >= 1;
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
             @"redirect": nullSafe(_redirect),
             @"url": nullSafe(_url),
             @"type": @(_type),
             @"media": nullSafe([_media dictionaryRepresentation]),
             @"events": nullSafe([_events dictionaryRepresentation])
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    _redirect = nil;
    _type = SA_Invalid_VAST;
    _media = nil;
    _media = [@[] mutableCopy];
    _events = [@[] mutableCopy];
}

- (void) sumAd:(SAVASTAd *)toBeAdded {
    _url = toBeAdded.url ? toBeAdded.url : _url;
    [_events addObjectsFromArray:toBeAdded.events];
    [_media addObjectsFromArray:toBeAdded.media];
}

@end
