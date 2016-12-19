//
//  KWSInviteUser.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSService.h"

typedef void (^invited)(BOOL invited);

@interface KWSInviteUser : KWSService
- (void) execute:(NSString*) email :(invited)invited;
@end
