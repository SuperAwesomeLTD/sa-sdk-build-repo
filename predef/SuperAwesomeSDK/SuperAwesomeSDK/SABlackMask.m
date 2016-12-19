//
//  SABlackMask.m
//  Pods
//
//  Created by Gabriel Coman on 08/01/2016.
//
//

#import "SABlackMask.h"
#import "SAVideoPlayer.h"

@implementation SABlackMask

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void) didMoveToSuperview {
    self.backgroundColor = [UIColor clearColor];
    CGRect _parentFrame = self.superview.frame;
    self.alpha = 0.75f;
    self.frame = CGRectMake(0, _parentFrame.size.height - 40, _parentFrame.size.width, 40);
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    layer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    layer.startPoint = CGPointMake(1, 0.7);
    layer.endPoint = CGPointMake(1, 0.0);
    [self.layer addSublayer:layer];
}
@end
