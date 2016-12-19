//
//  KWSAuthUser.m
//  Pods
//
//  Created by Gabriel Coman on 11/10/2016.
//
//

#import "KWSGetAccessTokenAuth.h"
#import "KWS.h"
#import "KWSAccessToken.h"

@interface KWSGetAccessTokenAuth ()
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) gotAccessTokenAuth gotAccessTokenAuth;
@end

@implementation KWSGetAccessTokenAuth

- (id) init {
    if (self = [super init]) {
        _gotAccessTokenAuth = ^(KWSAccessToken* accessToken) {};
    }
    return self;
}

- (NSString*) getEndpoint {
    return @"oauth/token";
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (BOOL) needsLoggedUser {
    return false;
}

- (NSDictionary*) getBody {
    return @{
        @"grant_type": @"password",
        @"username": nullSafe(_username),
        @"password": nullSafe(_password)
    };
}

- (NSDictionary*) getHeader {
    return @{
        @"Content-Type" : @"application/x-www-form-urlencoded",
        @"Authorization": @"Basic c3VwZXJhd2Vzb21lY2x1YjpzdXBlcmF3ZXNvbWVjbHVi"
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _gotAccessTokenAuth (nil);
    } else {
        if (status == 200 && payload != nil) {
            KWSAccessToken *accessToken = [[KWSAccessToken alloc] initWithJsonString:payload];
            
            if (accessToken.access_token) {
                _gotAccessTokenAuth (accessToken);
            } else {
                _gotAccessTokenAuth (nil);
            }
            
        } else {
            _gotAccessTokenAuth (nil);
        }
    }
}

- (void) execute:(NSString *)username andPassword:(NSString *)password :(gotAccessTokenAuth) gotAccessTokenAuth{
    _username = username;
    _password = password;
    _gotAccessTokenAuth = gotAccessTokenAuth ? gotAccessTokenAuth : _gotAccessTokenAuth;
    
    // create endpoint
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", [[KWS sdk] getKWSApiUrl], [self getEndpoint]];
    // create url
    NSURL *url = [NSURL URLWithString:endpoint];
    
    // create the requrest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set headers
    NSDictionary *header = [self getHeader];
    if (header != NULL && header.allKeys.count > 0) {
        for (NSString *key in header.allKeys) {
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    // set post data
    NSDictionary *body = [self getBody];
    if (body != NULL && body.allKeys.count > 0) {
        NSMutableArray *bodyParams = [@[] mutableCopy];
        for (NSString *key in body.allKeys) {
            [bodyParams addObject:[NSString stringWithFormat:@"%@=%@", key, [body objectForKey:key]]];
        }
        NSString *bodyStr = [bodyParams componentsJoinedByString:@"&"];
        NSData *bodyData = [bodyStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:bodyData];
    }
    
    // configure the session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable httpresponse, NSError * _Nullable error) {
        
        // get actual result
        NSInteger status = ((NSHTTPURLResponse*)httpresponse).statusCode;
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // handle two failure cases
        if (error != NULL || data == NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self successWithStatus:status andPayload:nil andSuccess:false];
            });
            return;
        }
        
        // send response on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self successWithStatus:status andPayload:payload andSuccess:true];
        });
    }];
    // start the session
    [task resume];
}

@end
