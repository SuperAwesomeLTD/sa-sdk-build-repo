//
//  SACronograph.m
//  TestVASTParser
//
//  Created by Gabriel Coman on 15/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "SACronograph.h"

//
// @brief: Category for label
@interface UILabel (Chronograph)
+ (UILabel*)createChrono;
@end

@implementation UILabel (Cronograph)

+ (UILabel*) createChrono {
    UILabel *chrono = [[UILabel alloc] init];
    
    chrono.backgroundColor = [UIColor clearColor];
    chrono.textColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
    chrono.font = [UIFont systemFontOfSize:10];
    chrono.textAlignment = NSTextAlignmentLeft;
    
    return chrono;
}

@end

@interface SACronograph ()

// parent frame
@property (nonatomic, assign) CGRect parentFrame;

// subviews
@property (nonatomic, strong) UILabel *adLabel;

@end

@implementation SACronograph

// customize init
- (id) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) didMoveToSuperview {
    // get the parent frame
    _parentFrame = self.superview.frame;
    
    // setup own frame
    CGFloat H = 20.0f;
    CGFloat W = 50.0f;
    CGFloat X = 10.0f;
    CGFloat Y = _parentFrame.size.height - 30.0f;
    self.frame = CGRectMake(X, Y, W, H);
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.25];
    self.layer.cornerRadius = 5.0f;
    
    // add the two other label
    _adLabel = [UILabel createChrono];
    _adLabel.text = @"";
    _adLabel.textAlignment = NSTextAlignmentCenter;
    _adLabel.frame = CGRectMake(0, 0, 50, 20);
    [self addSubview:_adLabel];
}

- (void) setTime:(NSInteger)remaining {
    _adLabel.text = [NSString stringWithFormat:@"Ad: %ld", (long)remaining];
}

@end
