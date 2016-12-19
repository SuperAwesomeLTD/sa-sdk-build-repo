//
//  KWSGetScore.m
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSGetScore.h"

@interface KWSGetScore ()
@property (nonatomic, strong) gotScore gotscore;
@end

@implementation KWSGetScore

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/score", (long)loggedUser.metadata.appId];
}

- (KWS_HTTP_METHOD) getMethod {
    return GET;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _gotscore(nil);
    } else {
        if (status == 200 && payload) {
            KWSScore *score = [[KWSScore alloc] initWithJsonString:payload];
            _gotscore(score);
        } else {
            _gotscore(nil);
        }
    }
}

- (void) execute:(gotScore)gotscore {
    _gotscore = gotscore  ? gotscore : ^(KWSScore *score){};
    [super execute];
}

@end
