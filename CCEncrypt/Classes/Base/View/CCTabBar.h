//
//  CCTabBar.h
//  CCEncrypt
//
//  Created by 陈超 on 17/3/14.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCTabBarDelegate <UITabBarDelegate>

- (void)tabBarDidRecordingEvent:( UITabBar * _Nullable )tabBar;

@end

@interface CCTabBar : UITabBar

/** 自定义代理 */
@property (nullable, nonatomic, weak) id<CCTabBarDelegate> delegate;

@end
