//
//  KWSSetAppData.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "KWSService.h"

typedef void (^setAppData)(BOOL success);

@interface KWSSetAppData : KWSService
- (void) execute:(NSString*)name withValue:(NSInteger)value :(setAppData)setappdata;
@end
