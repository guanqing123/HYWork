//
//  GzjhManager.h
//  HYWork
//
//  Created by information on 16/5/25.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKRankRelationshipResult.h"
#import "WKMonthPlanResult.h"

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)();

@interface GzjhManager : NSObject

/** 获取周/月计划列表 */
+ (void)getWeekPlansWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 周计划数组转模型 */
+ (NSArray *)weekPlansArrayToModelArray:(NSArray *)jsonArray;

/** 月计划数组转模型 */
+ (NSArray *)monthPlansArrayToModelArray:(NSArray *)jsonArray;

/** 工作计划删除、修改状态 */
+ (void)updateOrDeletePlanWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 获取职级关系 */
+ (void)getZjgxWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 工作计划保存+提交 */
+ (void)saveAndCommitPlanWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 获取周计划来源列表 */
+ (void)getWeekPlanListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 上级领导数组转模型 */
+ (NSArray *)sjldListToModel:(NSArray *)jsonArray;

/** 直接下属数组转模型 */
+ (NSArray *)zjxsListToModel:(NSArray *)jsonArray;

/** 周计划来源列表转模型 */
+ (NSArray *)weekListToModel:(NSArray *)jsonArray;

/**
 获取新的职级关系

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)getNewZjgxWithParams:(NSDictionary *)params success:(void(^)(WKRankRelationshipResult *result))success failure:(FailBlock)fail;

/**
 获取新的月计划列表

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)getNewMonthPlanList:(NSDictionary *)params success:(void(^)(WKMonthPlanResult *result))success failure:(FailBlock)fail;


/**
来自月计划

@param params 请求参数
@param success 成功回调
@param fail 失败回调
*/
+ (void)fromMonthPlanList:(NSDictionary *)params success:(void(^)(WKMonthPlanResult *result))success failure:(FailBlock)fail;

/**
 新月计划提交

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)commitNewMonthPlan:(NSDictionary *)params success:(void(^)(WKBaseAppResult *result))success failure:(FailBlock)fail;


/**
 新月计划取消提交

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)cancleCommitNewMonthPlan:(NSDictionary *)params success:(void(^)(WKBaseAppResult *result))success failure:(FailBlock)fail;

/**
 新月计划审批

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)approveNewMonthPlan:(NSDictionary *)params success:(void(^)(WKBaseAppResult *result))success failure:(FailBlock)fail;

/**
 新月计划取消审批

 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)cancleApproveNewMonthPlan:(NSDictionary *)params success:(void(^)(WKBaseAppResult *result))success failure:(FailBlock)fail;

@end
