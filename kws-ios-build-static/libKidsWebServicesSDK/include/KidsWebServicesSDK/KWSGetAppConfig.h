//
//  KWSAppConfig.h
//  Pods
//
//  Created by Gabriel Coman on 04/01/2017.
//
//

#import "KWSService.h"

@class KWSAppConfig;

typedef void (^gotAppConfig)(KWSAppConfig *config);

@interface KWSGetAppConfig : KWSService
- (void) execute: (gotAppConfig)gotAppConfig;
@end
