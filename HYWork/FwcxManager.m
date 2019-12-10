//
//  FwcxManager.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "FwcxManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"

@implementation FwcxManager

+ (void)getFwcxWithUrl:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success fail:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:@"HYXK00029"];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
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
