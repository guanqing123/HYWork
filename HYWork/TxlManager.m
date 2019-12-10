//
//  TxlManager.m
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "TxlManager.h"
#import "AFNetworking.h"
#import "RequestHeader.h"

@implementation TxlManager

+ (void)getEmpsInfoWithGh:(NSString *)gh Type:(NSString *)type Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:TXL];
    NSDictionary  *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSArray *reqDataKey = [NSArray arrayWithObjects:@"gh",@"type",@"need_paginate", nil];
    
    NSArray *reqDataVal = [NSArray arrayWithObjects:gh,type ,@"false", nil];
    
    NSDictionary *reqDataDict = [[NSDictionary alloc] initWithObjects:reqDataVal forKeys:reqDataKey];
  
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[headerDict,reqDataDict] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameters success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failBlock();
    }];
}

+ (void)getEmpDetailWithGh:(NSString *)gh Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:EmpInfo];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *reqDataDict = [[NSDictionary alloc] initWithObjects:@[gh] forKeys:@[@"gh"]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[headerDict,reqDataDict] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameters success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failBlock();
    }];
}

@end
