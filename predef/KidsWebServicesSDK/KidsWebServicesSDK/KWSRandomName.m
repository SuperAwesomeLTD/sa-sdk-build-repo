//
//  KWSRandomName.m
//  Pods
//
//  Created by Gabriel Coman on 20/12/2016.
//
//

#import "KWSRandomName.h"

@interface KWSRandomName ()
@property (nonatomic, strong) gotRandomName gotName;
@end

@implementation KWSRandomName

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v2/apps/%ld/random-display-name", appId];
}

- (KWS_HTTP_METHOD) getMethod {
    return GET;
}

- (NSDictionary*) getHeader {
    return @{};
}

- (BOOL) needsLoggedUser {
    return false;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    
    if (!success) {
        _gotName (nil);
    } else {
        if (status == 200 && payload != nil) {
            _gotName ([payload stringByReplacingOccurrencesOfString:@"\"" withString:@""]);
        } else {
            _gotName (nil);
        }
    }
}

- (void) execute:(gotRandomName)gotName {
    _gotName = gotName ? gotName : ^(NSString*name){};
    [super execute];
}

@end
