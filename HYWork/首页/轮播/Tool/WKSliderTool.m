//
//  WKSliderTool.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKSliderTool.h"

@implementation WKSliderTool

+ (void)getSliderDetail:(NSDictionary *)dict success:(void (^)(WKSliderResult * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *urlStr = @"http://dev.sge.cn/rest/hywork/home/news/detail";
    
    [WKHttpTool postWithUrl:urlStr param:dict success:^(id responseObject) {
        WKSliderResult *result = [WKSliderResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getSliderList:(WKSliderListParam *)sliderListParam success:(void (^)(WKSliderListResult * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *urlStr = @"http://dev.sge.cn/rest/hywork/home/news/list";
    
    NSDictionary *param = [sliderListParam mj_keyValues];
    
    [WKHttpTool postWithUrl:urlStr param:param success:^(id responseObject) {
        WKSliderListResult *result = [WKSliderListResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
