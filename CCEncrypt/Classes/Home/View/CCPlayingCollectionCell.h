//
//  CCPlayingCollectionCell.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPlayInfoItem;

@interface CCPlayingCollectionCell : UICollectionViewCell

/** 模型item */
@property (nullable, nonatomic, weak) CCPlayInfoItem *item;

@end
