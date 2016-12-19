//
//  SACPI.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "SACPI.h"

// guarded imports
#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAEvents/SAEvents.h>)
#import <SAEvents/SAEvents.h>
#else
#import "SAEvents.h"
#endif
#endif

#define CPI_INSTALL @"CPI_INSTALL"

@interface SACPI ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SACPI

- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void) sendCPIEvent {
    
    if (![_defs objectForKey:CPI_INSTALL]) {

        NSLog(@"[AA :: Events] Sending CPI event");
        
        SASession *session = [[SASession alloc] init];
        [session setConfigurationProduction];
        
        // form the URL
        NSString *cpiURL = [NSString stringWithFormat:@"%@/install?bundle=%@",
                            [session getBaseUrl],
                            [session getBundleId]];
        
        // use saevent to send CPI event
        SAEvents *events = [[SAEvents alloc] init];
        [events sendEventToURL:cpiURL];
        [_defs setObject:@(true) forKey:CPI_INSTALL];
        [_defs synchronize];
    } else {
        NSLog(@"[AA :: Events] Already sent CPI event");
    }
}

@end
