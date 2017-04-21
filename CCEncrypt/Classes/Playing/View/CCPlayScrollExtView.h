//
//  CCPlayScrollExtView.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 *  与预期不同
 *  并不能做到流畅的滑动, UIScrollView 与 ijkplayer 在一起就特么搞事情...醉了
 *  先使用UIView解决
 */

#import <UIKit/UIKit.h>

@class CCPlayInfoItem;

@interface CCPlayScrollExtView : UIScrollView

/** item */
@property (nullable, nonatomic, weak) CCPlayInfoItem *item;

@end
