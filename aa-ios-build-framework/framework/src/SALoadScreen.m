/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SALoadScreen.h"

@interface SALoadScreen ()

// reference to the window
@property (nonatomic, strong) UIWindow                  *win;

// a new back-window (basically the background)
@property (nonatomic, strong) UIView                    *backView;

// a new activity indicator view
@property (nonatomic, strong) UIActivityIndicatorView   *activityView;

@end

@implementation SALoadScreen

+ (instancetype) getInstance {
    static SALoadScreen *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

/**
 * Overridden init method that copies the window reference
 */
- (id) init {
    if (self = [super init]) {
        _win = [[[UIApplication sharedApplication] delegate] window];
    }
    
    return self;
}

- (void) show {
    CGRect frame = [UIScreen mainScreen].bounds;
    _backView = [[UIView alloc] initWithFrame:frame];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = _backView.center;
    [_backView addSubview:_activityView];
    
    [_win addSubview:_backView];
    [_activityView startAnimating];
}

- (void) hide {
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    [_backView removeFromSuperview];
}

@end
