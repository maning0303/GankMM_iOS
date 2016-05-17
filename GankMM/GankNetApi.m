//
//  GankNetApi.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "GankNetApi.h"
#import <AFNetworking.h>

@implementation GankNetApi

+(void)getGankDataWithType:(NSString *)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    //获取网络数据
    NSString *url = [NSString stringWithFormat:@"http://gank.io/api/data/%@/%zd/%zd",type,pageSize,pageIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MNLog(@"----url----%@",url);
    
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MNLog(@"---success---%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"失败");
    }];
    
    
}

@end
