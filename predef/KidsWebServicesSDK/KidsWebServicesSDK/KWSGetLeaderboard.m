//
//  KWSGetLeaderboard.m
//  Pods
//
//  Created by Gabriel Coman on 28/07/2016.
//
//

#import "KWSGetLeaderboard.h"

@interface KWSGetLeaderboard ()
@property (nonatomic, strong) gotLeaderboard gotleaderboard;
@end

@implementation KWSGetLeaderboard

- (NSString*) getEndpoint {
    return [NSString stringWithFormat:@"v1/apps/%ld/leaders", (long)loggedUser.metadata.appId];
}

- (KWS_HTTP_METHOD) getMethod {
    return GET;
}

- (void) successWithStatus:(NSInteger)status andPayload:(NSString *)payload andSuccess:(BOOL)success {
    if (!success) {
        _gotleaderboard(@[]);
    } else {
        if ((status == 200 || status == 204) && payload) {
            KWSLeaderboard *leaderboard = [[KWSLeaderboard alloc] initWithJsonString:payload];
            _gotleaderboard(leaderboard.results);
        } else {
            _gotleaderboard(@[]);
        }
    }
}

- (void) execute:(gotLeaderboard)gotleaderboard {
    _gotleaderboard = gotleaderboard  ? gotleaderboard : ^(NSArray*leaders){};
    [super execute];
}

@end
