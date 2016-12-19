//
//  KWSGetScore.h
//  Pods
//
//  Created by Gabriel Coman on 24/08/2016.
//
//

#import "KWSService.h"
#import "KWSScore.h"

typedef void (^gotScore)(KWSScore *score);

@interface KWSGetScore : KWSService
- (void) execute:(gotScore)gotscore;
@end
