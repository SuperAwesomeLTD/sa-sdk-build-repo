//
//  SANetwork.m
//  Pods
//
//  Created by Gabriel Coman on 05/07/2016.
//
//

#import "SARequest.h"

// callback for iOS's own [NSURLConnection sendAsynchronousRequest:]
typedef void (^netResponse)(NSData *data, NSURLResponse *response, NSError *error);

@implementation SARequest

- (void) sendRequestTo:(NSString*)endpoint
            withMethod:(NSString*)method
              andQuery:(NSDictionary*)query
             andHeader:(NSDictionary*)header
               andBody:(NSDictionary*)body
         withResponse:(response) response {
    
    // check url
    if (endpoint == nil || endpoint == (NSString*)[NSNull null]) {
        response(0, nil, false);
        return;
    }
    
    // form main URL
    __block NSMutableString *_mendpoint = [endpoint mutableCopy];
    if (query != nil && query != (NSDictionary*)[NSNull null] && query.allKeys.count > 0) {
        [_mendpoint appendString:@"?"];
        [_mendpoint appendString:[self formGetQueryFromDict:query]];
    }
    
    // get the actual URL
    NSURL *url = [NSURL URLWithString:_mendpoint];
    
    // create the requrest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:method];
    
    // set headers
    if (header != nil && header != (NSDictionary*)[NSNull null] && header.allKeys.count > 0) {
        for (NSString *key in header.allKeys) {
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    // set body, if post
    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) &&
         body != nil && body != (NSDictionary*)[NSNull null] && body.allKeys.count > 0) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    // get the response handler
    netResponse resp = ^(NSData *data, NSURLResponse *httpresponse, NSError *error) {
        
        // handle two failure cases
        if (error != nil || data == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"[false] | HTTP %@ | 0 | %@", method, _mendpoint);
                if (response != nil) {
                    response(0, nil, false);
                }
            });
            return;
        }
        
        // get actual result
        NSInteger status = ((NSHTTPURLResponse*)httpresponse).statusCode;
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // send response on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[true] | HTTP %@ | %ld | %@", method, (long)status, _mendpoint);
            if (response != nil) {
                response(status, payload, true);
            }
        });
    };
    
    // start the session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:resp];
    [task resume];
}

- (void) sendGET:(NSString*)endpoint
       withQuery:(NSDictionary*)query
       andHeader:(NSDictionary*)header
    withResponse:(response)response {
    [self sendRequestTo:endpoint withMethod:@"GET" andQuery:query andHeader:header andBody:nil withResponse:response];
}

- (void) sendPOST:(NSString*)endpoint
        withQuery:(NSDictionary*)query
        andHeader:(NSDictionary*)header
          andBody:(NSDictionary*)body
     withResponse:(response)response {
    [self sendRequestTo:endpoint withMethod:@"POST" andQuery:query andHeader:header andBody:body withResponse:response];
}

- (void) sendPUT:(NSString *)endpoint
       withQuery:(NSDictionary *)query
       andHeader:(NSDictionary *)header
         andBody:(NSDictionary *)body
    withResponse:(response)response {
    [self sendRequestTo:endpoint withMethod:@"PUT" andQuery:query andHeader:header andBody:body withResponse:response];
}

// MARK: Private

- (NSString*) formGetQueryFromDict:(NSDictionary *)dict {
    NSMutableString *query = [[NSMutableString alloc] init];
    NSMutableArray *getParams = [[NSMutableArray alloc] init];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [getParams addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    [query appendString:[getParams componentsJoinedByString:@"&"]];
    
    return query;
}

@end
