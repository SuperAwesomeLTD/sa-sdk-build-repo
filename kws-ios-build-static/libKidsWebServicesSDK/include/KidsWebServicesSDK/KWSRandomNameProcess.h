//
//  KWSRandomNameProcess.h
//  Pods
//
//  Created by Gabriel Coman on 04/01/2017.
//
//

#import <Foundation/Foundation.h>

#import "KWSGetAppConfig.h"
#import "KWSRandomName.h"
#import "KWSAppConfig.h"

@interface KWSRandomNameProcess : NSObject
- (void) getRandomName: (gotRandomName) gotRandomName;
@end
