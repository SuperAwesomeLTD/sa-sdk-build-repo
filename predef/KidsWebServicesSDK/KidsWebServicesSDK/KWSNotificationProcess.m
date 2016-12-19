//
//  NotificationProcess.m
//  Pods
//
//  Created by Gabriel Coman on 05/08/2016.
//
//

// import header
#import "KWSNotificationProcess.h"

// import other headers
#import "KWSCheckAllowed.h"
#import "KWSCheckRegistered.h"
#import "KWSRequestPermission.h"
#import "KWSRegisterToken.h"
#import "KWSUnregisterToken.h"
#import "SystemCheckAllowed.h"
#import "FirebaseGetToken.h"

// other utils
#import "SASystemVersion.h"

@interface KWSNotificationProcess ()
// objects
@property (nonatomic, strong) KWSCheckAllowed *checkAllowed;
@property (nonatomic, strong) KWSCheckRegistered *checkRegistered;
@property (nonatomic, strong) KWSRequestPermission *requestPermission;
@property (nonatomic, strong) KWSRegisterToken *registerToken;
@property (nonatomic, strong) KWSUnregisterToken *unregisterToken;
@property (nonatomic, strong) SystemCheckAllowed *checkSystem;
@property (nonatomic, strong) FirebaseGetToken *getToken;

// application reference
@property (nonatomic, weak) UIApplication *appRef;

@end

@implementation KWSNotificationProcess

- (id) init {
    if (self = [super init]) {
        _checkAllowed = [[KWSCheckAllowed alloc] init];
        _checkRegistered = [[KWSCheckRegistered alloc] init];
        _requestPermission = [[KWSRequestPermission alloc] init];
        _registerToken = [[KWSRegisterToken alloc] init];
        _unregisterToken = [[KWSUnregisterToken alloc] init];
        _checkSystem = [[SystemCheckAllowed alloc] init];
        _getToken = [[FirebaseGetToken alloc] init];
        
        _appRef = [UIApplication sharedApplication];
    }
    
    return self;
}

- (void) register:(registered)reg {
    
    // make sure it won't cause any problems down the road
    __block registered registered = reg ? reg : ^(KWSNotificationStatus status){};
    
    [_checkSystem execute:^(BOOL allowed) {
        if (!allowed) {
            registered(KWSNotification_UserDisabledNotifications);
            return;
        }
        
        [_checkAllowed execute:^(BOOL allowed) {
            if (!allowed) {
                registered(KWSNotification_ParentDisabledNotifications);
                return;
            }
            
            [_requestPermission execute:@[@(KWSPermission_SendPushNotification)] :^(KWSPermissionStatus status) {
                
                switch (status) {
                    // managed to request the Remote Notification permission
                    case KWSPermission_Success: {
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                            UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
                            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
                            [_appRef registerUserNotificationSettings:settings];
                            [_appRef registerForRemoteNotifications];
                        } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                            UIRemoteNotificationType allNotificationTypes = (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
                            [_appRef registerForRemoteNotificationTypes:allNotificationTypes];
#pragma GCC diagnostic pop
                        }
                        
                        // mark this
                        [_checkSystem markSystemDialogAsSeen];
                        
                        [_getToken execute:^(BOOL sucess, NSString *token) {
                            if (!sucess) {
                                registered(KWSNotification_FirebaseCouldNotGetToken);
                                return;
                            }
                            
                            [_registerToken execute:token :^(BOOL success) {
                                if (!success) {
                                    registered(KWSNotification_NetworkError);
                                } else {
                                    registered(KWSNotification_Success);
                                }
                            }];
                        }];
                        
                        break;
                    }
                    // No parent email available
                    case KWSPermission_NoParentEmail: {
                        registered(KWSNotification_NoParentEmail);
                        break;
                    }
                    // A network error occurred
                    case KWSPermission_NetworkError: {
                        registered(KWSNotification_NetworkError);
                        break;
                    }
                }
            }];
        }];
    }];
}

- (void) unregister:(unregistered)unreg {
    // make sure thare are no problems here
    __block unregistered unregistered = unreg ? unreg : ^(BOOL success){};
    NSString *token = [_getToken getSavedToken];
    
    // call func
    [_unregisterToken execute:token :^(BOOL success) {
        unregistered(success);
    }];
}

- (void) isRegistered:(isRegistered)isReg {
    // make sure no problems will appear
    __block isRegistered isRegistered = isReg ? isReg : ^(BOOL success){};
    
    // check
    [_checkSystem execute:^(BOOL allowed) {
        if (!allowed) {
            isRegistered(false);
            return;
        }
        
        [_checkAllowed execute:^(BOOL allowed) {
            if (!allowed) {
                isRegistered(false);
                return;
            }
            
            [_checkRegistered execute:^(BOOL registered) {
                isRegistered (registered);
            }];
        }];
    }];
}

@end
