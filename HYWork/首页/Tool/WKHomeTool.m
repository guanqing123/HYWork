//
//  WKHomeTool.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKHomeTool.h"
#import "WKHttpTool.h"

@implementation WKHomeTool

+ (void)getHomeSliders:(WKHomeSliderParam *)sliderParam success:(void (^)(WKHomeSliderResult * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *urlStr = @"http://dev.sge.cn/rest/hywork/home/news/list";
    
    NSDictionary *parameter = [sliderParam mj_keyValues];
    
    [WKHttpTool postWithUrl:urlStr param:parameter success:^(id responseObject) {
        WKHomeSliderResult *result = [WKHomeSliderResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
