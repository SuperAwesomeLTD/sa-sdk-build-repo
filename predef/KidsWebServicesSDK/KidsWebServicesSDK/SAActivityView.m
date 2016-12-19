//
//  SAActivityView.m
//  Pods
//
//  Created by Gabriel Coman on 07/07/2016.
//
//

#import "SAActivityView.h"

@interface SAActivityView ()
@property (nonatomic, strong) UIWindow *win;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation SAActivityView

// MARK: Initializers

+ (instancetype) sharedManager {
    static SAActivityView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    if (self = [super init]) {
        _win = [[[UIApplication sharedApplication] delegate] window];
    }
    
    return self;
}

// MARK: Class methods

- (void) showActivityView {
    CGRect frame = [UIScreen mainScreen].bounds;
    _backView = [[UIView alloc] initWithFrame:frame];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = _backView.center;
    [_backView addSubview:_activityView];
    
    [_win addSubview:_backView];
    [_activityView startAnimating];
}

- (void) hideActivityView {
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    [_backView removeFromSuperview];
}

@end
