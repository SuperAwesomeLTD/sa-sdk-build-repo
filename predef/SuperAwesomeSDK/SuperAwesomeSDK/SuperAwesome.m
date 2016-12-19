//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import header
#import "SuperAwesome.h"

#import "SACPI.h"

@interface SuperAwesome ()
@property (nonatomic, strong) SACPI *cpi;
@end

@implementation SuperAwesome

+ (instancetype) getInstance {
    static SuperAwesome *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    if (self = [super init]) {
        _cpi = [[SACPI alloc] init];
    }
    
    return self;
}

- (NSString*) getVersion {
    return @"5.3.14";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (void) handleCPI {
    [_cpi sendCPIEvent];
}

@end
