//
//  KWSGetAppData.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSService.h"
#import "KWSAppData.h"

typedef void (^gotAppData)(NSArray<KWSAppData*> *appData);

@interface KWSGetAppData : KWSService
- (void) execute:(gotAppData)gotappdata;
@end
