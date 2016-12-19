//
//  KWSLogger.m
//  Pods
//
//  Created by Gabriel Coman on 07/07/2016.
//
//

#import "SALogger.h"

@implementation SALogger

+ (void) log:(NSString*)message {
    NSLog(@"[KWS] :: Log ==> %@", message);
}

+ (void) err:(NSString*)message {
    NSLog(@"[KWS] :: Err ==> %@", message);
}

@end

