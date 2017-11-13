/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVerifyInstall.h"
#import "SAOnce.h"

@implementation SAVerifyInstall

+ (instancetype) getInstance {
    static SAVerifyInstall *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

/**
 * Private constructor that is only called once
 */
- (id) init {
    if (self = [super init]) {
        // do nothing
    }
    
    return self;
}

- (void) handleInstall:(saDidCountAnInstall)response {
    [self handleInstall:[SAAdvUtils getBundleId] andConfiguration:advPRODUCTION withResponse:response];
}

- (void) handleInstall: (NSString*) target
      andConfiguration: (SAdvConfiguration) configuration
          withResponse: (saDidCountAnInstall) response {
    
    __block SAOnce    *once    = [[SAOnce alloc] init];
    SAInstall         *install = [[SAInstall alloc] init];
    
    // check to see if the CPI event has already been sent
    BOOL isSent = [once isCPISent];
    
    // if it hasn't ...
    if (!isSent) {
        
        // proceed with sending the install event
        [install sendInstallEventToServer:target
                         andConfiguration:configuration
                              andResponse:^(BOOL success) {
                                  
                                  // and once done, set the CPI event as sent
                                  [once setCPISent];
                                  
                                  // and send back a response to the user
                                  if (response) {
                                      response (success);
                                  }
                                  
                              }];
        
    }
}

@end
