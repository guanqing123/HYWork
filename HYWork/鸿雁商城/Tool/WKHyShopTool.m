//
//  WKHyShopTool.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKHyShopTool.h"
#import "WKHttpTool.h"

@implementation WKHyShopTool

+ (void)getHyShopAddress:(NSDictionary *)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *urlStr = @"https://wx.hongyancloud.com/wxDev/sso/hyshop";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
