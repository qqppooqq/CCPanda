//
//  CCNetHelper.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCNetHelper.h"

#import <AFNetworking/AFNetworking.h>

@implementation CCNetHelper

static AFHTTPSessionManager *_session;

#pragma mark - Reload
+ (void)initialize {
    [super initialize];
    
    [self _initialize];
}


#pragma mark - Common
#pragma mark - Special
+ (void)_initialize {
    _session = [AFHTTPSessionManager manager];
    _session.requestSerializer = [AFHTTPRequestSerializer serializer];
    _session.responseSerializer = [AFJSONResponseSerializer serializer];
    _session.responseSerializer.acceptableContentTypes = [_session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
}

+ (void)netHelp_GET:(NSString *)urlString parameters:(id)parameters result:(CCNetResult)netResult {
    [self netHelpWithType:CCNetTypeGet url:urlString parameters:parameters result:netResult];
}

+ (void)netHelp_POST:(NSString *)urlString parameters:(id)parameters result:(CCNetResult)netResult {
    [self netHelpWithType:CCNetTypePost url:urlString parameters:parameters result:netResult];
}

+ (void)netHelpWithType:(CCNetType)type url:(NSString *)url parameters:(id)parameters result:(CCNetResult)netResult {
    
    if (!netResult) return;
    
    switch (type) {
        case CCNetTypeGet: {
            [_session GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                netResult(task, responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                netResult(task, nil, error);
            }];
            break;
        }
        case CCNetTypePost: {
            [_session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                netResult(task, responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                netResult(task, nil, error);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Event
#pragma mark - Protocol
#pragma mark - Lazy


@end
