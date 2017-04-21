//
//  CCPlayShowView.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPlayInfoItem;

@interface CCPlayShowView : UIView

+ (instancetype)playShowView;

/** item */
@property (nullable, nonatomic, weak) CCPlayInfoItem *item;

@end
