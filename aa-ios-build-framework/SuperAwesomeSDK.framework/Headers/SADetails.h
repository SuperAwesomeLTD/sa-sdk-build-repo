/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAMedia;

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
 * Class that contains details about a creative, such as:
 *  - width, height
 *  - name
 *  - format
 *  - bitrate, duration, value (for video; not really used)
 *  - image, video, tag, url, vast - needed to describe the location of the creative (whether
 *    rich media, video, 3rd party tag, etc)
 *  - cdnUrl & zipFile (not really used)
 *  - a SAMedia object
 *
 */
@interface SADetails : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *format;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString  *image;
@property (nonatomic, strong) NSString  *video;
@property (nonatomic, strong) NSString  *tag;
@property (nonatomic, strong) NSString  *zip;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *cdn;
@property (nonatomic, strong) NSString  *base;
@property (nonatomic, strong) NSString  *vast;
@property (nonatomic, strong) SAMedia   *media;

@end
