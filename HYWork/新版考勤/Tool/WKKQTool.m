//
//  WKKQTool.m
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKKQTool.h"

@implementation WKKQTool

+ (void)postVirtualLocation:(NSDictionary *)vlDict success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *trdate = [formatter stringFromDate:[NSDate date]];
    NSDictionary *headerDict = @{@"appseq":@"IOS", @"trdate":trdate, @"trcode":@"SGE00045"};
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[vlDict, headerDict] forKeys:@[@"data",@"header"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)remindKqtx:(NSDictionary *)kqtxDict success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *trdate = [formatter stringFromDate:[NSDate date]];
    NSDictionary *headerDict = @{@"appseq":@"IOS", @"trdate":trdate, @"trcode":@"SGE00046"};
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[kqtxDict, headerDict] forKeys:@[@"data",@"header"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
