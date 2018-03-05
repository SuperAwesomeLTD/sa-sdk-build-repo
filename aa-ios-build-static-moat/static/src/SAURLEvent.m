/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAURLEvent.h"

@interface SAURLEvent ()
@property (nonatomic, strong) NSString *vastUrl;
@end

@implementation SAURLEvent

- (id) initWithUrl: (NSString*) vastUrl {
    if (self = [super initWithAd:nil andSession:nil]) {
        _vastUrl = vastUrl;
    }
    
    return self;
}

- (NSString*) getUrl {
    return _vastUrl;
}

- (NSString*) getEndpoint {
    return @"";
}

@end
