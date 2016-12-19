//
//  NotificationProcess.h
//  Pods
//
//  Created by Gabriel Coman on 05/08/2016.
//
//

#import <Foundation/Foundation.h>

// notification status
typedef NS_ENUM(NSInteger, KWSNotificationStatus) {
    KWSNotification_Success                     = 0,
    KWSNotification_ParentDisabledNotifications = 1,
    KWSNotification_UserDisabledNotifications   = 2,
    KWSNotification_NoParentEmail               = 3,
    KWSNotification_FirebaseNotSetup            = 4,
    KWSNotification_FirebaseCouldNotGetToken    = 5,
    KWSNotification_NetworkError                = 6
};

// define blocks for the notification process
typedef void (^isRegistered)(BOOL success);
typedef void (^registered)(KWSNotificationStatus status);
typedef void (^unregistered)(BOOL success);

@interface KWSNotificationProcess : NSObject

- (void) register:(registered)registered;
- (void) unregister:(unregistered)unregistered;
- (void) isRegistered:(isRegistered)isRegistered;

@end
