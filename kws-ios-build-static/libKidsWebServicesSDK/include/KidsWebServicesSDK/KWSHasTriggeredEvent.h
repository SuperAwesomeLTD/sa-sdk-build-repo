//
//  KWSHasTriggeredEvent.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSService.h"

typedef void (^hasTriggered)(BOOL triggered);

@interface KWSHasTriggeredEvent : KWSService
- (void) execute:(NSInteger)eventId :(hasTriggered)triggered;
@end
