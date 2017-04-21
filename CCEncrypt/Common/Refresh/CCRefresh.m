//
//  CCRefresh.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/9.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCRefresh.h"

static NSArray *_images;

@implementation CCGifHeader

+ (void)initialize {
    [super initialize];
    
    _images = @[[UIImage imageNamed:@"WifiMan_Sign_1"],
                [UIImage imageNamed:@"WifiMan_Sign_2"],
                [UIImage imageNamed:@"WifiMan_Sign_3"],
                [UIImage imageNamed:@"WifiMan_Sign_4"]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        [self setImages:_images forState:MJRefreshStatePulling];
        [self setImages:_images forState:MJRefreshStateRefreshing];
        [self setImages:_images forState:MJRefreshStateWillRefresh];
    }
    return self;
}

@end


@implementation CCGitFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.stateLabel.hidden = YES;
        [self setImages:_images forState:MJRefreshStatePulling];
        [self setImages:_images forState:MJRefreshStateRefreshing];
        [self setImages:_images forState:MJRefreshStateWillRefresh];
    }
    return self;
}

@end
