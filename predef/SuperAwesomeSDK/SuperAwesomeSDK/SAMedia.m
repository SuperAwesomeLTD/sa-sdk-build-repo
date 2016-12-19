//
//  SAMedia.m
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

#import "SAMedia.h"

@implementation SAMedia

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
        _html = [jsonDictionary safeStringForKey:@"html" orDefault:_html];
        _playableDiskUrl = [jsonDictionary safeStringForKey:@"playableDiskUrl" orDefault:_playableDiskUrl];
        _playableMediaUrl = [jsonDictionary safeStringForKey:@"playableMediaUrl" orDefault:_playableMediaUrl];
        _type = [jsonDictionary safeStringForKey:@"type" orDefault:_type];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate" orDefault:_bitrate];
        _isOnDisk = [jsonDictionary safeBoolForKey:@"isOnDisk" orDefault:_isOnDisk];
    }
    return self;
}

- (void) initDefaults {
    // set defaults
    _html = nil;
    _playableDiskUrl = nil;
    _playableMediaUrl = nil;
    _type = nil;
    _bitrate = 0;
    _isOnDisk = false;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"html": nullSafe(_html),
             @"playableDiskUrl": nullSafe(_playableDiskUrl),
             @"playableMediaUrl": nullSafe(_playableMediaUrl),
             @"type": nullSafe(_type),
             @"bitrate": @(_bitrate),
             @"isOnDisk": @(_isOnDisk)
             };
}

@end
