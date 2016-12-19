//
//  KWSRequest.h
//  Pods
//
//  Created by Gabriel Coman on 27/07/2016.
//
//

#import <UIKit/UIKit.h>
#import "KWSMetadata.h"
#import "KWSLoggedUser.h"

typedef NS_ENUM(NSInteger, KWS_HTTP_METHOD) {
    GET,
    POST,
    PUT
};

@protocol KWSServiceProtocol <NSObject>

- (NSString*) getEndpoint;
- (KWS_HTTP_METHOD) getMethod;
- (NSDictionary*) getQuery;
- (NSDictionary*) getHeader;
- (NSDictionary*) getBody;
- (BOOL) needsLoggedUser;
- (void) successWithStatus:(NSInteger)status andPayload:(NSString*)payload andSuccess:(BOOL) success;

@end

@interface KWSService : NSObject <KWSServiceProtocol> {
    NSString *kwsApiUrl;
    NSString *version;
    KWSLoggedUser *loggedUser;
}

// request basic functions
- (void) execute;
- (void) execute:(id)param;

@end
