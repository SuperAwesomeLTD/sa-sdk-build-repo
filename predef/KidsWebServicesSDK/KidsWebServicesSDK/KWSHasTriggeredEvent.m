//
//  KWSHasTriggeredEvent.m
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSHasTriggeredEvent.h"
#import "KWSEventStatus.h"

@interface KWSHasTriggeredEvent ()
@property (nonatomic, strong) hasTriggered hastriggered;
@property (nonatomic, assign) NSInteger eventId;
@end

@implementation KWSHasTriggeredEvent

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/users/%ld/has-triggered-event", (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (NSDictionary*) getBody {
    return @{
        @"eventId": @(_eventId)
    };
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _hastriggered(false);
    } else {
        if (payload && status == 200) {
            KWSEventStatus *status = [[KWSEventStatus alloc] initWithJsonString:payload];
            _hastriggered(status.hasTriggeredEvent);
        } else {
            _hastriggered(false);
        }
    }
}

- (void) execute:(NSInteger)eventId :(hasTriggered)triggered {
    _eventId = eventId;
    _hastriggered = triggered ? triggered : ^(BOOL success) {};
    [super execute];
}

@end
