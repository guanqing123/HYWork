//
//  KhkfManager.m
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "KhkfManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@implementation KhkfManager

/** 根据查询条件获取潜在客户列表 */
+ (void)getQzKhListByCondition:(NSDictionary *)params success:(successBlock)success fail:(failBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:getQzBpc];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[params,headerDict] forKeys:@[@"data",@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameter success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

/** 根据序号删除潜在客户 */
+ (void)deleteQzkhByXh:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)())fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:deleteBpc];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[params,headerDict] forKeys:@[@"data",@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameter success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)getTjz5ByKhdm:(WKTJZ5Param *)params success:(void (^)(NSArray *))success fail:(void (^)())fail {
    
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[params.appseq,params.trcode,params.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : params.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            NSArray *result = [WKTjz5 mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]];
            success(result);
        }else{
            success([NSArray array]);
        }
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)savePhoto:(NSDictionary *)params imageArray:(NSArray *)imageArray success:(void(^)(WKPhotoResult *))success failure:(void (^)())fail {
    
    NSString *urlStr = @"http://218.75.78.166:9106/ftp/upload?";
    
    [WKHttpTool postWithURL:urlStr params:params formDataArray:imageArray success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            WKPhotoResult *result = [WKPhotoResult mj_objectWithKeyValues:[[json objectForKey:@"data"] objectAtIndex:0]];
            success(result);
        }else{
            success(nil);
        }
    } failure:^(NSError *error) {
        fail();
    }];
    
}

+ (void)saveQdkf:(WKQdkfParam *)params success:(void (^)(BOOL))success fail:(void (^)())fail {
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[params.appseq,params.trcode,params.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : params.qdkh.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            success(YES);
        }else{
            success(NO);
        }
    } failure:^(NSError *error) {
        fail();
    }];
}


+ (void)getQdkhBean:(WKQdkhParam *)params success:(void (^)(WKQdkh *))success fail:(void (^)())fail {
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[params.appseq,params.trcode,params.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : params.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            WKQdkh *qdkh = [WKQdkh mj_objectWithKeyValues:[[json objectForKey:@"data"] objectForKey:@"khxx"]];
            success(qdkh);
        }else{
            success(nil);
        }
    } failure:^(NSError *error) {
        fail();
    }];
    
}

@end
