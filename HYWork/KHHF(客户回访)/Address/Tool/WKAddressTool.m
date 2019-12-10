//
//  WKAddressTool.m
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKAddressTool.h"
#import "WKHttpTool.h"
#import "WKProvince.h"
#import "MJExtension.h"

@implementation WKAddressTool

+ (void)getAddressList:(NSDictionary *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *urlStr = @"http://sge.cn:9106/app/web/getCitiesData";
    
    [WKHttpTool getWithURL:urlStr params:param success:^(id json) {
        NSArray *array = [WKProvince mj_objectArrayWithKeyValuesArray:json];
        success(array);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
