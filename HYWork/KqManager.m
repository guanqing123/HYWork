//
//  KqManager.m
//  HYWork
//
//  Created by information on 16/4/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqManager.h"
#import "RequestHeader.h"
#import "KqReqData.h"
#import "KqRqData.h"
#import "AFNetworking.h"

@implementation KqManager

+ (void)postJsonWithCityCode:(NSString *)cityCode gh:(NSString *)gh success:(void (^)(id))success fail:(void (^)())fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:KQ1];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    KqReqData *data = [KqReqData kqReqDataWithCityCode:cityCode Gh:gh];
    NSDictionary *dataDict = [data dictionaryWithValuesForKeys:@[@"citycode",@"gh"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[dataDict,headerDict] forKeys:@[@"data",@"header"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content" : jsonString};

    [WKHttpTool postWithUrl:HYURL param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)postJsonWithDid:(NSString *)did gh:(NSString *)gh sign:(NSString *)sign success:(void (^)(id))success fail:(void (^)())fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:KQ2];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    KqRqData *data = [KqRqData kqRqDataWidthGh:gh did:did sign:sign];
    NSDictionary *dataDict = [data dictionaryWithValuesForKeys:@[@"gh",@"did",@"sign"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[dataDict,headerDict] forKeys:@[@"data",@"header"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

@end
