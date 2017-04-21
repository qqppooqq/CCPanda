//
//  CCRequestHelper.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 对所有请求的分离, 请求定义的位置
 */

#import <Foundation/Foundation.h>

typedef void (^CCRequestResult)(id response, NSError *error);

@interface CCRequestHelper : NSObject

+ (void)requestPlayingList:(NSInteger)page requestResult:(CCRequestResult)result;

@end
