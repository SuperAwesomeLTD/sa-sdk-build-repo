//
//  KWSUpdateUser.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSService.h"
#import "KWSUser.h"

typedef void (^updated)(BOOL updated);

@interface KWSUpdateUser : KWSService
- (void) execute:(KWSUser*)updatedUser :(updated)updated;
@end
