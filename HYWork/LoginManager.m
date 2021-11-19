//
//  LoginManager.m
//  HYWork
//
//  Created by information on 16/4/11.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "LoginManager.h"
#import "WKHttpTool.h"

@implementation LoginManager

+ (void)checkVersionWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"SGE00010"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"trdate",@"trcode",@"appseq"]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:url param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)postJSONWithUrl:(NSString *)url gh:(NSString *)gh mm:(NSString *)mm success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:LOGIN];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"trdate",@"trcode",@"appseq"]];
    
    NSArray *reqDataKey = [NSArray arrayWithObjects:@"gh",@"mm",nil];
    NSArray *reqDataVal = [NSArray arrayWithObjects:gh, mm, nil];
    NSDictionary *reqDataDict = [[NSDictionary alloc] initWithObjects:reqDataVal forKeys:reqDataKey];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[headerDict,reqDataDict] forKeys:@[@"header",@"data"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:url param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)remaindMe:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/yszk/isShow";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
    
}

+ (void)crashLog:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/crash/save/log";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

@end
