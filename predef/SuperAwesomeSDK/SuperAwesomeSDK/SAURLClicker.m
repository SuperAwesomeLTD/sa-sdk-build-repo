//
//  SAURLClicker.m
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import "SAURLClicker.h"

@implementation SAURLClicker

- (id) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) didMoveToSuperview {
    if (!_shouldShowSmallClickButton) {
        CGRect parentFrame = self.superview.frame;
        self.frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
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
