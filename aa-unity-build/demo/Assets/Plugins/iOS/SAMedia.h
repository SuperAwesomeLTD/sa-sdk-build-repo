/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */


#import <UIKit/UIKit.h>

@class SAVASTAd;

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
 * Class that defines a media element to be played
 * Most important elements contained are:
 *  - a html string to be rendered into a web view
 *  - a disk & media url for a video
 */
@interface SAMedia : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, strong) NSString  *html;
@property (nonatomic, strong) NSString  *path;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) BOOL      isDownloaded;
@property (nonatomic, strong) SAVASTAd  *vastAd;

@end
