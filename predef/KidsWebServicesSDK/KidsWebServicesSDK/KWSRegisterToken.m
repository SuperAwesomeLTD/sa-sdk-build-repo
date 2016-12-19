//
//  KWSSubscribeToken.m
//  Pods
//
//  Created by Gabriel Coman on 28/06/2016.
//
//

#import "KWSRegisterToken.h"
#import "SALogger.h"

@interface KWSRegisterToken ()
@property (nonatomic, strong) registeredToken registeredToken;
@property (nonatomic, strong) NSString *token;
@end

@implementation KWSRegisterToken

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/users/%ld/subscribe-push-notifications", (long)loggedUser.metadata.appId, (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (NSDictionary*) getBody {
    return @{
        @"token": nullSafe(_token),
        @"platform": @"ios"
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    _registeredToken(success && (status == 200 || status == 204));
}

- (void) execute:(NSString*)token :(registeredToken)registeredToken {
    _registeredToken = registeredToken ? registeredToken : ^(BOOL success){};
    _token = token;
    [super execute:_token];
}

@end
