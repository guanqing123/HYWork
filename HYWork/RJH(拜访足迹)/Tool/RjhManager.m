//
//  RjhManager.m
//  HYWork
//
//  Created by information on 2017/5/27.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "WKHttpTool.h"

@implementation RjhManager

/** 获取签到总次数 */
+ (void)postJosnWithUserId:(NSDictionary *)params success:(void (^)(id json))success fail:(void (^)(void))fail{
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:signCount];
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

/** 签到并上传图片 */
+ (void)postJsonWithParameters:(NSDictionary *)params signInImage:(UIImage *)image success:(void (^)(id))success fail:(void (^)(void))fail{
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:signSavePage];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[params,headerDict] forKeys:@[@"data",@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"fileType" : @"image",@"content" : jsonString};
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:HYURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        [formData appendPartWithFileData:data name:@"image" fileName:@"signIn.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail();
    }];
}

/** 图片上传 */
+ (void)postJsonWithParameters:(NSDictionary *)params imageArray:(NSArray *)imageArray success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:signSavePage];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[params,headerDict] forKeys:@[@"data",@"header"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameter = @{@"fileType" : @"image",@"content" : jsonString};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:HYURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for (UIImage *image in imageArray) {
            i++;
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            NSString *name = [NSString stringWithFormat:@"name_%d",i];
            NSString *fileName = [NSString stringWithFormat:@"fileName_%d.jpg",i];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail();
    }];
}

/** 获取日计划列表 */
+ (void)getRjhPlanListWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:rjhList];
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

/** 删除日志 */
+ (void)deleteRjhPlanWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:rjhDelete];
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

/** 客户检索 */
+ (void)getBpcListWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:bpcSearch];
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

/** 保存/编辑日志 */
+ (void)saveRjhPlanWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:signSavePage];
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

/** 获取职级关系 */
+ (void)getZjgxWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:ZJGX];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    
    [WKHttpTool postWithUrl:HYURL param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

/** 保存/编辑日志 */
+ (void)saveCommentWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:saveComment];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

/** 删除评论 */
+ (void)deleteCommentWithParameters:(NSDictionary *)params success:(void (^)(id))success fail:(void (^)(void))fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:deleteComment];
    NSDictionary *headerDict = [header dictionaryWithValuesForKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[headerDict,params] forKeys:@[@"header",@"data"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"content":jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)getWorkType:(WKWorkTypeParam *)workTypeParam success:(void (^)(NSArray *))success fail:(void (^)(void))fail{
 
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[workTypeParam.appseq,workTypeParam.trcode,workTypeParam.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : workTypeParam.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            NSArray *result = [WKWorkTypeResult mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]];
            success(result);
        }else{
            success([NSArray array]);
        }
    } failure:^(NSError *error) {
        fail();
    }];
}

+ (void)getProjectList:(WKProjectParam *)projectParam success:(void (^)(NSArray *))success fail:(void (^)(void))fail {
    
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjects:@[projectParam.appseq,projectParam.trcode,projectParam.trdate] forKeys:@[@"appseq",@"trcode",@"trdate"]];
    
    NSDictionary *dict = @{@"header" : headerDict, @"data" : projectParam.mj_keyValues};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramter = @{@"content" : jsonString};
    
    [WKHttpTool postWithUrl:HYURL param:paramter success:^(id json) {
        if ([[[json objectForKey:@"header"] objectForKey:@"succflag"] isEqualToString:@"1"]) {
            NSArray *result = [WKProjectResult mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]];
            success(result);
        }else{
            success([NSArray array]);
        }
    } failure:^(NSError *error) {
        fail();
    }];
    
}

@end
