//
//  PushCheckPermission.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//  @brief:
//  This module just checks if Remote Notifications are enabled for a user
//  on the System.
//
//  If a user has explicitly disabled Remote Notifications (in the Settings
//  panel or otherwise), it will call pushDisabledInSytem
//
//  If a user has not disabled Remote Notifications, it will call
//  pushEnabledInSystem

#import <UIKit/UIKit.h>
#import "KWSService.h"

typedef void (^checkSystem)(BOOL allowed);

@interface SystemCheckAllowed : KWSService

- (void) execute:(checkSystem)checkSystem;
- (void) markSystemDialogAsSeen;

@end
