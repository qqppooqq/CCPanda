//
//  CCMineViewController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCMineViewController.h"
#import "CCHomeViewController.h"

#import <YYKit/YYKit.h>
//#import <React/RCTRootView.h>

#import "CCDefines.h"


@interface CCMineViewController ()

/**  */
@property (nullable, nonatomic, weak) YYLabel *yyLabel;

@end

@implementation CCMineViewController

#pragma mark - Reload
- (void)loadView {
    [self _loadView];
}

- (void)controllerSpecialInit {
    
}

- (void)controllerLayoutSubviews {
    self.yyLabel.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Special
- (void)_loadView {
    [super loadView];
    return;
//    NSURL *jsCodeLocation = nil;
//#if DEBUG
//#if TARGET_OS_SIMULATOR
//#warning "DEBUG SIMULATOR"
//    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
//#else
//#warning "DEBUG DEVICE"
//    NSString *serverIP = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SERVER_IP"];
//    NSString *jsCodeUrlString = [NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios&dev=true", serverIP];
//    NSString *jsBundleUrlString = [jsCodeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    jsCodeLocation = [NSURL URLWithString:jsBundleUrlString];
//#endif
//#else
//#warning "PRODUCTION DEVICE"
//    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
//#endif
//    
//    RCTRootView *rootView =
//    [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
//                         moduleName        : @"RNHighScores"
//                         initialProperties :
//     @{
//       @"scores" : @[
//               @{
//                   @"name" : @"Alex",
//                   @"value": @"42"
//                   },
//               @{
//                   @"name" : @"Joel",
//                   @"value": @"10"
//                   }
//               ]
//       }
//                          launchOptions    : nil];
//    self.view = rootView;
}


#pragma mark - Lazy
- (YYLabel *)yyLabel {
    if (!_yyLabel) {
        YYLabel *yyLabel = [YYLabel new];
        yyLabel.text = @"直播推流地址:\nrtmp://live.hkstv.hk.lxdns.com:1935/live/stream153";
        yyLabel.numberOfLines = 0;
        yyLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:yyLabel];
        _yyLabel = yyLabel;
    }
    return _yyLabel;
}


@end
