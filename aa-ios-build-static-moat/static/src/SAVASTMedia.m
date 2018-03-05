/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVASTMedia.h"

@implementation SAVASTMedia

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
        
        _type = [jsonDictionary safeStringForKey:@"type" orDefault:_type];
        _url = [jsonDictionary safeStringForKey:@"url" orDefault:_url];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate" orDefault:_bitrate];
        _width = [jsonDictionary safeIntForKey:@"width" orDefault:_width];
        _height = [jsonDictionary safeIntForKey:@"height" orDefault:_height];
    }
    
    return self;
}

/**
 * Overridden "isValid" method from the SADeserializationProtocol protocol
 *
 * @return true or false
 */
- (BOOL) isValid {
    return _url != nil;
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
             @"type": nullSafe(_type),
             @"url": nullSafe(_url),
             @"bitrate": @(_bitrate),
             @"width": @(_width),
             @"height": @(_height)
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    _type = nil;
    _url = nil;
    _bitrate = 0;
    _width = 0;
    _height = 0;
}

@end
