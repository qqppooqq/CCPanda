//
//  CCPlaysCollect.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/9.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCPlayInfoItem.h"

@interface CCPlaysCollect : NSObject

/** 模型集合 */
@property (nullable, nonatomic, strong) NSMutableArray *items;

/** 选中模型 */
@property (nullable, nonatomic, weak) CCPlayInfoItem *currentItem;

@end
