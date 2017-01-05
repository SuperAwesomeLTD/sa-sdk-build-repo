//
//  KWSAuthUser.h
//  Pods
//
//  Created by Gabriel Coman on 11/10/2016.
//
//

#import "KWSService.h"

@class KWSAccessToken;

typedef void (^gotAccessTokenAuth)(KWSAccessToken* accessToken);

@interface KWSGetAccessTokenAuth : KWSService
- (void) execute:(NSString*)username andPassword:(NSString*)password :(gotAccessTokenAuth) gotAccessTokenAuth;
@end
