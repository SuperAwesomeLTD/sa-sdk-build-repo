//
//  KWSTriggerEvent.h
//  Pods
//
//  Created by Gabriel Coman on 08/08/2016.
//
//

#import "KWSService.h"

typedef void (^triggered)(BOOL success);

@interface KWSTriggerEvent : KWSService
- (void) execute:(NSString*)token points:(NSInteger)points :(triggered)triggered;
@end
