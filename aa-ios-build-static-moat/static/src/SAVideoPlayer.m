/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAVideoPlayer.h"
#import "SABlackMask.h"
#import "SACronograph.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

// constants used by the video player to check for playback state
#define AV_END              AVPlayerItemDidPlayToEndTimeNotification
#define AV_NOEND            AVPlayerItemFailedToPlayToEndTimeNotification
#define AV_STALLED          AVPlayerItemPlaybackStalledNotification
#define AV_CHANGED          AVAudioSessionRouteChangeNotification
#define ENTER_BG            UIApplicationDidEnterBackgroundNotification
#define ENTER_FG            UIApplicationWillEnterForegroundNotification
#define AV_STATUS           @"status"
#define AV_RATE             @"rate"
#define AV_FULL             @"playbackBufferFull"
#define AV_EMPTY            @"playbackBufferEmpty"
#define AV_KEEPUP           @"playbackLikelyToKeepUp"
#define AV_TIME             @"loadedTimeRanges"

@interface SAVideoPlayer ()

// subviews
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) UIView *chrome;
@property (nonatomic, strong) SABlackMask *mask;
@property (nonatomic, strong) SACronograph *chrono;
@property (nonatomic, strong) SAURLClicker *clicker;

// state variables
@property (nonatomic, assign) BOOL isReadyHandled;
@property (nonatomic, assign) BOOL isStartHandled;
@property (nonatomic, assign) BOOL isFirstQuartileHandled;
@property (nonatomic, assign) BOOL isMidpointHandled;
@property (nonatomic, assign) BOOL isThirdQuartileHandled;
@property (nonatomic, assign) BOOL isEndHandled;
@property (nonatomic, assign) BOOL is15sHandled;

// notification center reference
@property (nonatomic, strong) NSNotificationCenter *notif;
@property (nonatomic, strong) NSObject *observer;

// buffer variables in case network is shaky and buffer goes empty too soon
@property (nonatomic, assign) BOOL shouldShowSmallClickButton;

@property (nonatomic, strong) saVideoPlayerDidReceiveEvent eventHandler;
@property (nonatomic, strong) saVideoPlayerDidReceiveClick clickHandler;

@end

@implementation SAVideoPlayer

/**
 * Overridden init method in case library user wants to init from code
 *
 * @return a new SAVideoPlayer instance
 */
- (id) init {
    if (self = [super init]) {
        _notif = [NSNotificationCenter defaultCenter];
        _shouldShowSmallClickButton = false;
        _eventHandler = ^(SAVideoPlayerEvent event) {};
        _clickHandler = ^(){};
    }
    return self;
}

/**
 * Overridden init method in case library user wants to init from XIB
 *
 * @return a new SAVideoPlayer instance
 */
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _notif = [NSNotificationCenter defaultCenter];
        _shouldShowSmallClickButton = false;
        _eventHandler = ^(SAVideoPlayerEvent event) {};
        _clickHandler = ^(){};
    }
    return self;
}

/**
 * Overridden init method in case library user wants to init with frame
 *
 * @return a new SAVideoPlayer instance
 */
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _notif = [NSNotificationCenter defaultCenter];
        _shouldShowSmallClickButton = false;
        _eventHandler = ^(SAVideoPlayerEvent event) {};
        _clickHandler = ^(){};
    }
    return self;
}

/**
 * Overridden dealloc method
 */
- (void) dealloc {
    NSLog(@"SAVideoPlayer dealloc");
}

/**
 * Internal setup method that sets up:
 * - the player
 * - aux chrome
 * - all state variables
 */
- (void) setup {
    self.backgroundColor = [UIColor blackColor];
    [self setupPlayer];
    [self setupChome];
    [self setupChecks];
}

/**
 * Internal setup method that inits a video view where the video will be
 * rendered by the AVPlayer / AVPlayerLayer instance
 */
- (void) setupPlayer {
    _videoView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_videoView];
}

/**
 * Internal setup method that inits:
 * - the chrome
 * - the mask
 * - the cronograph
 * - the clicker
 */
- (void) setupChome {
    _chrome = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_chrome];
    
    _mask = [[SABlackMask alloc] init];
    [_chrome addSubview:_mask];
    
    _chrono = [[SACronograph alloc] init];
    [_chrome addSubview:_chrono];
    
    _clicker = [[SAURLClicker alloc] init];
    _clicker.shouldShowSmallClickButton = _shouldShowSmallClickButton;
    [_clicker addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_chrome addSubview:_clicker];
}

/**
 * Internal setup method that inits all state variables with their default
 * values
 */
- (void) setupChecks {
    _isStartHandled =
    _isFirstQuartileHandled =
    _isMidpointHandled =
    _isThirdQuartileHandled =
    _isEndHandled =
    _is15sHandled = false;
}

- (void) destroy {
    [self destroyPlayer];
    [self destroyChrome];
}

/**
 * Internal method that makes sure the player is properly destroyed 
 * by pausing it, removing it from the view and remove all observers
 */
- (void) destroyPlayer {
    [_notif removeObserver:self name:AV_END object:nil];
    [_notif removeObserver:self name:AV_NOEND object:nil];
    [_notif removeObserver:self name:AV_STALLED object:nil];
    [_notif removeObserver:self name:AV_CHANGED object:nil];
    [_notif removeObserver:self name:ENTER_BG object:nil];
    [_notif removeObserver:self name:ENTER_FG object:nil];
    [_player removeObserver:self forKeyPath:AV_RATE context:nil];
    [_player removeTimeObserver:_observer];
    _observer = NULL;
    [_playerItem removeObserver:self forKeyPath:AV_STATUS context:nil];
    [_playerItem removeObserver:self forKeyPath:AV_FULL context:nil];
    [_playerItem removeObserver:self forKeyPath:AV_EMPTY context:nil];
    [_playerItem removeObserver:self forKeyPath:AV_KEEPUP context:nil];
    [_playerItem removeObserver:self forKeyPath:AV_TIME context:nil];
    
    
    if (_player){
        [_player pause];
        [_playerLayer removeFromSuperlayer];
        _playerItem = NULL;
        _playerLayer = NULL;
        _player = NULL;
    }
    
    [_videoView removeFromSuperview];
    _videoView = NULL;
}

/**
 * Internal method that makes sure all the chrome is destroyed
 */
- (void) destroyChrome {
    [_mask removeFromSuperview];
    [_chrono removeFromSuperview];
    [_clicker removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_clicker removeFromSuperview];
    [_chrome removeFromSuperview];
    _mask = NULL;
    _clicker = NULL;
    _chrono = NULL;
    _chrome = NULL;
}

- (void) updateToFrame:(CGRect)frame {
    self.frame = frame;
    _videoView.frame = self.bounds;
    _playerLayer.frame = _videoView.bounds;
    _chrome.frame = self.bounds;
    [self destroyChrome];
    [self setupChome];
}

- (void) reset {
    [self destroy];
    [self setup];
}

- (void) playWithMediaFile:(NSString *)file {
    
    // handle error case
    if (file == nil || file == (NSString*)[NSNull null] || [file isEqualToString:@""] || ![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        _eventHandler(Video_Error);
        return;
    }
    
    // if file isn't nil, then go forward and play it
    
    [self setup];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:file isDirectory:false];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = _videoView.bounds;
    [_videoView.layer addSublayer:_playerLayer];
    [_player play];
    
    [self setObservers];
}

/**
 * Internal method that sets all observers for the notification center as well
 * as for the player and player item
 */
- (void) setObservers {
    
    [_notif addObserver:self selector:@selector(playerItemDidReachEnd:) name:AV_END object:nil];
    [_notif addObserver:self selector:@selector(playerItemFailedToPlayEndTime:) name:AV_NOEND object:nil];
    [_notif addObserver:self selector:@selector(playerItemPlaybackStall:) name:AV_STALLED object:nil];
    [_notif addObserver:self selector:@selector(audioSessionChanged:) name:AV_CHANGED object:nil];
    [_notif addObserver:self selector:@selector(playerItemEnterBackground:) name:ENTER_BG object:nil];
    [_notif addObserver:self selector:@selector(playerItemEnterForeground:) name:ENTER_FG object:nil];
    [_player addObserver:self forKeyPath:AV_RATE options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:AV_STATUS options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:AV_EMPTY options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:AV_FULL options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:AV_KEEPUP options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:AV_TIME options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void) resume {
    [_player play];
}

- (void) pause {
    [_player pause];
}

/**
 * Internal method used to handle button clicks.
 *
 * @param sender  the button that send the click event
 */
- (void) onClick:(id)sender {
    _clickHandler();
}

- (void) showSmallClickButton {
    _shouldShowSmallClickButton = true;
}

- (void) setEventHandler:(saVideoPlayerDidReceiveEvent) handler {
    _eventHandler = handler != NULL ? handler : ^(SAVideoPlayerEvent event) {};
}

- (void) setClickHandler:(saVideoPlayerDidReceiveClick) handler {
    _clickHandler = handler != NULL ? handler :  ^(){};
}

- (AVPlayer*) getPlayer {
    return _player;
}

- (AVPlayerLayer*) getPlayerLayer {
    return _playerLayer;
}

/**
 * Method for the NSNotification center that tells when the video player
 * reached the end of the video content.
 *
 * @param notification the notification object that triggered the call
 */
- (void) playerItemDidReachEnd: (NSNotification*)notification {
    if (!_isEndHandled){
        _isEndHandled = true;
        _eventHandler(Video_End);
    }
}

/**
 * Method for the NSNotification center that tells that the video player
 * failed to reach the end.
 *
 * @param notification the notification object that triggered the call
 */
- (void) playerItemFailedToPlayEndTime: (NSNotification*)notification {
    
}

/**
 * Method for the NSNotification center that tells that the video player
 * has stalled in playing video.
 *
 * @param notification the notification object that triggered the call
 */
- (void) playerItemPlaybackStall: (NSNotification*)notification {
    [_player play];
}

/**
 * Method for the NSNotification center that tells that the video player
 * entered background mode and should pause.
 *
 * @param notification the notification object that triggered the call
 */
- (void) playerItemEnterBackground: (NSNotification*)notification {
    [_player pause];
}

/**
 * Method for the NSNotification center that tells that the video player
 * entered foreground mode and should resume.
 *
 * @param notification the notification object that triggered the call
 */
- (void) playerItemEnterForeground: (NSNotification*)notification {
    [_player play];
}

/**
 * Method for the NSNotification center that tells that the video player
 * has changed audio session and should force playing again.
 *
 * @param notification the notification object that triggered the call
 */
- (void) audioSessionChanged: (NSNotification*) notification {
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        [_player play];
    }
}

/**
 * Over value for KVO for the video player.
 *
 * @param keyPath   the current key path that has changed
 * @param object    the object that sent the change
 * @param change    a dictionary containing the old and the new values
 * @param context   the current context
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if (object == _player && [keyPath isEqualToString:AV_RATE]){
        NSLog(@"[KVO] %@ %f", AV_RATE, _player.rate);
    }
    if (object == _playerItem && [keyPath isEqualToString:AV_STATUS]) {
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [_player play];
            NSLog(@"[KVO] %@: Ready", AV_STATUS);
            
            // weak self so I don't have a retain cycle in the block
            __weak typeof (self) weakSelf = self;
            
            _observer = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime currentTime) {
                
                // update current time
                CGFloat time = CMTimeGetSeconds(currentTime);
                CGFloat duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
                NSInteger remaining = (NSInteger)(duration - time);
                
                // each tick update chrono
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.chrono setTime:remaining];
                });
                
                // send events through delegation
                if (time >= 1 && !weakSelf.isStartHandled) {
                    weakSelf.isStartHandled = true;
                    weakSelf.eventHandler(Video_Start);
                };
                
                if (time >= (duration / 4) && !weakSelf.isFirstQuartileHandled){
                    weakSelf.isFirstQuartileHandled = true;
                    weakSelf.eventHandler(Video_1_4);
                }
                
                if (time >= (duration / 2) && !weakSelf.isMidpointHandled){
                    weakSelf.isMidpointHandled = true;
                    weakSelf.eventHandler(Video_1_2);
                }
                
                if (time >= (3 * duration / 4) && !weakSelf.isThirdQuartileHandled) {
                    weakSelf.isThirdQuartileHandled = true;
                    weakSelf.eventHandler(Video_3_4);
                }
                
                if (time >= 15.0f && !weakSelf.is15sHandled) {
                    weakSelf.is15sHandled = true;
                    weakSelf.eventHandler(Video_15s);
                }
            }];
        }
        if (_playerItem.status == AVPlayerItemStatusUnknown) {
            NSLog(@"[KVO] %@: Unknown", AV_STATUS);
        }
    }
    if (object == _playerItem && [keyPath isEqualToString:AV_FULL]) {
        NSLog(@"[KVO] %@ %d", AV_FULL, _playerItem.isPlaybackBufferFull);
    }
    if (object == _playerItem && [keyPath isEqualToString:AV_KEEPUP]) {
        NSLog(@"[KVO] %@ %d", AV_KEEPUP, _playerItem.isPlaybackLikelyToKeepUp);
    }
}
@end
