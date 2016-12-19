//
//  SAUtils.m
//  Pods
//
//  Created by Gabriel Coman on 09/03/2016.
//
//

#import "SAUtils.h"

#import "SAExtensions.h"
#import "NSString+HTML.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>

@implementation SAUtils

////////////////////////////////////////////////////////////////////////////////
// Trully aux functions
////////////////////////////////////////////////////////////////////////////////

+ (CGRect) mapOldFrame:(CGRect)oldframe toNewFrame:(CGRect)frame {
    
    CGFloat oldW = oldframe.size.width;
    CGFloat oldH = oldframe.size.height;
    CGFloat newW = frame.size.width;
    CGFloat newH = frame.size.height;
    
    if (oldW == 1 || oldW == 0) { oldW = newW; }
    if (oldH == 1 || oldH == 0) { oldH = newH; }
    
    CGFloat oldR = oldW / oldH;
    CGFloat newR = newW / newH;
    CGFloat X = 0, Y = 0, W = 0, H = 0;
    
    if (oldR > newR) {
        W = newW;
        H = W / oldR;
        X = 0;
        Y = (newH - H) / 2.0f;
    }
    else {
        H = newH;
        W = H * oldR;
        Y = 0;
        X = (newW - W) / 2.0f;
    }
    
    return CGRectMake((NSInteger)X, (NSInteger)Y, (NSInteger)W, (NSInteger)H);
}

+ (BOOL) isRect:(CGRect)target inRect:(CGRect)frame {
    // window
    CGFloat x11 = frame.origin.x;
    CGFloat y11 = frame.origin.y;
    CGFloat x12 = frame.origin.x + frame.size.width;
    CGFloat y12 = frame.origin.y + frame.size.height;
    
    // banner
    CGFloat x21 = target.origin.x;
    CGFloat y21 = target.origin.y;
    CGFloat x22 = target.origin.x + target.size.width;
    CGFloat y22 = target.origin.y + target.size.height;
    
    CGFloat x_overlap = MAX(0, MIN(x12, x22)) - MAX(x11, x21);
    CGFloat y_overlap = MAX(0, MIN(y12, y22)) - MAX(y11, y21);
    
    // overlap area
    CGFloat overlap = x_overlap * y_overlap;
    
    // banner area
    CGFloat barea = target.size.width * target.size.height;
    
    // treshold
    CGFloat treshold = barea / 2.0f;
    
    return overlap > treshold;
}

+ (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}

+ (NSString*) findSubstringFrom:(NSString*)source betweenStart:(NSString*)start andEnd:(NSString*)end {
    // do a nil check at the start
    if (source == nil || start == nil || end == nil) return nil;
    
    // start the process
    NSRange startRange = [source rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [source length] - targetRange.location;
        NSRange endRange = [source rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [source substringWithRange:targetRange];
        }
    }
    
    // if no correct result up until here, just return nil
    return nil;
}

+ (NSString*) generateUniqueKey {
    // constants
    const NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    const NSInteger length = [alphabet length];
    const NSInteger dauLength = 32;
    
    // create the string
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < dauLength; i++) {
        u_int32_t r = arc4random() % length;
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return s;
}

////////////////////////////////////////////////////////////////////////////////
// System type functions
////////////////////////////////////////////////////////////////////////////////

+ (SASystemSize) getSystemSize {
    BOOL isIpad = [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"];
    return (isIpad ? size_tablet : size_phone);
}

+ (NSString*) getVerboseSystemDetails {
    switch ([self getSystemSize]) {
        case size_tablet: return @"ios_tablet";
        case size_phone: return @"ios_mobile";
    }
}

+ (NSString *) getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    return basePath;
}

+ (NSString*) filePathInDocuments:(NSString*)fpath {
    return [[self getDocumentsDirectory] stringByAppendingPathComponent:fpath];
}

////////////////////////////////////////////////////////////////////////////////
// URL and Network request helper classes
////////////////////////////////////////////////////////////////////////////////

+ (NSString*) getUserAgent {
    return [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

+ (NSInteger) getCachebuster {
    NSInteger min = 1000000, max = 1500000;
    return [self randomNumberBetween:min maxNumber:max];
}

+ (NSString*) encodeURI:(NSString*)stringToEncode {
    // null check
    if (stringToEncode == nil || [stringToEncode isEqualToString:@""]) return @"";
    
    // uri encoding 
    return CFBridgingRelease(
        CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (__bridge CFStringRef)stringToEncode,
            NULL,
            (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)
        )
    );
}

+ (NSString*) formGetQueryFromDict:(NSDictionary *)dict {
    NSMutableString *query = [[NSMutableString alloc] init];
    NSMutableArray *getParams = [[NSMutableArray alloc] init];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull end) {
        [getParams addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    } atEnd:^{
        [query appendString:[getParams componentsJoinedByString:@"&"]];
    }];
    
    return query;
}

+ (NSString*) encodeJSONDictionaryFromNSDictionary:(NSDictionary *)dict {
    // check for null-ness or emptyness
    if (dict == NULL || [dict count] == 0) return @"%7B%7D";
    
    // go ahead and encode
    NSMutableString *stringJSON = [[NSMutableString alloc] init];
    NSMutableArray *jsonFields = [[NSMutableArray alloc] init];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull end) {
        if ([obj isKindOfClass:[NSString class]]){
            [jsonFields addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"", key, obj ]];
        } else {
            [jsonFields addObject:[NSString stringWithFormat:@"\"%@\":%@", key, obj ]];
        }
    } atEnd:^{
        [stringJSON appendFormat:@"{%@}", [jsonFields componentsJoinedByString:@","]];
    }];
    
    return [self encodeURI:stringJSON];
}

+ (NSString*) decodeHTMLEntitiesFrom:(NSString*)string {
    return [[string stringByDecodingHTMLEntities] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString*) findBaseURLFromResourceURL:(NSString*)resourceURL {
    if (!resourceURL) return nil;
    if (![self isValidURL:resourceURL]) return nil;
    NSString *workString = [resourceURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSArray *components = [workString componentsSeparatedByString:@"/"];
    NSMutableArray *newComponents = [@[] mutableCopy];
    for (int i = 0; i < components.count - 1; i++){
        [newComponents addObject:components[i]];
    }
    NSMutableString *result = [[newComponents componentsJoinedByString:@"/"] mutableCopy];
    if ([self isValidURL:result]) return [result stringByAppendingString:@"/"];
    return nil;
}

+ (BOOL) isValidURL:(NSObject *)urlObject {
    if (![urlObject isKindOfClass:[NSString class]] || urlObject == nil) return false;
    NSURL *candidateURL = [NSURL URLWithString:(NSString*)urlObject];
    if (candidateURL && candidateURL.scheme && candidateURL.host) return true;
    return false;
}

+ (BOOL) isEmailValid:(NSString*) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:email];
    return result;
}

////////////////////////////////////////////////////////////////////////////////
// Colors
////////////////////////////////////////////////////////////////////////////////

UIColor *UIColorFromHex(int rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                            blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

UIColor *UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue) {
    return [UIColor colorWithRed:(CGFloat)((CGFloat)red / 255.0f)
                           green:(CGFloat)((CGFloat)green / 255.0f)
                            blue:(CGFloat)((CGFloat)blue / 255.0f)
                           alpha:1.0f];
}

////////////////////////////////////////////////////////////////////////////////
// Aux network functions
////////////////////////////////////////////////////////////////////////////////

+ (SAConnectionType) getNetworkConnectivity {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    if (reachability != NULL) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            
            // release
            CFRelease(reachability);
            
            // handle
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) return unknown;
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) return wifi;
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) return wifi;
            }
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) return cellular_unknown;
        } else {
            // release again
            CFRelease(reachability);
            return unknown;
        }
    }
    return unknown;
}

////////////////////////////////////////////////////////////////////////////////
// Invoke functions
////////////////////////////////////////////////////////////////////////////////

+ (NSValue*) invoke:(NSString*)method onTarget:(id) target, ... {
    
    // get selector
    SEL selector = NSSelectorFromString(method);
    
    if (selector != NULL && [target respondsToSelector:selector]) {
        
        // get arg list
        va_list args;
        va_start(args, target);
        
        // start
        NSMethodSignature * signature = [target methodSignatureForSelector:selector];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        // preliminary
        [invocation setTarget: target];
        [invocation setSelector:selector];
        
        // go through arguments and add them
        NSUInteger arg_count = [signature numberOfArguments];
        
        
        for (NSInteger i = 0; i < arg_count - 2; i++) {
            
            // get current arg
            id arg = va_arg(args, id);
            
            // value is special
            if([arg isKindOfClass:[NSValue class]]) {
                
                NSUInteger arg_size;
                NSGetSizeAndAlignment([arg objCType], &arg_size, NULL);
                void * arg_buffer = malloc(arg_size);
                [arg getValue:arg_buffer];
                [invocation setArgument:arg_buffer atIndex: 2 + i ];
                free(arg_buffer);
            }
            // just copy val
            else {
                [invocation setArgument:&arg atIndex: 2 + i];
            }
        }
        
        // end
        va_end(args);
        
        // invoke
        [invocation invoke];
        
        
        // get result
        NSValue *ret_val  = nil;
        NSUInteger ret_size = [signature methodReturnLength];
        
        if(ret_size > 0) {
            
            void * ret_buffer = malloc( ret_size );
            [invocation getReturnValue:ret_buffer];
            ret_val = [NSValue valueWithBytes:ret_buffer objCType:[signature methodReturnType]];
            free(ret_buffer);
        }
        
        // return value
        return ret_val;
    }
    
    return nil;
    
}

+ (NSValue*) invoke:(NSString*)method onClass:(NSString*) name, ... {
    
    // get the class
    Class classy = NSClassFromString(name);
    
    // get the selector
    SEL selector = NSSelectorFromString(method);
    
    if (classy != NULL && selector != NULL && [classy respondsToSelector:selector]) {
        
        // get arg list
        va_list args;
        va_start(args, name);
        
        // start
        NSMethodSignature * signature = [classy methodSignatureForSelector:selector];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        // preliminary
        [invocation setTarget: classy];
        [invocation setSelector:selector];
        
        // go through arguments and add them
        NSUInteger arg_count = [signature numberOfArguments];
        
        
        for (NSInteger i = 0; i < arg_count - 2; i++) {
            
            // get current arg
            id arg = va_arg(args, id);
            
            // value is special
            if([arg isKindOfClass:[NSValue class]]) {
                
                NSUInteger arg_size;
                NSGetSizeAndAlignment([arg objCType], &arg_size, NULL);
                void * arg_buffer = malloc(arg_size);
                [arg getValue:arg_buffer];
                [invocation setArgument:arg_buffer atIndex: 2 + i ];
                free(arg_buffer);
            }
            // just copy val
            else {
                [invocation setArgument:&arg atIndex: 2 + i];
            }
        }
        
        // end
        va_end(args);
        
        // invoke
        [invocation invoke];
        
        
        // get result
        NSValue *ret_val  = nil;
        NSUInteger ret_size = [signature methodReturnLength];
        
        if(ret_size > 0) {
        
            void * ret_buffer = malloc( ret_size );
            [invocation getReturnValue:ret_buffer];
            ret_val = [NSValue valueWithBytes:ret_buffer objCType:[signature methodReturnType]];
            free(ret_buffer);
        }
        
        // return value
        return ret_val;
    }
    
    return nil;
    
}

@end
