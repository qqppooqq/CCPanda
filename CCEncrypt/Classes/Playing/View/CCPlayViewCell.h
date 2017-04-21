//
//  CCPlayViewCell.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPlaysCollect, CCPlayViewCell;

@protocol CCPlayViewCellDelegate <NSObject>

- (void)playViewCellDidExitPlay:(CCPlayViewCell *)cell;

@end

@interface CCPlayViewCell : UICollectionViewCell

/** 代理 */
@property (nullable, nonatomic, weak) id<CCPlayViewCellDelegate> delegate;
/** 管理直播列表对象 */
@property (nullable, nonatomic, strong) CCPlaysCollect *playsCollect;

@end
