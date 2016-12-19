//
//  KWSCreateUser.m
//  Pods
//
//  Created by Gabriel Coman on 07/10/2016.
//
//

#import "KWSCreateUser.h"

// created user model
#import "KWSLoggedUser.h"

@interface KWSCreateUser ()
@property (nonatomic, strong) created created;
@property (nonatomic, strong) KWSLoggedUser *userTryingToLogin;
@property (nonatomic, strong) NSString *password;
@end

@implementation KWSCreateUser

- (id) init {
    if (self = [super init]) {
        _created = ^(NSInteger status, KWSLoggedUser* user) {};
    }
    return self;
}

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/users?access_token=%@", (unsigned long)_userTryingToLogin.metadata.appId, _userTryingToLogin.accessToken];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (BOOL) needsLoggedUser {
    return false;
}

- (NSDictionary*) getHeader {
    return @{
        @"Content-Type":@"application/json"
    };
}

- (NSDictionary*) getBody {
    return @{
        @"username": nullSafe(_userTryingToLogin.username),
        @"password": nullSafe(_password),
        @"dateOfBirth": nullSafe(_userTryingToLogin.dateOfBirth),
        @"country": nullSafe(_userTryingToLogin.country),
        @"parentEmail": nullSafe(_userTryingToLogin.parentEmail),
        @"authenticate": [NSNumber numberWithBool:true]
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    
    if (!success) {
        _created(status, nil);
    } else {
        if (status == 201 && payload != nil) {
            
            // create a new logged user that will have a proper OAuth token
            KWSLoggedUser *finalUser = [[KWSLoggedUser alloc] initWithJsonString:payload];
            
            // if all is OK go forward
            if (finalUser && finalUser.token) {
                _created(status, finalUser);
            } else {
                _created(status, nil);
            }
        } else {
            _created(status, nil);
        }
    }
}

- (void) executeWithUser:(KWSLoggedUser*)user andPassword:(NSString*)password :(created) created {
    _created = created ? created : _created;
    _password = password;
    _userTryingToLogin = user;
    [super execute];
    
}

@end
