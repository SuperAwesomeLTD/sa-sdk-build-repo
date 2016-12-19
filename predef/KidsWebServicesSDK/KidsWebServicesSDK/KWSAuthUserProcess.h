//
//  KWSAuthUserProcess.h
//  Pods
//
//  Created by Gabriel Coman on 11/10/2016.
//
//

#import <Foundation/Foundation.h>

// create user status
typedef NS_ENUM(NSInteger, KWSAuthUserStatus) {
    KWSAuthUser_Success             = 0,
    KWSAuthUser_NetworkError        = 1,
    KWSAuthUser_InvalidCredentials  = 2
};

typedef void (^userAuthenticated)(KWSAuthUserStatus status);

@interface KWSAuthUserProcess : NSObject

- (void) authWithUsername:(NSString*)username
              andPassword:(NSString*)password
                         :(userAuthenticated)userAuthenticated;

@end
