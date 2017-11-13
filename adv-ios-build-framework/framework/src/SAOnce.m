/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAOnce.h"

// the key under which the cpi prefference will be held
#define KEY @"SA_CPI_KEY"

@interface SAOnce ()

// local instance of user defaults
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation SAOnce

/**
 * Standard init method
 */
- (id) init {
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (BOOL) isCPISent {
    return [_defaults boolForKey:KEY];
}

- (BOOL) setCPISent {
    [_defaults setObject:@(true) forKey:KEY];
    return true;
}

- (BOOL) resetCPISent {
    [_defaults removeObjectForKey:KEY];
    return true;
}

@end
