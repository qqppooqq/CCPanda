//
//  CCNetHelper.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络请求类型

 - CCNetTypeGet: GET
 - CCNetTypePost: POST
 */
typedef NS_ENUM(NSInteger, CCNetType) {
    CCNetTypeGet,
    CCNetTypePost
};

typedef void (^CCNetResult)(NSURLSessionDataTask *task, id response, NSError *error);

@interface CCNetHelper : NSObject

/**
 发送GET请求

 @param urlString 请求路径
 @param parameters 请求参数
 @param netResult 网络结果回调
 */
+ (void)netHelp_GET:(NSString *)urlString parameters:(id)parameters result:(CCNetResult)netResult;

/**
 发送POST请求
 
 @param urlString 请求路径
 @param parameters 请求参数
 @param netResult 网络结果回调
 */
+ (void)netHelp_POST:(NSString *)urlString parameters:(id)parameters result:(CCNetResult)netResult;

@end
