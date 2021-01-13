//
//  WKFunsTool.m
//  HYWork
//
//  Created by information on 2021/1/13.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFunsTool.h"

@implementation WKFunsTool

+ (void)getHomeWork:(void (^)(WKHomeWorkResult * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *urlStr = @"http://dev.sge.cn/rest/hywork/home/funs";
    
    [WKHttpTool postWithUrl:urlStr param:nil success:^(id responseObject) {
        WKHomeWorkResult *result = [WKHomeWorkResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

@end
