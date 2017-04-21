//
//  CCRecordViewController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCRecordViewController.h"

#import "LFLivePreview.h"

#import "CCViewDefines.h"

@interface CCRecordViewController ()

/** LFLivePreview */
@property (nullable, nonatomic, weak) LFLivePreview *liveView;

@end

@implementation CCRecordViewController

#pragma mark -- Reload
- (void)controllerSpecialInit {
    
}

- (void)controllerLayoutSubviews {
    self.liveView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - Common



#pragma mark - Lazy
- (LFLivePreview *)liveView {
    if (!_liveView) {
        LFLivePreview *liveView = [[LFLivePreview alloc] initWithFrame:CCScreenBounds];
        [liveView setCloseHandle:^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.view addSubview:liveView];
        _liveView = liveView;
    }
    return _liveView;
}


@end
