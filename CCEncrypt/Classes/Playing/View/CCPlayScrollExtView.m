//
//  CCPlayScrollExtView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayScrollExtView.h"

#import "CCDefines.h"

#import "CCPlayShowView.h"


@interface CCPlayScrollExtView ()

/** CAGradientLayer - 渲染渐变效果 */
@property (nullable, nonatomic, weak) CAGradientLayer *gradienLayer;

/** 主要信息页 */
@property (nullable, nonatomic, weak) CCPlayShowView *showView;

@end

@implementation CCPlayScrollExtView

#pragma mark - Reload
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commontInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _layoutSubviews];
}

- (void)setFrame:(CGRect)frame {
    self.contentSize = CGSizeMake(CGRectGetWidth(frame) * 2, 0);
    [super setFrame:frame];
}



#pragma mark - Common
- (void)commontInit {
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.bounces = NO;
    self.pagingEnabled = YES;
}

- (void)_layoutSubviews {
    CGRect bounds = self.bounds;
    
    // 添加渐变Layer到滑动视图的右侧
    self.gradienLayer.frame = CGRectOffset(bounds, bounds.size.width, kMZero);
    
    self.showView.frame = _gradienLayer.frame;
    
    // 直接滑动到右侧
//    [self scrollRectToVisible:_gradienLayer.frame animated:NO];
    self.contentOffset = CGPointMake(bounds.size.width, 0);
}


#pragma mark - Special
#pragma mark - Event
#pragma mark - Protocol
#pragma mark - Lazy
#pragma mark - Lazy
- (CAGradientLayer *)gradienLayer {
    if (!_gradienLayer) {
        CAGradientLayer *gradienLayer = [CAGradientLayer layer];
        [self.layer addSublayer:gradienLayer];
        _gradienLayer = gradienLayer;
        
        gradienLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor]];
        
        gradienLayer.locations = @[@(0.0), @(0.2), @(0.7), @(1)];
        
        gradienLayer.startPoint = CGPointMake(0, 0);
        gradienLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradienLayer;
}

- (CCPlayShowView *)showView {
    if (!_showView) {
        CCPlayShowView *showView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCPlayShowView class]) owner:nil options:nil] firstObject];
        [self addSubview:showView];
        _showView = showView;
    }
    return _showView;
}


@end
