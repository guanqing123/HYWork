//
//  WKJCFXTool.m
//  HYWork
//
//  Created by information on 2019/11/1.
//  Copyright © 2019 hongyan. All rights reserved.
//

#import "WKJCFXTool.h"
#import "WKHttpTool.h"

@implementation WKJCFXTool

+ (void)jcfxsso:(NSDictionary *)param success:(void (^)(id _Nonnull))success fail:(void (^)())fail {
    
    NSString *urlStr = @"http://218.75.78.166:9081/webroot/decision/login/cross/domain?fine_username=%@&fine_password=%@&validity=-1&callback=";
    
    NSString *destUrl = [NSString stringWithFormat:urlStr, param[@"fine_username"], param[@"fine_password"]];
    
    [WKHttpTool getWithURLAndResponseText:destUrl params:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
    
}

@end
