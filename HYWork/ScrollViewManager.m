//
//  ScrollViewManager.m
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ScrollViewManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "ScrollViewModel.h"


@implementation ScrollViewManager

+ (void)postJSONWithUrl:(NSString *)url Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:SCROLL];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"trdate",@"trcode",@"appseq"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict] forKeys:@[@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:url param:parameters success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failBlock();
    }];
}

@end

@implementation ScrollViewModelList

+ (NSMutableArray *)getModelList:(NSDictionary *)dict {
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSArray *dictArray = [dict objectForKey:@"list"];
    for (NSDictionary *dict in dictArray) {
        ScrollViewModel *model = [ScrollViewModel scrollModelWithDict:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
