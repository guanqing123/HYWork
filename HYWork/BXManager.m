//
//  BXManager.m
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BXManager.h"
#import "AFNetworking.h"
#import "RequestHeader.h"
#import "BXGroup.h"

@implementation BXManager

+ (void)getBxListWithEcologyid:(NSString *)ecologyId Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:BXLIST];
    NSDictionary  *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSArray *reqDataKey = [NSArray arrayWithObjects:@"ecology_id",@"page_number",@"page_size",nil];
    NSArray *reqDataVal = [NSArray arrayWithObjects:ecologyId,@"1",@"1000", nil];
    
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

+ (NSArray *)getBxListWithArray:(NSArray *)array {
    NSMutableArray *groupArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        BXGroup *group = [BXGroup bxGroupWithDict:dict];
        [groupArray addObject:group];
    }
    return groupArray;
}

@end
