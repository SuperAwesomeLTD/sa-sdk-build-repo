//
//  KWSRequestPermission.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//  @brief:
//  This module is concerned with send a request for a new permission to KWS,
//  namely for the Remote Notification permission
//
//  If all goes well the user is granted the new permission
//  If the user does not have a parent email, then that's an error case
//

#import <UIKit/UIKit.h>
#import "KWSService.h"

// enum to define permissions
typedef NS_ENUM(NSInteger, KWSPermissionType) {
    KWSPermission_AccessEmail             = 0,
    KWSPermission_AccessAddress           = 1,
    KWSPermission_AccessFirstName         = 2,
    KWSPermission_AccessLastName          = 3,
    KWSPermission_AccessPhoneNumber       = 4,
    KWSPermission_SendNewsletter          = 5,
    KWSPermission_SendPushNotification    = 6
};

// enum to define status
typedef NS_ENUM (NSInteger, KWSPermissionStatus) {
    KWSPermission_Success = 0,
    KWSPermission_NoParentEmail = 1,
    KWSPermission_NetworkError = 2
};

typedef void (^requested)(KWSPermissionStatus status);

@interface KWSRequestPermission : KWSService
- (void) execute:(NSArray<NSNumber*>*)requestPermissions :(requested)requested;
@end
