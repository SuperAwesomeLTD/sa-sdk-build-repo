//
//  SACapper.m
//  Pods
//
//  Created by Gabriel Coman on 16/02/2016.
//
//

#import "SACapper.h"

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#define SUPER_AWESOME_FIRST_PART_DAU @"SUPER_AWESOME_FIRST_PART_DAU"

// this thing right here imports AdSupport framework
@import AdSupport;

@interface SACapper ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SACapper

- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (NSUInteger) getDauId {
    // get if the user has an advertising enabled
    BOOL canTrack = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    // if user had disabled tracking --> that's it
    if (!canTrack) {
        return 0 ;
    }
    
    // continue as if  user has Ad Tracking enabled and all ...
    NSString *firstPartOfDAU = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *secondPartOfDAU = [_defs objectForKey:SUPER_AWESOME_FIRST_PART_DAU];
    NSString *thirdPartOfDAU = [[NSBundle mainBundle] bundleIdentifier];
    
    if (!secondPartOfDAU || [secondPartOfDAU isEqualToString:@""]){
        secondPartOfDAU = [SAUtils generateUniqueKey];
        [_defs setObject:secondPartOfDAU forKey:SUPER_AWESOME_FIRST_PART_DAU];
        [_defs synchronize];
    }
    
    NSUInteger hash1 = [firstPartOfDAU hash];
    NSUInteger hash2 = [secondPartOfDAU hash];
    NSUInteger hash3 = [thirdPartOfDAU hash];
    NSUInteger dauHash = hash1 ^ hash2 ^ hash3;
    
    return dauHash;
}

@end
