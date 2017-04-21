//
//  CCPlayScrollView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayScrollView.h"

#import "CCRefresh.h"


@implementation CCPlayScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commontInit];
    }
    return self;
}
// delaysContentTouches

#pragma mark - Reload
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _layoutSubviews];
}


#pragma mark - Common
- (void)commontInit {
    self.delaysContentTouches = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = YES;
    //    weakSelf(self);
    self.mj_header = [CCGifHeader headerWithRefreshingBlock:^{
        // 切换到上一个主播
        [self.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
    }];
    self.mj_footer = [CCGitFooter footerWithRefreshingBlock:^{
        // 切换到下一个主播
        [self.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
    }];
}

- (void)_layoutSubviews {
    self.contentView.frame = self.bounds;
}


#pragma mark - Lazy
- (UIImageView *)contentView {
    if (!_contentView) {
        UIImageView *contentView = [UIImageView new];
        contentView.contentMode = UIViewContentModeScaleAspectFit;
        contentView.userInteractionEnabled = YES;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}


@end
