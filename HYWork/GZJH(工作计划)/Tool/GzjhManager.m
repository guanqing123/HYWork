//
//  GzjhManager.m
//  HYWork
//
//  Created by information on 16/5/25.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "GzjhManager.h"
#import "RequestHeader.h"
#import "AFNetworking.h"
#import "WeekPlan.h"
#import "MonthPlan.h"
#import "SJLD.h"
#import "ZJXS.h"
#import "MJExtension.h"
#import "WKHttpTool.h"

@implementation GzjhManager

/** 获取周计划列表 */
+ (void)getWeekPlansWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:WEEKPLANS];
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

/** 周计划数组转模型 */
+ (NSArray *)weekPlansArrayToModelArray:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        WeekPlan *weekPlan = [WeekPlan mj_objectWithKeyValues:dict];
        [array addObject:weekPlan];
    }
    return array;
}

/** 月计划数组转模型 */
+ (NSArray *)monthPlansArrayToModelArray:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        MonthPlan *monthPlan = [MonthPlan mj_objectWithKeyValues:dict];
        [array addObject:monthPlan];
    }
    return array;
}

/** 数组转模型 */
+ (NSArray *)sjldListToModel:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        SJLD *sjld = [SJLD mj_objectWithKeyValues:dict];
        [array addObject:sjld];
    }
    return array;
}

/** 数组转模型 */
+ (NSArray *)zjxsListToModel:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        ZJXS *zjxs = [ZJXS mj_objectWithKeyValues:dict];
        [array addObject:zjxs];
    }
    return array;
}

/** 周计划来源列表转模型 */
+ (NSArray *)weekListToModel:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        WeekPlan *plan = [WeekPlan mj_objectWithKeyValues:dict];
        [array addObject:plan];
    }
    return array;
}

/** 工作计划删除、修改状态 */
+ (void)updateOrDeletePlanWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:PLANSTATE];
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

/** 工作计划保存+提交 */
+ (void)saveAndCommitPlanWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:SAVEORCOMMIT];
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

/** 获取周计划来源列表 */
+ (void)getWeekPlanListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail {
    RequestHeader *header = [[RequestHeader alloc] initWithTrcode:WEEKLIST];
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

+ (void)getNewZjgxWithParams:(NSDictionary *)params success:(void (^)(WKRankRelationshipResult *))success failure:(FailBlock)fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/rankRelationship";
    
    [WKHttpTool getWithURL:urlStr params:params success:^(id responseObject) {
        WKRankRelationshipResult *result = [WKRankRelationshipResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)getNewMonthPlanList:(NSDictionary *)params success:(void (^)(WKMonthPlanResult *))success failure:(FailBlock)fail {
    
//    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/monthPlanList";
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/monthPlanList2";
    
    [WKHttpTool getWithURL:urlStr params:params success:^(id responseObject) {
        WKMonthPlanResult *result = [WKMonthPlanResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)fromMonthPlanList:(NSDictionary *)params success:(void (^)(WKMonthPlanResult *))success failure:(FailBlock)fail {
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/fromMonthPlanList";
    
    [WKHttpTool getWithURL:urlStr params:params success:^(id responseObject) {
        WKMonthPlanResult *result = [WKMonthPlanResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)commitNewMonthPlan:(NSDictionary *)params success:(void (^)(WKBaseAppResult *))success failure:(FailBlock)fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/commitNewMonthPlan";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        WKBaseAppResult *result = [WKBaseAppResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)cancleCommitNewMonthPlan:(NSDictionary *)params success:(void (^)(WKBaseAppResult *))success failure:(FailBlock)fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/cancleCommitNewMonthPlan";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        WKBaseAppResult *result = [WKBaseAppResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)approveNewMonthPlan:(NSDictionary *)params success:(void (^)(WKBaseAppResult *))success failure:(FailBlock)fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/approveNewMonthPlan";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        WKBaseAppResult *result = [WKBaseAppResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

+ (void)cancleApproveNewMonthPlan:(NSDictionary *)params success:(void (^)(WKBaseAppResult *))success failure:(FailBlock)fail {
    
    NSString *urlStr = @"http://dev.sge.cn/hyapp/gzrzfb/cancleApproveNewMonthPlan";
    
    [WKHttpTool postWithUrl:urlStr param:params success:^(id responseObject) {
        WKBaseAppResult *result = [WKBaseAppResult mj_objectWithKeyValues:responseObject];
        success(result);
    } failure:^(NSError *error) {
        fail(error);
    }];
}

@end
