//
//  KWSCheckPermission.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

// header
#import "KWSCheckAllowed.h"

// aux
#import "KWS.h"
#import "SANetwork.h"
#import "SALogger.h"

// models
#import "KWSUser.h"
#import "KWSPermissions.h"

@interface KWSCheckAllowed ()
@property (nonatomic, strong) checkAllowed checkAllowed;
@end

@implementation KWSCheckAllowed

- (id) init {
    if (self = [super init]) {
        _checkAllowed = ^(BOOL allowed){};
        
    }
    
    return self;
}

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/users/%ld", (long)[loggedUser.metadata userId]];
}

- (KWS_HTTP_METHOD) getMethod {
    return GET;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _checkAllowed(false);
    } else {
        if ((status == 200 || status == 204) && payload != NULL) {
            
            KWSUser *user = [[KWSUser alloc] initWithJsonString:payload];
            [SALogger log:[user jsonPreetyStringRepresentation]];
            
            if (user) {
                
                NSNumber *perm = user.applicationPermissions.sendPushNotification;
                
                if (perm == NULL || [perm boolValue] == true) {
                    _checkAllowed(true);
                } else {
                    _checkAllowed(false);
                }
            } else {
                _checkAllowed(false);
            }
        }
        else {
            _checkAllowed(false);
        }
    }
}

- (void) execute:(checkAllowed)checkAllowed {
    _checkAllowed = checkAllowed ? checkAllowed : _checkAllowed;
    [super execute];
}

@end
