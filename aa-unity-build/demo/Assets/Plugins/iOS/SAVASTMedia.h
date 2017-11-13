/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/SABaseObject.h>)
#import <SAJsonParser/SABaseObject.h>
#else
#import "SABaseObject.h"
#endif
#endif

/**
 * Class that represents a VAST media object, containing:
 *  - a type (mp4, wav, etc)
 *  - a media Url
 *  - bitrate
 *  - width and height
 */
@interface SAVASTMedia : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, strong) NSString  *type;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end
