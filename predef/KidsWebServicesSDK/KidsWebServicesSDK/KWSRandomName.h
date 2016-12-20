//
//  KWSRandomName.h
//  Pods
//
//  Created by Gabriel Coman on 20/12/2016.
//
//

#import "KWSService.h"

typedef void (^gotRandomName)(NSString *name);

@interface KWSRandomName : KWSService
- (void) execute:(gotRandomName)gotName;
@end
