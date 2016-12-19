//
//  CreateUserProcess.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import <Foundation/Foundation.h>

// create user status
typedef NS_ENUM(NSInteger, KWSCreateUserStatus) {
    KWSCreateUser_Success             = 0,
    KWSCreateUser_InvalidUsername     = 1,
    KWSCreateUser_InvalidPassword     = 2,
    KWSCreateUser_InvalidDateOfBirth  = 3,
    KWSCreateUser_InvalidCountry      = 4,
    KWSCreateUser_InvalidParentEmail  = 5,
    KWSCreateUser_DuplicateUsername   = 6,
    KWSCreateUser_NetworkError        = 7,
    KWSCreateUser_InvalidOperation    = 8
};

typedef void (^userCreated)(KWSCreateUserStatus error);

@interface KWSCreateUserProcess : NSObject

- (void) createWithUsername:(NSString*)username
                andPassword:(NSString*)password
             andDateOfBirth:(NSString*)dateOfBirth
                 andCountry:(NSString*)country
             andParentEmail:(NSString*)parentEmail
                           :(userCreated)userCreated;

@end
