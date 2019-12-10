//
//  GyhyManager.m
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "GyhyManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "QyryModel.h"

@implementation GyhyManager

+ (void)getQyzzWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00026"];
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

+ (NSArray *)dictToQyryModelArray:(NSDictionary *)dict {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *list = [dict objectForKey:@"list"];
    for (NSDictionary *dict in list) {
        QyryModel *model = [QyryModel modelWithDict:dict];
        [array addObject:model];
    }
    return array;
}

+ (void)getQyryListWithUrl:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success fail:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00004"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
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

+ (void)getQygkWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00002"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    NSDictionary *data = [NSDictionary dictionary];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,data] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:url param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

@end
