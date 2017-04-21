//
//  CCLoadingView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCLoadingView.h"

#import <YYKit/UIView+YYAdd.h>

@implementation CCLoadingView

#pragma mark - Reload
SingleImplementation(LoadingView);

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *_images = @[[UIImage imageNamed:@"WifiMan_Sign_1"],
                             [UIImage imageNamed:@"WifiMan_Sign_2"],
                             [UIImage imageNamed:@"WifiMan_Sign_3"],
                             [UIImage imageNamed:@"WifiMan_Sign_4"]];
        [self setAnimationImages:_images];
        [self setAnimationDuration:0.4];
        [self setAnimationRepeatCount:0];
        CGFloat loadingWH = 120.0;
        [self setSize:CGSizeMake(loadingWH, loadingWH)];
    }
    return self;
}


#pragma mark - Special
+ (void)showLoadingView {
    CCLoadingView *loadingView = [self sharedLoadingView];
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
    loadingView.center = [UIApplication sharedApplication].keyWindow.center;
    [loadingView startAnimating];
}

+ (void)hideLoadingView {
    [[self sharedLoadingView] stopAnimating];
    [[self sharedLoadingView] removeFromSuperview];
}

@end
