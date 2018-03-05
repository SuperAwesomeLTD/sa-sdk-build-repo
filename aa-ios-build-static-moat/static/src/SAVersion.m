//
//  SAVersion.m
//  Pods
//
//  Created by Gabriel Coman on 26/07/2017.
//
//

#import "SAVersion.h"

static NSString *version    = @"6.1.6";
static NSString *sdk        = @"ios";

@implementation SAVersion

+ (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", sdk, version];
}

+ (void) overrideVersion: (NSString*) v {
    version = v;
}

+ (void) overrideSdk: (NSString*) s {
    sdk = s;
}

@end
