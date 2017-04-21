//
//  CCPlayingCollectionController.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 *  根视图为 UICollectionView 在每个 Cell 中加载 ijkplayer 的视频控制器对应的view
 */

#import "CCCommonController.h"

@class CCPlaysCollect;

@interface CCPlayingCollectionController : CCCommonController

/** 管理直播列表对象 */
@property (nullable, nonatomic, strong) CCPlaysCollect *playsCollect;

@end
