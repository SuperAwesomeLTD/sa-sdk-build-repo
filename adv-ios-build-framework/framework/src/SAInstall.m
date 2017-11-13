/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAInstall.h"

@implementation SAInstall

/**
 * Classic init method
 */
- (id) init {
    if (self = [super init]) {
        // do nothing
    }
    
    return self;
}

- (NSString*) getInstallUrl:(SAdvConfiguration) configuration {
    if (configuration == advPRODUCTION) {
        return @"https://ads.superawesome.tv/v2/install";
    } else {
        return @"https://ads.staging.superawesome.tv/v2/install";;
    }
}

- (NSDictionary*) getInstallQuery:(NSString *)targetPackageName {
    if (targetPackageName) {
        return @{ @"bundle" : targetPackageName };
    } else {
        return @{};
    }
}

- (NSDictionary*) getInstallHeader {
    return @{
             @"Content-Type": @"application/json",
             @"User-Agent": [SAAdvUtils getUserAgent]
             };
}

- (void) sendInstallEventToServer:(NSString *)targetPackageName
                 andConfiguration:(SAdvConfiguration) configuration
                      andResponse:(saDidCountAnInstall)response {
    
    // get the event url
    NSString *endpoint = [self getInstallUrl: configuration];
    
    // get the query
    NSDictionary *query = [self getInstallQuery:targetPackageName];
    
    // get the header
    NSDictionary *header = [self getInstallHeader];
    
    // form main URL
    __block NSMutableString *_mendpoint = [endpoint mutableCopy];
    if (query != nil && query != (NSDictionary*)[NSNull null] && query.allKeys.count > 0) {
        [_mendpoint appendString:@"?"];
        [_mendpoint appendString:[SAAdvUtils formGetQueryFromDict:query]];
    }
    
    // get the actual URL
    NSURL *url = [NSURL URLWithString:_mendpoint];
    
    // create the requrest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    // set headers
    if (header != nil && header != (NSDictionary*)[NSNull null] && header.allKeys.count > 0) {
        for (NSString *key in header.allKeys) {
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    // get the response handler
    id resp = ^(NSData *data, NSURLResponse *httpresponse, NSError *error) {
        
        // handle two failure cases
        if (error != nil || data == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //
                // log event
                NSLog(@"[false] | HTTP %@ | 0 | %@", @"GET", _mendpoint);
                
                //
                // send back
                if (response != nil) {
                    response(false);
                }
            });
            return;
        }
        
        // get actual result
        NSInteger status = ((NSHTTPURLResponse*)httpresponse).statusCode;
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // send response on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //
            // log event
            NSLog(@"[true] | HTTP %@ | %ld | %@", @"GET", (long)status, _mendpoint);
            
            //
            // send back
            if (payload != nil && [payload rangeOfString:@"true"].location > -1) {
                if (response != nil) {
                    response (true);
                }
            } else {
                if (response != nil) {
                    response (false);
                }
            }
        });
    };
    
    // start the session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:resp];
    [task resume];
    
}

@end
