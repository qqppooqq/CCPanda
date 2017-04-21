//
//  CCLoadingView.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCSingleDefines.h"

@interface CCLoadingView : UIImageView

SingleInterFace(LoadingView);

+ (void)showLoadingView;

+ (void)hideLoadingView;

@end
