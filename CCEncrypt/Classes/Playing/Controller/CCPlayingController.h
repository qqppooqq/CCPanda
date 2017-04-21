//
//  CCPlayingController.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/9.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 *  内部使用 UIScrollView 作为根视图, 将 ijkplayer 的视频控制器对应的view添加到 UIScrollView 上展示
 *  问题: 在上下拖动刷新时, 会出现超级超级超级明显的卡顿情况...
 *  疑惑点: 同样使用时 UIScrollView 作为根视图的 UICollectionView 在每个 Cell 中加载 ijkplayer 的视频控制器对应的view, 就不会出现卡顿
 *  猜测: 或许是因为直接添加到 UIScrollView 视图, 导致没有做一些事? 而 UICollectionView 确实管理 Cell, 并且 Cell 中也是添加到 ContentView 中, 中间结果多层 UIView 视图的包裹, 或许在视频控制器view 与 UIScrollView 中间包裹一层 UIView 就好?  
 *  测试结果:  因为最终需要在背后展示主播模糊图片, 所以直接将中间层使用 UIImageView, 减少层级, 但是 ---> 还是不行
 *  
 *  pass -------  我在这里有个遗憾
 */

#import "CCCommonController.h"

#import "CCSingleDefines.h"

@class CCPlaysCollect;

@interface CCPlayingController : CCCommonController

SingleInterFace(PlayController);

/** 管理直播列表对象 */
@property (nullable, nonatomic, strong) CCPlaysCollect *playsCollect;

@end
