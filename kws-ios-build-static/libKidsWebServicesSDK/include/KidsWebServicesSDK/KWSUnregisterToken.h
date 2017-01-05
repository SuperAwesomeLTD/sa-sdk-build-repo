//
//  KWSUnsubscribeToken.h
//  Pods
//
//  Created by Gabriel Coman on 28/06/2016.
//
//  @brief:
//  This module handles ubsubscribing a user's token from KWS.
//  

#import <Foundation/Foundation.h>
#import "KWSService.h"

typedef void (^unregisteredToken)(BOOL success);

@interface KWSUnregisterToken : KWSService
- (void) execute:(NSString*)token :(unregisteredToken)registered;
@end
