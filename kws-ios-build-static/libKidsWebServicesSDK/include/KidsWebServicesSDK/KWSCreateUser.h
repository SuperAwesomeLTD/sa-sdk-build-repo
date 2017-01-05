//
//  KWSCreateUser.h
//  Pods
//
//  Created by Gabriel Coman on 07/10/2016.
//
//

#import "KWSService.h"

// forward decl
@class KWSLoggedUser;

typedef void (^created)(NSInteger status, KWSLoggedUser *user);

@interface KWSCreateUser : KWSService

- (void) executeWith:(NSString*)token
            andAppId:(NSInteger)appId
         andUsername:(NSString*)username
         andPassword:(NSString*)password
      andDateOfBirth:(NSString*)dateOfBirth
          andCountry:(NSString*)country
      andParentEmail:(NSString*)parentEmail
          onResponse:(created)created;


@end
