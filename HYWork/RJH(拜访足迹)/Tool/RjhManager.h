//
//  RjhManager.h
//  HYWork
//
//  Created by information on 2017/5/27.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKWorkTypeParam.h"
#import "WKWorkTypeResult.h"

#import "WKProjectParam.h"
#import "WKProjectResult.h"

typedef void(^SuccessBlock)(id json);
typedef void(^FailBlock)(void);

@interface RjhManager : NSObject

/** 获取签到总次数 */
+ (void)postJosnWithUserId:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 签到并上传图片 */
+ (void)postJsonWithParameters:(NSDictionary *)params signInImage:(UIImage *)image success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 获取日计划列表 */
+ (void)getRjhPlanListWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 上传照片 */
+ (void)postJsonWithParameters:(NSDictionary *)params imageArray:(NSArray *)imageArray success:(void (^)(id json))success fail:(void (^)(void))fail;

/** 删除日志 */
+ (void)deleteRjhPlanWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 客户检索 */
+ (void)getBpcListWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 保存/编辑日志 */
+ (void)saveRjhPlanWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 获取职级关系 */
+ (void)getZjgxWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailBlock)fail;

/** 保存评论 */
+ (void)saveCommentWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 删除评论 */
+ (void)deleteCommentWithParameters:(NSDictionary *)params success:(void(^)(id json))success fail:(void(^)(void))fail;

/** 获取 工作项/客户工作类别/客户具体工作项 */
+ (void)getWorkType:(WKWorkTypeParam *)workTypeParam success:(void(^)(NSArray *work))success fail:(void(^)(void))fail;


/**
 获取项目列表

 @param projectParam 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)getProjectList:(WKProjectParam *)projectParam success:(void(^)(NSArray *projectList))success fail:(void(^)(void))fail;

@end
