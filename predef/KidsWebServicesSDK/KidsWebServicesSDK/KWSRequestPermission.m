//
//  KWSRequestPermission.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

// header
#import "KWSRequestPermission.h"

// aux
#import "KWS.h"
#import "SANetwork.h"

// models
#import "KWSMetadata.h"
#import "KWSError.h"
#import "KWSParentEmailError.h"
#import "KWSInvalid.h"
#import "SALogger.h"

@interface KWSRequestPermission ()
@property (nonatomic, strong) requested requested;
@property (nonatomic, strong) NSMutableArray<NSString*> *requestedPermissions;
@end

@implementation KWSRequestPermission

- (id) init {
    if (self = [super init]) {
        _requested = ^(KWSPermissionStatus status) {};
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
        @"permissions": nullSafe([_requestedPermissions dictionaryRepresentation])
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _requested(KWSPermission_NetworkError);
    } else {
        if (payload) {
            KWSError *error = [[KWSError alloc] initWithJsonString:payload];
            [SALogger log:[error jsonPreetyStringRepresentation]];
            
            if (status == 200 || status == 204) {
                _requested(KWSPermission_Success);
            }
            else if (status != 200 && error) {
                if (error.code == 10 && error.invalid.parentEmail.code == 6) {
                    _requested(KWSPermission_NoParentEmail);
                }
                else {
                    _requested(KWSPermission_NetworkError);
                }
            }
            else {
                _requested(KWSPermission_NetworkError);
            }
        } else {
            _requested(KWSPermission_NetworkError);
        }
    }
    
}

- (void) execute:(NSArray<NSNumber *> *)requestPermissions :(requested)requested{

    _requested = requested ? requested : _requested;
    
    _requestedPermissions = [[NSMutableArray alloc] init];
    for (NSNumber *number in requestPermissions) {
        NSInteger typeAsInt = [number integerValue];
        [_requestedPermissions addObject:[self typeToString:typeAsInt]];
    }
    
    // call to super
    [super execute:requestPermissions];
}

// MARK Aux functions

- (NSString*) typeToString:(KWSPermissionType)type {
    switch (type) {
        case KWSPermission_AccessEmail: return @"accessEmail";
        case KWSPermission_AccessAddress: return @"accessAddress";
        case KWSPermission_AccessFirstName: return @"accessFirstName";
        case KWSPermission_AccessLastName: return @"accessLastName";
        case KWSPermission_AccessPhoneNumber: return @"accessPhoneNumber";
        case KWSPermission_SendNewsletter: return @"sendNewsletter";
        case KWSPermission_SendPushNotification: return @"sendPushNotification";
    }
}

@end
