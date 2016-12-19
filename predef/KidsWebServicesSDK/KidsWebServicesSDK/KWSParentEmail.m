//
//  KWSParentEmail.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

// header
#import "KWSParentEmail.h"

// import aux & utils
#import "SAUtils.h"
#import "KWSAux.h"

@interface KWSParentEmail ()
@property (nonatomic, strong) submitted submitted;
@property (nonatomic, strong) NSString *emailToSubmit;
@end

@implementation KWSParentEmail

- (id) init {
    if (self = [super init]) {
        _submitted = ^(KWSParentEmailStatus type) {};
    }
    
    return self;
}

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/users/%ld/request-permissions", (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (NSDictionary*) getBody {
    return @{
        @"permissions": @[@"sendPushNotification"],
        @"parentEmail": nullSafe(_emailToSubmit)
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    
    if (!success) {
        _submitted (KWSParentEmail_NetworkError);
    } else {
        if (status == 200 || status == 204) {
            _submitted (KWSParentEmail_Success);
        } else {
            _submitted (KWSParentEmail_NetworkError);
        }
    }
}

- (void) execute:(NSString*)email :(submitted)submitted {
    _submitted = submitted ? submitted : _submitted;
    _emailToSubmit = email;
    BOOL emailValid = [self validateEmail:_emailToSubmit];
    
    // check email to be valid
    if (!emailValid) {
        _submitted (KWSParentEmail_Invalid);
        return;
    }
    // call to super
    [super execute:_emailToSubmit];
}

- (BOOL) validateEmail: (NSString *) email {
    return email && [KWSAux validate:email withRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}


@end
