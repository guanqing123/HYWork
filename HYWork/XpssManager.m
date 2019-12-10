//
//  XpssManager.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "XpssManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "XpssModel.h"

@implementation XpssManager

+ (NSArray *)xpssWithDict:(NSDictionary *)dict {
    NSArray *listArray = [dict objectForKey:@"list"];
    
    NSMutableArray *array = [NSMutableArray array];
    if (![listArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dict in listArray) {
            XpssModel *model = [[XpssModel alloc] init];
            [model pickUp:dict];
            [array addObject:model];
        }
    }
    return array;
}

+ (void)postJSONWithUrl:(NSString *)url loginName:(NSString *)name typeStr:(NSString *)type need_paginate:(NSString *)paginate page_number:(NSString *)number page_size:(NSString *)size cpdmStr:(NSString *)cpdm success:(void (^)(id))success fail:(void (^)())fail {
    
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00027"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"need_paginate"] = paginate;
    params[@"loginName"] = name;
    params[@"type"] = type;
    params[@"page_number"] = number;
    params[@"page_size"] = size;
    params[@"cydm"] = cpdm;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:url param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

@end
