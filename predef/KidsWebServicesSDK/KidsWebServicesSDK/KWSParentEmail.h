//
//  KWSParentEmail.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//  @brief:
//  This module is used to send a parent email to the KWS backend
//

#import <UIKit/UIKit.h>
#import "KWSService.h"

typedef NS_ENUM(NSInteger, KWSParentEmailStatus) {
    KWSParentEmail_Success      = 0,
    KWSParentEmail_Invalid      = 1,
    KWSParentEmail_NetworkError = 2,
};

typedef void (^submitted)(KWSParentEmailStatus status);

@interface KWSParentEmail : KWSService
- (void) execute:(NSString*)email :(submitted)submitted;
@end
