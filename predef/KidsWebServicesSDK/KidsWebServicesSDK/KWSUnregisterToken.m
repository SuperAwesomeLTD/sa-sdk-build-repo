//
//  KWSUnsubscribeToken.m
//  Pods
//
//  Created by Gabriel Coman on 28/06/2016.
//
//

#import "KWSUnregisterToken.h"
#import "SALogger.h"

@interface KWSUnregisterToken ()
@property (nonatomic, strong) unregisteredToken unregisteredToken;
@property (nonatomic, strong) NSString *token;
@end

@implementation KWSUnregisterToken

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/users/%ld/unsubscribe-push-notifications", (long)loggedUser.metadata.appId, (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (NSDictionary*) getBody {
    return @{
        @"token":nullSafe(_token)
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    _unregisteredToken (success && (status == 200 || status == 204));
}

- (void) execute:(NSString*)token :(unregisteredToken)unregisteredToken {
    _unregisteredToken = unregisteredToken ? unregisteredToken : ^(BOOL success){};
    _token = token;
    [super execute:_token];
}

@end
