//
//  CjwtManager.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CjwtManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "QuestionModel.h"

@implementation CjwtManager

+ (NSMutableArray *)jsonArrayToModelArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        QuestionModel *model = [QuestionModel questionWithDict:dict];
        [tempArray addObject:model];
    }
    return tempArray;
}

+ (void)getCjwtWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00006"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    NSDictionary *dataDict = [NSDictionary dictionary];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,dataDict] forKeys:@[@"header",@"data"]];
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
