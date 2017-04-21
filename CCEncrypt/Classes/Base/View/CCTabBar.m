//
//  CCTabBar.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/14.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCTabBar.h"

#import "CCConstDefines.h"
#import "CCViewDefines.h"

#import <YYKit/UIView+YYAdd.h>


@interface CCTabBar ()

/** 录制按钮 */
@property (nullable, nonatomic, weak) UIButton *recordingButton;

@end

@implementation CCTabBar

#pragma mark - Reload
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commontInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutSubviews_];
}

#pragma mark - Common
- (void)commontInit {
    self.backgroundImage = [UIImage imageNamed:@"tab_bg"];
    self.backgroundImage = [self.backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(kMZero, kMZero, kMZero, kMZero) resizingMode:UIImageResizingModeStretch];
    self.shadowImage = [UIImage new];
}

#pragma mark - Special
- (void)layoutSubviews_ {
    CGFloat selfH = self.height;
    CGFloat itemW = CCScreenWidth / 3.0;
    CGFloat itemX = 0.0, itemY = selfH - kMTabH;
    NSInteger index = 0;
    for (UIView *item in self.subviews) {
        if ([NSStringFromClass([item class]) isEqualToString:@"UITabBarButton"]) {
            itemX = (index == 0 ? 0 : 2) * itemW;
            item.frame = CGRectMake(itemX, itemY, itemW, kMTabH);
            index += 1;
        }
    }
    
    // 为了适配 Plus
    if ([UIScreen mainScreen].scale == 3.0) { itemY *= 0.5; }
    
    for (UITabBarItem *item in self.items) {
        item.imageInsets = UIEdgeInsetsMake(itemY, kMZero, -itemY, kMZero);
    }
    // 最后的按钮布局必须放在设置 UITabBarItem 内图片内边距的后面, 否则出现按钮只有一半可以点击的bug
    // 当然, 如果是彻底自定义 TabBar , 就没有这个顾虑了
    self.recordingButton.frame = CGRectMake(itemW, kMZero, itemW, selfH);
}

#pragma mark - Event
- (void)handleWithRecordingEvent {
    if ([self.delegate respondsToSelector:@selector(tabBarDidRecordingEvent:)]) {
        [self.delegate tabBarDidRecordingEvent:self];
    }
}

#pragma mark - Protocol
#pragma mark - Lazy
- (UIButton *)recordingButton {
    if (!_recordingButton) {
        UIButton *recordingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordingButton setImage:[UIImage imageNamed:@"tab_room"] forState:UIControlStateNormal];
        [recordingButton setImage:[UIImage imageNamed:@"tab_room_p"] forState:UIControlStateHighlighted];
        [recordingButton addTarget:self action:@selector(handleWithRecordingEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordingButton];
        _recordingButton = recordingButton;
    }
    return _recordingButton;
}


@end



#pragma mark - ------------------------

#pragma mark - .h文件
//#import <UIKit/UIKit.h>
//
//@interface CCTintTabBar : UITabBar
//
//@end

#pragma mark - .m文件
//#import "CCTintTabBar.h"
//
//#import "CCDefines.h"
//
//#import <YYKit/UIImage+YYAdd.h>
//
//@implementation CCTintTabBar
//
//#pragma mark - Overload
//+ (void)initialize {
//    [super initialize];
//    [self _initialize];
//}
//
///**
// * 自定义UITabBar特别注意
// * 所设置的 backgroundColor / backgroundImage 等属性会调用 - drawRect: 方法绘制
// * 所以如果重写的 - drawRect: 方法, 必须实现父类的 drawRect: 操作, 否则设置无效
// */
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    [super drawRect:rect];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self commontInit];
//    }
//    return self;
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self _layoutSubviews];
//}
//
//
//#pragma mark - Init
//+ (void)_initialize {
//    UITabBarItem *itemAppearance = [UITabBarItem appearance];
//    /**
//     * 这里的 attributes 字典通过实验其赋值是保存的地址
//     * 所以如果使用同一个 NSMutableDictionary *attribetes = @{}.mutableCopy; 变量设置了不同的状态
//     > [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//     > [itemAppearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
//     > [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//     > [itemAppearance setTitleTextAttributes:attributes forState:UIControlStateSelected];
//     * 错误实现
//     *
//     * 必须使用俩个不同的字典对象分别设置就OK了
//     */
//    NSMutableDictionary *attributes = @{NSForegroundColorAttributeName : CCColorRGB(99, 99, 99),
//                                        NSFontAttributeName : CCFont(12)}.mutableCopy;
//    [itemAppearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    attributes = attributes.mutableCopy;
//    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [itemAppearance setTitleTextAttributes:attributes forState:UIControlStateSelected];
//}
//
//- (void)commontInit {
//    /**
//     * 设置TabBar背景色最终总结
//     * 1. 纯色背景 推荐
//     > setBackgroundColor: 属性直接修改
//     > tabBar.barTintColor 主题颜色在 translucent 为NO时准确, translucent 为YES时不准确
//     * 2. 自定义背景
//     > setBackgroundImage: 方法修改
//     *
//     * 设置选中的tabBar颜色 -> tabBar.tintColor
//     *
//     */
//    self.barStyle = UIBarStyleDefault;
//    self.translucent = YES;
//    [self setBackgroundColor:CCColorRGBA(255, 255, 255, 0.25)];
//    //    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
//    //    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1000, 100)]];
//}
//
//
//#pragma mark - Special
//- (void)_layoutSubviews {
//    
//}
//
//
//@end
