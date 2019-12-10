//
//  JdzpManager.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "JdzpManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "JdzpModel.h"

@implementation JdzpManager

+ (NSArray *)jdzpWithDict:(NSDictionary *)dict {
    NSArray *listArray = [dict objectForKey:@"list"];
    
    NSMutableArray *array = [NSMutableArray array];
    if (![listArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dict in listArray) {
            JdzpModel *model = [[JdzpModel alloc] init];
            [model pickUp:dict];
            [array addObject:model];
        }
    }
    return array;
}

+ (void)postJSONWithUrl:(NSString *)aUrl need_paginate:(NSString *)paginate page_number:(NSString *)number page_size:(NSString *)size success:(void (^)(id))success fail:(void (^)())fail
{
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00020"];

    
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"need_paginate"] = paginate;
    params[@"page_number"] = number;
    params[@"page_size"] = size;

    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters =@{@"content":jsonString};
    
    
    [WKHttpTool postWithUrl:aUrl param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

@end
