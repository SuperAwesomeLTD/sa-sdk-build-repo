/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SADetails.h"
#import "SAMedia.h"

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

@implementation SADetails

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
        
        // take from JSON
        _width = [jsonDictionary safeIntForKey:@"width" orDefault:_width];
        _height = [jsonDictionary safeIntForKey:@"height" orDefault:_height];
        _name = [jsonDictionary safeStringForKey:@"name" orDefault:_name];
        _format = [jsonDictionary safeStringForKey:@"placement_format" orDefault:_format];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate" orDefault:_bitrate];
        _duration = [jsonDictionary safeIntForKey:@"duration" orDefault:_duration];
        _value = [jsonDictionary safeIntForKey:@"value" orDefault:_value];
        
        _image = [jsonDictionary safeStringForKey:@"image" orDefault:_image];
        _video = [jsonDictionary safeStringForKey:@"video" orDefault:_video];
        _vast = [jsonDictionary safeStringForKey:@"vast" orDefault:_vast];
        _tag = [jsonDictionary safeStringForKey:@"tag" orDefault:_tag];
        _zip = [jsonDictionary safeStringForKey:@"zipFile" orDefault:_zip];
        _url = [jsonDictionary safeStringForKey:@"url" orDefault:_url];
        
        _cdn = [jsonDictionary safeStringForKey:@"cdn" orDefault:_cdn];
        if (_cdn == nil) _cdn = [SAUtils findBaseURLFromResourceURL:_image];
        if (_cdn == nil) _cdn = [SAUtils findBaseURLFromResourceURL:_video];
        if (_cdn == nil) _cdn = [SAUtils findBaseURLFromResourceURL:_url];
        
        NSDictionary *mediaDict = [jsonDictionary safeDictionaryForKey:@"media" orDefault:nil];
        if (mediaDict) {
            _media = [[SAMedia alloc] initWithJsonDictionary:mediaDict];
        }
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
             @"width": @(_width),
             @"height": @(_height),
             @"name": nullSafe(_name),
             @"placement_format": nullSafe(_format),
             @"bitrate": @(_bitrate),
             @"duration": @(_duration),
             @"value": @(_value),
             @"image": nullSafe(_image),
             @"video": nullSafe(_video),
             @"vast": nullSafe(_vast),
             @"tag": nullSafe(_tag),
             @"zipFile": nullSafe(_zip),
             @"url": nullSafe(_url),
             @"cdn": nullSafe(_cdn),
             @"base": nullSafe(_base),
             @"media": nullSafe([_media dictionaryRepresentation])
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    
    // setup defaults
    _width = 0;
    _height = 0;
    _name = nil;
    _format = nil;
    _bitrate = 0;
    _duration = 0;
    _value = 0;
    _image = nil;
    _video = nil;
    _tag = nil;
    _zip = nil;
    _url = nil;
    _cdn = nil;
    _vast = nil;
    _base = nil;
    
    // media
    _media = [[SAMedia alloc] init];
}

@end
