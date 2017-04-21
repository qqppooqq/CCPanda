//
//  CCPlayingController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/9.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayingController.h"

#import <IJKMediaFramework/IJKMediaFramework.h>

#import "CCDefines.h"

#import "CCPlaysCollect.h"
#import "CCPlayScrollView.h"



@interface CCPlayingController ()

/** 信息展示, 滑动消失 */
@property (nullable, nonatomic, weak) UIScrollView *showView;
/** 退出按钮 */
@property (nullable, nonatomic, weak) UIButton *exitButton;

/** IJKFFMoviePlayerController */
@property (nullable, nonatomic, strong) IJKFFMoviePlayerController *ffmoviePlayer;

@end

@implementation CCPlayingController

#pragma mark - Reload
SingleImplementation(PlayController);

- (void)loadView {
    [self _loadView];
}

- (void)controllerSpecialInit {
    
}

- (void)controllerLayoutSubviews {
    // 加播放内容
    self.ffmoviePlayer.view.frame = self.view.bounds;
    
    // 加showView
    
    // 加 exitButton
    CGFloat btnWH = 40.0;
    CGFloat btnX = CCScreenWidth - btnWH - kMFifteen;
    CGFloat btnY = CCScreenHeight - btnWH - kMFifteen;
    self.exitButton.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /// 设置不自动调整ScrollView的内边距
    /// 在父类中执行了一遍, 但是因为此控制器保持单例一直存储, 在pop出去后, 此值会莫名的改变为YES, 所以重复设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 设置导航栏隐藏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self installMovieNotificationObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /// 设置导航栏展示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self removeMovieNotificationObservers];
}


#pragma mark - Common
#pragma mark - Special
- (void)_loadView {
//    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CCScreenBounds];
//    backView.showsVerticalScrollIndicator = NO;
//    backView.showsHorizontalScrollIndicator = NO;
//    backView.alwaysBounceHorizontal = NO;
//    backView.alwaysBounceVertical = YES;
//    backView.contentSize = backView.bounds.size;
////    weakSelf(self);
//    backView.mj_header = [CCGifHeader headerWithRefreshingBlock:^{
//        // 切换到上一个主播
//        [backView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
//    }];
//    backView.mj_footer = [CCGitFooter footerWithRefreshingBlock:^{
//        // 切换到下一个主播
//        [backView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
//    }];
    CCPlayScrollView *backView = [[CCPlayScrollView alloc] initWithFrame:CCScreenBounds];
    backView.contentSize = CCScreenBounds.size;
    self.view = backView;
}

- (void)closePlayer {
    [self.ffmoviePlayer shutdown];
}

- (void)installMovieNotificationObservers {
    [self.ffmoviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_ffmoviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_ffmoviePlayer];
}

- (void)removeMovieNotificationObservers {
    [self.ffmoviePlayer shutdown];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_ffmoviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_ffmoviePlayer];
}


#pragma mark - Event
- (void)handleDidExitEvent {
    [self.navigationController popViewControllerAnimated:YES];
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
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_ffmoviePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
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
    [self.ffmoviePlayer setValue:playsCollect.currentItem.flv forKeyPath:@"_urlString"];
    [self.ffmoviePlayer prepareToPlay];
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton setImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(handleDidExitEvent) forControlEvents:UIControlEventTouchUpInside];
        [[(CCPlayScrollView *)self.view contentView] addSubview:exitButton];
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
        [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
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
        [[(CCPlayScrollView *)self.view contentView] addSubview:_ffmoviePlayer.view];
    }
    return _ffmoviePlayer;
}


@end
