/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SACronograph.h"

/**
 * Category class for "UILabel" that adds the "createChrono" method.
 */
@interface UILabel (Chronograph)

/**
 * Factory method that creates a special type of label, suitable to act as a 
 * timer for a video.
 */
+ (UILabel*) createChrono;

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

// the cronograph parent frame
@property (nonatomic, assign) CGRect parentFrame;

// the ad label defining the chronograph
@property (nonatomic, strong) UILabel *adLabel;

@end

@implementation SACronograph

/**
 * Overridden init method that sets the background color as transparent
 *
 * @return an instance of the cronograph
 */
- (id) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/**
 * Overridden "didMoveToSuperview" that resizes the cronograph to
 * the correct size for the video (usually the superview in question)
 * every time it in turn changes.
 */
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
