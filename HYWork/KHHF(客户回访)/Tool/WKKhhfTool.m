//
//  WKKhhfTool.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKKhhfTool.h"
#import "MJExtension.h"
#import "WKHttpTool.h"

@implementation WKKhhfTool

+ (void)getKhhfList:(WKKhhfTableParam *)khhfParam success:(void (^)(WKKhhfTableResult *))success failure:(void (^)(NSError *))failure {
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[khhfParam.appseq,khhfParam.trcode,khhfParam.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : khhfParam.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            WKKhhfTableResult *result = [WKKhhfTableResult mj_objectWithKeyValues:[json objectForKey:@"data"]];
            success(result);
        }else{
            WKKhhfTableResult *result = [WKKhhfTableResult result];
            result.error = YES;
            result.errorMsg = [NSString stringWithFormat:@"%@",[[json objectForKey:@"header"] objectForKey:@"errorMsg"]];
            success(result);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
