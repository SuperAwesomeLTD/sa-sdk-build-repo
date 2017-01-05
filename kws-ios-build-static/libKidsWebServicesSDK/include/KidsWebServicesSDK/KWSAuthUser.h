//
//  KWSAuthUser.h
//  Pods
//
//  Created by Gabriel Coman on 11/10/2016.
//
//

#import "KWSService.h"
@class KWSLoggedUser;

typedef void (^authenticated)(NSInteger status, KWSLoggedUser *user);

@interface KWSAuthUser : KWSService

- (void) executeWithToken: (NSString*)token :(authenticated)authenticated;

@end
