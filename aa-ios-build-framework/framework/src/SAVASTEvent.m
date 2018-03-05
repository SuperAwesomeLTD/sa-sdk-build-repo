/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVASTEvent.h"

@implementation SAVASTEvent

/**
 * Base init method
 *
 * @return a new instance of the object
 */
- (id) init{
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
        
        // init defs
        [self initDefaults];
        
        // take from json
        _event = [jsonDictionary safeStringForKey:@"event" orDefault:_event];
        _URL = [jsonDictionary safeStringForKey:@"URL" orDefault:_URL];
    }
    return self;
}

/**
 * Overridden "isValid" method from the SADeserializationProtocol protocol
 *
 * @return true or false
 */
- (BOOL) isValid {
    return true;
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
             @"event": nullSafe(_event),
             @"URL": nullSafe(_URL)
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    _event = nil;
    _URL = nil;
}

@end
