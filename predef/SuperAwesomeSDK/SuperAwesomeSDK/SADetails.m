//
//  SADetails.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import "SADetails.h"

@implementation SADetails

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
        
        // take from JSON
        _width = [jsonDictionary safeIntForKey:@"width" orDefault:_width];
        _height = [jsonDictionary safeIntForKey:@"height" orDefault:_height];
        _name = [jsonDictionary safeStringForKey:@"name" orDefault:_name];
        _placementFormat = [jsonDictionary safeStringForKey:@"placement_format" orDefault:_placementFormat];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate" orDefault:_bitrate];
        _duration = [jsonDictionary safeIntForKey:@"duration" orDefault:_duration];
        _value = [jsonDictionary safeIntForKey:@"value" orDefault:_value];
        
        _image = [jsonDictionary safeStringForKey:@"image" orDefault:_image];
        _video = [jsonDictionary safeStringForKey:@"video" orDefault:_video];
        _vast = [jsonDictionary safeStringForKey:@"vast" orDefault:_vast];
        _tag = [jsonDictionary safeStringForKey:@"tag" orDefault:_tag];
        _zipFile = [jsonDictionary safeStringForKey:@"zipFile" orDefault:_zipFile];
        _url = [jsonDictionary safeStringForKey:@"url" orDefault:_url];
        _cdnUrl = [jsonDictionary safeStringForKey:@"cdnUrl" orDefault:_cdnUrl];
        
        NSDictionary *mediaDict = [jsonDictionary safeDictionaryForKey:@"media" orDefault:nil];
        if (mediaDict) {
            _media = [[SAMedia alloc] initWithJsonDictionary:mediaDict];
        }
    }
    return self;
}

- (void) initDefaults {
    
    // setup defaults
    _width = 0;
    _height = 0;
    _name = nil;
    _placementFormat = nil;
    _bitrate = 0;
    _duration = 0;
    _value = 0;
    _image = nil;
    _video = nil;
    _tag = nil;
    _zipFile = nil;
    _url = nil;
    _cdnUrl = nil;
    _vast = nil;
    
    // media
    _media = [[SAMedia alloc] init];
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"width": @(_width),
             @"height": @(_height),
             @"name": nullSafe(_name),
             @"placement_format": nullSafe(_placementFormat),
             @"bitrate": @(_bitrate),
             @"duration": @(_duration),
             @"value": @(_value),
             @"image": nullSafe(_image),
             @"video": nullSafe(_video),
             @"vast": nullSafe(_vast),
             @"tag": nullSafe(_tag),
             @"zipFile": nullSafe(_zipFile),
             @"url": nullSafe(_url),
             @"cdnUrl": nullSafe(_cdnUrl),
             @"media": nullSafe([_media dictionaryRepresentation])
             };
}

@end
