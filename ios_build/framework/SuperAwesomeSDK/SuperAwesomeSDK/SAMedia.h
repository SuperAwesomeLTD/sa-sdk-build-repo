//
//  SAMedia.h
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

// guarded import
#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

@interface SAMedia : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *playableDiskUrl;
@property (nonatomic, strong) NSString *playableMediaUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) BOOL isOnDisk;
@end
