//
//  KWSOAuthService.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "KWSService.h"

@class KWSAccessToken;

typedef void (^gotAccessTokenCreate)(KWSAccessToken* accessToken);

@interface KWSGetAccessTokenCreate : KWSService
- (void) execute:(gotAccessTokenCreate) gotAccessTokenCreate;
@end
