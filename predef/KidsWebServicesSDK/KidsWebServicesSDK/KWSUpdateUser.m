//
//  KWSUpdateUser.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSUpdateUser.h"
#import "KWSApplicationProfile.h"
#import "KWSAddress.h"
#import "KWSError.h"

@interface KWSUpdateUser ()
@property (nonatomic, strong) updated updated;
@property (nonatomic, strong) KWSUser *updatedUser;
@end

@implementation KWSUpdateUser

- (id) init {
    if (self = [super init]) {
        _updated = ^(BOOL updated) {};
    }
    
    return self;
}

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/users/%ld", (long)[loggedUser.metadata userId]];
}

- (KWS_HTTP_METHOD) getMethod {
    return PUT;
}

- (NSDictionary*) getBody {
    NSMutableDictionary *body = [@{} mutableCopy];
    
    if (_updatedUser.firstName) [body setObject:_updatedUser.firstName forKey:@"firstName"];
    if (_updatedUser.lastName) [body setObject:_updatedUser.lastName forKey:@"lastName"];
    if (_updatedUser.dateOfBirth) [body setObject:_updatedUser.dateOfBirth forKey:@"dateOfBirth"];
    if (_updatedUser.email) [body setObject:_updatedUser.email forKey:@"email"];
    if (_updatedUser.phoneNumber) [body setObject:_updatedUser.phoneNumber forKey:@"phoneNumber"];
    if (_updatedUser.gender) [body setObject:_updatedUser.gender forKey:@"gender"];
    if (_updatedUser.language) [body setObject:_updatedUser.language forKey:@"language"];
    
    if (_updatedUser.address) {
        NSMutableDictionary *address = [@{} mutableCopy];
        if (_updatedUser.address.street) [address setObject:_updatedUser.address.street forKey:@"street"];
        if (_updatedUser.address.city) [address setObject:_updatedUser.address.street forKey:@"city"];
        if (_updatedUser.address.postCode) [address setObject:_updatedUser.address.street forKey:@"postCode"];
        if (_updatedUser.address.country) [address setObject:_updatedUser.address.street forKey:@"country"];
        if ([address count] == 4) {
            [body setObject:address forKey:@"address"];
        }
    }
    
    if (_updatedUser.applicationProfile) {
        NSMutableDictionary *profile = [@{} mutableCopy];
        [profile setObject:@(_updatedUser.applicationProfile.avatarId) forKey:@"avatarId"];
        [profile setObject:@(_updatedUser.applicationProfile.customField1) forKey:@"customField1"];
        [profile setObject:@(_updatedUser.applicationProfile.customField2) forKey:@"customField2"];
        [profile setObject:@(_updatedUser.applicationProfile.customField3) forKey:@"customField3"];
        [profile setObject:@(_updatedUser.applicationProfile.customField4) forKey:@"customField4"];
        [profile setObject:@(_updatedUser.applicationProfile.customField5) forKey:@"customField5"];
        [body setObject:profile forKey:@"applicationProfile"];
    }
    
    return body;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _updated (false);
    } else {
        if (status == 200 || status == 204) {
            _updated (true);
        } else {
            KWSError *error = [[KWSError alloc] initWithJsonString:payload];
            if (error.code == 1 || error.code == 5) {
                _updated (false);
            }
        }
    }
}

- (void) execute:(KWSUser *)updatedUser :(updated)updated {
    _updated = updated ? updated : _updated;
    _updatedUser = updatedUser;
    [super execute];
}

@end
