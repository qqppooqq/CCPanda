//
//  CCPlayScrollView.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPlayScrollView : UIScrollView

/**
 *  contentView : 内容控件 / 并且可以加载背景图
 *
 */
@property (nullable, nonatomic, weak) UIImageView *contentView;

@end
