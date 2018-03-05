/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAURLClicker.h"

@implementation SAURLClicker

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
 * Overridden init method that sets the background color as transparent
 *
 * @param frame the frame of the clicker
 * @return      an instance of the cronograph
 */
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/**
 * Overridden "didMoveToSuperview" that resizes the clicker to
 * the correct size for the video (usually the superview in question)
 * every time it in turn changes.
 */
- (void) didMoveToSuperview {
    
    // case when it should be as big as the whole video
    if (!_shouldShowSmallClickButton) {
        CGRect parentFrame = self.superview.frame;
        self.frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);
        [self setBackgroundColor:[UIColor clearColor]];
    }
    // case when it's a small button
    else {
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Find out more »"];
        [titleString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1]
                            range:NSMakeRange(0, titleString.length)];
        [self setAttributedTitle:titleString forState:UIControlStateNormal];
        
        CGRect parentFrame = self.superview.frame;
        self.frame = CGRectMake(70.0, parentFrame.size.height - 30, 100, 20);
        
        [[self titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [self setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}

@end
