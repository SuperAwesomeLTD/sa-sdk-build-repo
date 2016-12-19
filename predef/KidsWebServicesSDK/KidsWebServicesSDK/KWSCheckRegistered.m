//
//  KWSCheckRegistered.m
//  Pods
//
//  Created by Gabriel Coman on 14/07/2016.
//
//

// header
#import "KWSCheckRegistered.h"

@interface KWSCheckRegistered ()
@property (nonatomic, strong) checkRegistered checkRegistered;
@end

@implementation KWSCheckRegistered

- (id) init {
    if (self = [super init]) {
        _checkRegistered = ^(BOOL registered) {};
    }
    
    return self;
}

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/users/%ld/has-device-token", (long)loggedUser.metadata.appId, (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return GET;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _checkRegistered(false);
    } else {
        if ([payload isEqualToString:@"true"]) {
            _checkRegistered(true);
        } else if ([payload isEqualToString:@"false"]) {
            _checkRegistered(false);
        } else {
            _checkRegistered(false);
        }
    }
}

- (void) execute:(checkRegistered)checkRegistered {
    _checkRegistered = checkRegistered ? checkRegistered : _checkRegistered;
    [super execute];
}

@end
