//
//  KWSTriggerEvent.m
//  Pods
//
//  Created by Gabriel Coman on 08/08/2016.
//
//

#import "KWSTriggerEvent.h"

@interface KWSTriggerEvent ()
@property (nonatomic, strong) NSString *evtToken;
@property (nonatomic, assign) NSInteger evtPoints;
@property (nonatomic, strong) triggered triggered;
@end

@implementation KWSTriggerEvent

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/users/%ld/trigger-event", (long)loggedUser.metadata.userId];
}

- (KWS_HTTP_METHOD) getMethod {
    return POST;
}

- (NSDictionary*) getBody {
    NSMutableDictionary *evtDict = [@{} mutableCopy];
    if (_evtToken != NULL) {
        [evtDict setObject:_evtToken forKey:@"token"];
    }
    [evtDict setValue:@(_evtPoints) forKey:@"points"];
    return evtDict;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    _triggered (success && (status == 200 || status == 204));
}

- (void) execute:(NSString *)token points:(NSInteger)points :(triggered)triggered {
    _evtToken = token;
    _evtPoints = points;
    _triggered = triggered ? triggered : ^(BOOL success){};
    [super execute];
}

@end
