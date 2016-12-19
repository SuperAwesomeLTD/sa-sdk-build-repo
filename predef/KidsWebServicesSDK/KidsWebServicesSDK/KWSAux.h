//
//  KWSAux.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import <Foundation/Foundation.h>

@class KWSMetadata;

@interface KWSAux : NSObject

+ (KWSMetadata*) processMetadata:(NSString*)oauthToken;
+ (BOOL) validate: (NSString*) item withRegex: (NSString*) regex;

@end
