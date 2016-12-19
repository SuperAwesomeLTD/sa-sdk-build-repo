//
//  KWSCheckRegistered.h
//  Pods
//
//  Created by Gabriel Coman on 14/07/2016.
//
//

#import "KWSService.h"

typedef void (^checkRegistered)(BOOL registered);

@interface KWSCheckRegistered : KWSService
- (void) execute: (checkRegistered) checkRegistered;
@end
