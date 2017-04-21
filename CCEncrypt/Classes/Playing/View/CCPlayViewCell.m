//
//  CCPlayViewCell.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayViewCell.h"

#import <IJKMediaFramework/IJKMediaFramework.h>
#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIView+YYAdd.h>

#import "CCPlaysCollect.h"

#import "CCDefines.h"
#import "CCLoadingView.h"
#import "CCPlayShowView.h"

@interface CCPlayViewCell ()

/** 退出按钮 */
@property (nullable, nonatomic, weak) UIButton *exitButton;
/** IJKFFMoviePlayerController */
@property (nullable, nonatomic, strong) IJKFFMoviePlayerController *ffmoviePlayer;
/** 模糊背景图片 */
@property (nullable, nonatomic, weak) UIImageView *backBlurImageView;
/** CCPlayShowView */
@property (nullable, nonatomic, weak) CCPlayShowView *playShowView;

@end

@implementation CCPlayViewCell

#pragma mark - Reload
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _layoutSubviews];
}

- (void)dealloc {
    [self _dealloc];
}

#pragma mark - Common
- (void)_layoutSubviews {
    CGRect bounds = self.bounds;

    self.backBlurImageView.frame = bounds;

    // 加播放内容
    self.ffmoviePlayer.view.frame = bounds;
    
    // 加showView
    self.playShowView.frame = bounds;
    
    // 加 exitButton
    CGFloat btnWH = 40.0;
    CGFloat btnX = bounds.size.width - btnWH - kMFifteen;
    CGFloat btnY = bounds.size.height - btnWH - kMFifteen;
    self.exitButton.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    
    [self trimSubViewsWhenNoPlay];
}

- (void)_dealloc {
    if (_ffmoviePlayer && _ffmoviePlayer.isPlaying) {
        [self stopPlay];
    }
    [self removePlayView];
    [CCLoadingView hideLoadingView];
}


#pragma mark - Special
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ffmoviePlayer];
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ffmoviePlayer];
}

- (void)stopPlay {
    [self.ffmoviePlayer shutdown];
}

- (void)preparePlay {
    [self.ffmoviePlayer prepareToPlay];
}

- (void)removePlayView {
    [_ffmoviePlayer.view removeFromSuperview];
    _ffmoviePlayer = nil;
}

- (void)trimSubViewsWhenNoPlay {
//    [_ffmoviePlayer.view insertSubview:nil atIndex:0];
    [self sendSubviewToBack:_ffmoviePlayer.view];
    
    [self bringSubviewToFront:_backBlurImageView];
    
    [self bringSubviewToFront:_exitButton];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)trimSubViewsWhenPlaying {
    [CCLoadingView hideLoadingView];
    
    [_backBlurImageView removeFromSuperview];
    _backBlurImageView = nil;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)updateSubviews {
    // 设置图片
    YYImageCache *imageCache = [YYWebImageManager sharedManager].cache;
    UIImage *backBlurImage = nil;
    if ([[YYWebImageManager sharedManager].cache containsImageForKey:_playsCollect.currentItem.bigpic]) {
        backBlurImage = [[imageCache getImageForKey:_playsCollect.currentItem.bigpic] imageByBlurLight];
    } else {
        backBlurImage = [[UIImage imageNamed:kPlayPlaceHold] imageByBlurLight];
    }
    [self.backBlurImageView setImage:backBlurImage];
    
    self.playShowView.item = _playsCollect.currentItem;
    
    [self setNeedsLayout];
}


#pragma mark - Event
- (void)handleDidExitEvent {
    [self stopPlay];
    
    [self removePlayView];
    
    [CCLoadingView hideLoadingView];
    
    [self removeMovieNotificationObservers];
    
    if (_delegate && [_delegate respondsToSelector:@selector(playViewCellDidExitPlay:)]) {
        [_delegate playViewCellDidExitPlay:self];
    }
}


- (void)loadStateDidChange:(NSNotification*)notification {
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,  // 可以播放
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, //  播放通过成功
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _ffmoviePlayer.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        if (!_ffmoviePlayer.isPlaying) {
            [_ffmoviePlayer play];
        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_ffmoviePlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_ffmoviePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_ffmoviePlayer.playbackState);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self trimSubViewsWhenPlaying];
                });
            });
            [CCLoadingView hideLoadingView];
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            [CCLoadingView showLoadingView];
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_ffmoviePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            [CCLoadingView showLoadingView];
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_ffmoviePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_ffmoviePlayer.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_ffmoviePlayer.playbackState);
            break;
        }
    }
}

#pragma mark - Protocol


#pragma mark - Lazy
- (void)setPlaysCollect:(CCPlaysCollect *)playsCollect {
    _playsCollect = playsCollect;
    
    [CCLoadingView showLoadingView];
    
    // 结束前面的
    [self removeMovieNotificationObservers];
    
    [self stopPlay];
    [self removePlayView];
    
    // 设置新的数据
    [self updateSubviews];
    
    [self preparePlay];
    
    [self installMovieNotificationObservers];
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton setImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(handleDidExitEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:exitButton];
        _exitButton = exitButton;
    }
    return _exitButton;
}

/**
 *  懒加载 IJKFFMoviePlayerController 对象
 */
- (IJKFFMoviePlayerController *)ffmoviePlayer {
    if (!_ffmoviePlayer) {
        
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//        [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
        // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        [options setPlayerOptionIntValue:29.97 forKey:@"r"];
        // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
        [options setPlayerOptionIntValue:512 forKey:@"vol"];
        
        [IJKFFMoviePlayerController setLogReport:NO];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_UNKNOWN];
        
        /// 创建 IJKFFMoviePlayerController
        /// 参数一: 初始化播放路径, 如果为空, 创建不成功, 并且该类中没有暴露可以修改内部存储该路径的方法
        ///        猜测如果需要更换路径, 必须重新创建播放器
        /// 参数二: 播放配置, 如果为 nil, 内部会自动赋值为 [IJKFFOptions optionsByDefault] 默认配置
        _ffmoviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:_playsCollect.currentItem.flv withOptions:options];
        _ffmoviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
        _ffmoviePlayer.shouldAutoplay = NO;
        _ffmoviePlayer.view.userInteractionEnabled = NO;
        [_ffmoviePlayer setPauseInBackground:YES];
        [self.contentView insertSubview:_ffmoviePlayer.view atIndex:0];
    }
    return _ffmoviePlayer;
}

- (UIImageView *)backBlurImageView {
    if (!_backBlurImageView) {
        UIImageView *backBlurImageView = [UIImageView new];
        backBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView insertSubview:backBlurImageView belowSubview:self.exitButton];
        _backBlurImageView = backBlurImageView;
    }
    return _backBlurImageView;
}

- (CCPlayShowView *)playShowView {
    if (!_playShowView) {
        CCPlayShowView *playShowView = [CCPlayShowView playShowView];
//        [self.contentView addSubview:playExtView];
        [self.contentView insertSubview:playShowView belowSubview:self.exitButton];
        _playShowView = playShowView;
    }
    return _playShowView;
}


@end
