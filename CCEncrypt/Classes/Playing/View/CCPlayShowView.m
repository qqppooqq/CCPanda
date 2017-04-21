//
//  CCPlayShowView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayShowView.h"

#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIImage+YYAdd.h>

#import "CCDefines.h"

#import "CCPlayInfoItem.h"

@interface CCPlayShowView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** CAGradientLayer - 渲染渐变效果 */
@property (nullable, nonatomic, weak) CAGradientLayer *gradienLayer;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *lookerLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *topListCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *careMeButton;

@end

@implementation CCPlayShowView

+ (instancetype)playShowView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

#pragma mark -- Reload
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commontInit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _layoutSubviews];
}


#pragma mark -- Common
- (void)commontInit {
    
}

- (void)_layoutSubviews {
    self.gradienLayer.frame = self.bounds;
}


#pragma mark - Special
/**
 展示被点击的对应用户信息视图

 @param item 所点击的用户数据模型
 */
- (void)showUserInfoWithItem:(id)item {
    
}


#pragma mark -- Event
/**
 点击用户信息视图的响应

 @param sender 手势
 */
- (IBAction)handleShowPlayerInfo:(UITapGestureRecognizer *)sender {
    /// 展示当前用户的信息
    [self showUserInfoWithItem:_item];
}

/**
 关注 / 取消关注 响应
 */
- (IBAction)handleAboutCareEvent:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

/**
 对话响应
 */
- (IBAction)handleTalkingEvent {
    
}

/**
 分享响应
 */
- (IBAction)handleShareEvent {
    
}

/**
 赠送礼物响应
 */
- (IBAction)handleSendGiftEvent {
    
}



#pragma mark -- Protocol
/// UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/// UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 取出数据
    
    // 调用点击, 传入对应的信息
    [self showUserInfoWithItem:nil];
}



#pragma mark -- Lazy
- (CAGradientLayer *)gradienLayer {
    if (!_gradienLayer) {
        CAGradientLayer *gradienLayer = [CAGradientLayer layer];
        [self.layer addSublayer:gradienLayer];
        _gradienLayer = gradienLayer;
        
        /// 渲染的渐变效果颜色集
        gradienLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor]];
        /// 渲染的渐变颜色发布集
        gradienLayer.locations = @[@(0.0), @(0.2), @(0.7), @(1)];
        
        // 渲染方向, 左上角(0, 0), 右下角(1, 1)
        gradienLayer.startPoint = CGPointMake(0, 0);
        gradienLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradienLayer;
}

- (void)setItem:(CCPlayInfoItem *)item {
    _item = item;
    
    [_iconImageView setImageWithURL:[NSURL URLWithString:item.smallpic] placeholder:[UIImage imageNamed:kIconPlaceHold] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        _iconImageView.image = [image imageByRoundCornerRadius:image.size.width * 0.5];
    }];
    _lookerLabel.text = item.allnum;
    
    // 对 CollectionView 的数据赋值 并 reloadData
    // 或者这个是自己通过房间id请求到的数据而不是在控制器传递而来, 那么就自己请求加载数据
}


@end
