//
//  CCRequestHelper.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCRequestHelper.h"

#import <MJExtension/MJExtension.h>

#import "CCNetHelper.h"

/// 模型
#import "CCPlayInfoItem.h"

/// 直播列表借口, 需要在最后拼接要请求的页码
static NSString *const kRequestPlayingList = @"http://live.9158.com/Fans/GetHotLive?page=";

static NSInteger const requestCodeSuccess = 100;


@implementation CCRequestHelper

+ (void)requestPlayingList:(NSInteger)page requestResult:(CCRequestResult)result {
    
    NSString *url = [NSString stringWithFormat:@"%@%zd", kRequestPlayingList, page];
    
    [CCNetHelper netHelp_GET:url parameters:nil result:^(NSURLSessionDataTask *task, id response, NSError *error) {
        if (error) {    // 请求 / 解析错误
            result(nil, error);
            return;
        }
        
        // 请求成功
        id resultData = nil;
        if ([[response objectForKey:@"code"] integerValue] == requestCodeSuccess) {
            resultData = [[response objectForKey:@"data"] objectForKey:@"list"];
            result([CCPlayInfoItem mj_objectArrayWithKeyValuesArray:resultData], nil);
        } else {
            // 解决后端返回的错误, 提交信息
        }
    }];
}

@end
