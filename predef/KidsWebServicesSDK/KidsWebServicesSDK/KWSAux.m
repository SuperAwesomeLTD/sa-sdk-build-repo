//
//  KWSAux.m
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "KWSAux.h"
#import "KWSMetadata.h"

@implementation KWSAux

+ (KWSMetadata*) processMetadata:(NSString*)oauthToken {
    NSArray *subtokens = [oauthToken componentsSeparatedByString:@"."];
    NSString *token = nil;
    if (subtokens.count >= 2) token = subtokens[1];
    if (token == nil) return nil;
    
    NSString *token0 = token;
    NSString *token1 = [token0 stringByAppendingString:@"="];
    NSString *token2 = [token1 stringByAppendingString:@"="];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:token0 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (decodedData == nil) {
        decodedData = [[NSData alloc] initWithBase64EncodedString:token1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (decodedData == nil) {
            decodedData = [[NSData alloc] initWithBase64EncodedString:token2 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (decodedData == nil) return nil;
        }
    }
    
    NSString *decodedJson = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [[KWSMetadata alloc] initWithJsonString:decodedJson];
}

+ (BOOL) validate: (NSString*) item withRegex: (NSString*) regex {
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:item];
}

@end
