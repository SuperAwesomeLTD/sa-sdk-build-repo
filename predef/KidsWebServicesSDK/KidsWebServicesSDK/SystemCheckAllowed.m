//
//  PushCheckPermission.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import "SystemCheckAllowed.h"
#import "SASystemVersion.h"

#define kUserHasSeenDialog @"UserHasSeenDialog"
#define SYS_VERSION SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface SystemCheckAllowed ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, weak) UIApplication *appRef;
@property (nonatomic, assign) Boolean hasUserSeenDialog;
@property (nonatomic, strong) checkSystem checkSystem;
@end

@implementation SystemCheckAllowed

- (void) execute:(checkSystem)checkSystem {
    _checkSystem = checkSystem ? checkSystem : ^(BOOL success){};
    _defaults = [NSUserDefaults standardUserDefaults];
    _appRef = [UIApplication sharedApplication];
    
    if ([_defaults objectForKey:kUserHasSeenDialog] != NULL) {
        _hasUserSeenDialog = [_defaults boolForKey:kUserHasSeenDialog];
    }
    
    if (!_hasUserSeenDialog) {
        _checkSystem(true);
        return;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationSettings *settings = [_appRef currentUserNotificationSettings];
        if (settings != NULL) {
            if (settings.types != UIUserNotificationTypeNone) {
                _checkSystem(true);
                return;
            }
            _checkSystem(false);
            return;
        }
        _checkSystem(false);
        return;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType types = [_appRef enabledRemoteNotificationTypes];
        
        if (types & UIRemoteNotificationTypeAlert) {
            _checkSystem(true);
            return;
        }else {
            _checkSystem(false);
            return;
        }
#pragma GCC diagnostic pop
    }
    
    // don't call super
    // [super execute];
}

// MARK: aux functions

- (void) markSystemDialogAsSeen {
    _defaults = [NSUserDefaults standardUserDefaults];
    _hasUserSeenDialog = true;
    [_defaults setBool:_hasUserSeenDialog forKey:kUserHasSeenDialog];
    [_defaults synchronize];
}

@end
