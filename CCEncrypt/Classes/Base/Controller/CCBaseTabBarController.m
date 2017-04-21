//
//  CCBaseTabBarController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCBaseTabBarController.h"

#import <YYKit/UIImage+YYAdd.h>

#import "CCDefines.h"

#import "CCTabBar.h"

#import "CCTintNavigationController.h"
#import "CCHomeViewController.h"
#import "CCMineViewController.h"
#import "CCRecordViewController.h"


@interface CCBaseTabBarController ()<UITabBarControllerDelegate, CCTabBarDelegate>

/** tabbarItems */
@property (nullable, nonatomic, strong) NSArray *tabbarItems;

@end

@implementation CCBaseTabBarController


#pragma mark - Const
static NSString *const kItemTitle = @"item_title";
static NSString *const kItemNImage = @"item_n_image";
static NSString *const kItemHImage = @"item_h_image";
static NSString *const kItemController = @"item_controller";


#pragma mark -- Overload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultInit];
}

- (void)viewWillLayoutSubviews {
    [self viewWillLayoutSubviews_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init
- (void)defaultInit {
    self.delegate = self;
    
    [self setValue:[CCTabBar new] forKeyPath:@"tabBar"];
    
    UIViewController *childController = nil;
    for (NSDictionary *tabbarItem in self.tabbarItems) {
        childController = tabbarItem[kItemController];
        if ([childController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)childController topViewController].title = tabbarItem[kItemTitle];
        //        childController.navigationItem.title = tabbarItem[kItemTitle];
        childController.tabBarItem.title = tabbarItem[kItemTitle];
        childController.tabBarItem.image = [UIImage imageNamed:tabbarItem[kItemNImage]];
        childController.tabBarItem.selectedImage = [UIImage imageNamed:tabbarItem[kItemHImage]];
        [self addChildViewController:childController];
    }
    self.tabbarItems = nil;
}


#pragma mark - Special
- (void)viewWillLayoutSubviews_ {
    // 640 * 100 为背景图片比例
    CGFloat kScreenW = CCScreenWidth;
    CGFloat tabbarH = ceil(kScreenW / 640.0 * 100.0);
    self.tabBar.frame = CGRectMake(kMZero, CCScreenHeight - tabbarH, kScreenW, tabbarH);
}


#pragma mark - Protocol
/// UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    
    return YES;
}


/// CCTabBarDelegate
- (void)tabBarDidRecordingEvent:(UITabBar *)tabBar {
    [self presentViewController:[CCRecordViewController new] animated:YES completion:nil];
}


#pragma mark - Lazy
- (NSArray *)tabbarItems {
    if (!_tabbarItems) {
        _tabbarItems = @[@{kItemTitle : @"",
                           kItemNImage : @"tab_live",
                           kItemHImage : @"tab_live_p",
                           kItemController : [CCTintNavigationController navigationRootCtrl:[CCHomeViewController new]]},
                         @{kItemTitle : @"",
                           kItemNImage : @"tab_me",
                           kItemHImage : @"tab_me_p",
                           kItemController : [CCTintNavigationController navigationRootCtrl:[CCMineViewController new]]},];
    }
    return _tabbarItems;
}



@end

