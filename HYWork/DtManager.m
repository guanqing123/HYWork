//
//  DtManager.m
//  HYWork
//
//  Created by information on 16/3/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtManager.h"
#import "RequestHeader.h"
#import "RequestData.h"
#import "DtCellModel.h"
#import "AFNetworking.h"

@implementation DtManager

+ (void)postJSONWithUrl:(NSString *)url RequestData:(RequestData *)requestData success:(void (^)(id))success fail:(void (^)())fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:DT];
    NSDictionary  *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    NSDictionary  *dataDict = [requestData dictionaryWithValuesForKeys:@[@"need_paginate",@"page_number",@"page_size"]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[dataDict,headerDict] forKeys:@[@"data",@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:url param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}


@end

@implementation ModelList

+ (instancetype)getModelList:(NSDictionary *)dict{
    ModelList *modelList = [[ModelList alloc] init];
    modelList.dataArray = [[NSMutableArray alloc] init];
    NSArray *list = [dict objectForKey:@"list"];
    if (![list isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dict in list) {
            DtCellModel *model = [DtCellModel dtCellWithDict:dict];
            [modelList.dataArray addObject:model];
        }
    }
    return modelList;
}


@end
