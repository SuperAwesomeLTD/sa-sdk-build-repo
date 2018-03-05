/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAViewableModule.h"
#import "SAUtils.h"

#define MAX_DISPLAY_TICKS   1
#define MAX_VIDEO_TICKS     2

@interface SAViewableModule ()
@property (nonatomic, strong) NSTimer *viewabilityTimer;
@end

@implementation SAViewableModule

- (void) checkViewableImpressionForView:(UIView*) view
                               andTicks:(NSInteger) maxTicks
                           withResponse:(saDidFindViewOnScreen) response {
    
    // safety check
    if (view == nil) {
        if (response != nil) {
            response (false);
        }
        return;
    }
    
    // destroy previosus timer, if it exists
    if (_viewabilityTimer != NULL) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = NULL;
    }
    
    // start timer
    __block NSInteger ticks = 0;
    __block NSInteger cticks = 0;
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:[NSBlockOperation blockOperationWithBlock:^{
        
        if (ticks >= maxTicks) {
            [self.viewabilityTimer invalidate];
            self.viewabilityTimer = nil;
            
            // success case
            if (cticks == maxTicks) {
                if (response) {
                    response (true);
                }
            }
            // error case
            else {
                if (response != nil) {
                    response (false);
                }
            }
        } else {
            ticks++;
            
            CGRect childR = view.frame;
            CGRect superR = CGRectMake(0, 0, view.superview.frame.size.width, view.superview.frame.size.height);
            CGRect screenR = [UIScreen mainScreen].bounds;
            
            if ([SAUtils isRect:childR inRect:screenR] && [SAUtils isRect:childR inRect:superR]) {
                cticks++;
            }
            
            NSLog(@"[AA :: Info] Tick %ld/%ld - Viewability Count %ld/%ld", (long)ticks, (long)maxTicks, (long)cticks, (long)maxTicks);
        }
        
    }] selector:@selector(main) userInfo:nil repeats:YES];
    
    // fire the timer
    [_viewabilityTimer fire];
    
}

- (void) checkViewableImpressionForDisplay: (UIView*) view
                               andResponse: (saDidFindViewOnScreen) response {
    [self checkViewableImpressionForView:view
                                andTicks:MAX_DISPLAY_TICKS
                            withResponse:response];
}

- (void) checkViewableImpressionForVideo: (UIView*) view
                            andResponse: (saDidFindViewOnScreen) response {
    [self checkViewableImpressionForView:view
                                andTicks:MAX_VIDEO_TICKS
                            withResponse:response];
}

- (void) close {
    if (_viewabilityTimer != NULL) {
        [_viewabilityTimer invalidate];
    }
    
    _viewabilityTimer = NULL;
}

@end
