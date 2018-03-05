/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAMedia.h"
#import "SAVASTAd.h"

@implementation SAMedia

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
        
        // take from json
        _html = [jsonDictionary safeStringForKey:@"html" orDefault:_html];
        _path = [jsonDictionary safeStringForKey:@"path" orDefault:_path];
        _url = [jsonDictionary safeStringForKey:@"url" orDefault:_url];
        _type = [jsonDictionary safeStringForKey:@"type" orDefault:_type];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate" orDefault:_bitrate];
        _isDownloaded = [jsonDictionary safeBoolForKey:@"isDownloaded" orDefault:_isDownloaded];
        
        NSDictionary *vastDict = [jsonDictionary safeDictionaryForKey:@"vastAd" orDefault:nil];
        if (vastDict) {
            _vastAd = [[SAVASTAd alloc] initWithJsonDictionary:vastDict];
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
             @"html": nullSafe(_html),
             @"path": nullSafe(_path),
             @"url": nullSafe(_url),
             @"type": nullSafe(_type),
             @"bitrate": @(_bitrate),
             @"isDownloaded": @(_isDownloaded),
             @"vastAd": nullSafe([_vastAd dictionaryRepresentation])
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    _html = nil;
    _path = nil;
    _url = nil;
    _type = nil;
    _bitrate = 0;
    _isDownloaded = false;
    _vastAd = [[SAVASTAd alloc] init];
}

@end
