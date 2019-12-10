//
//  RjhPlan.h
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "RjhRemark.h"

typedef enum {
    PlanTypeVisitBpc = 1,
    PlanTypeImportantWork = 2,
    PlanTypeNote = 3
} PlanType;

typedef enum {
    BpcTypePotential = 1,
    BpcTypeSigning = 2
} BpcType;

@interface RjhPlan : NSObject

/** 全天标记,0:非全天;1:全天 */
@property (nonatomic, assign) int allday;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 创建者 */
@property (nonatomic, copy) NSString *creater;
/** 创建者姓名 */
@property (nonatomic, copy) NSString *creatername;

/** 附带图片/照片id,多张图片/照片id用","隔开 */
@property (nonatomic, copy) NSString *imageid;
/** 附带图片url数组 */
@property (nonatomic, strong) NSArray *imagesurl;

/** 客户联系人电话 */
@property (nonatomic, copy) NSString *kh_lxdh;
/** 客户联系人 */
@property (nonatomic, copy) NSString *kh_lxr;
/** 客户代码 */
@property (nonatomic, copy) NSString *khdm;
/** 客户地址/位置(文本) */
@property (nonatomic, copy) NSString *khdz;
/** 纬度(客户地址/位置) */
@property (nonatomic, copy) NSString *khdz_latitude;
/** 经度(客户地址/位置) */
@property (nonatomic, copy) NSString *khdz_longitude;
/** 客户名称 */
@property (nonatomic, copy) NSString *khmc;

/** label_color */
@property (nonatomic, copy) NSString *label_color;
/** 日期 */
@property (nonatomic, copy) NSString *logdate;
/** 日志id */
@property (nonatomic, copy) NSString *logid;
/** 时间 */
@property (nonatomic, copy) NSString *logtime;

/** 操作者 */
@property (nonatomic, copy) NSString *operatorid;
/** 操作者姓名 */
@property (nonatomic, copy) NSString *operatorname;

/** 评论列表 */
@property (nonatomic, strong) NSArray *remarklist;

/** 签到地址/位置(文本) */
@property (nonatomic, copy) NSString *signin;
/** 签到图片 */
@property (nonatomic, copy) NSString *signin_image;
/** 签到地址/位置(纬度) */
@property (nonatomic, copy) NSString *signin_latitude;
/** 签到地址/位置(经度) */
@property (nonatomic, copy) NSString *signin_longitude;
/** 签到时间 */
@property (nonatomic, copy) NSString *signin_time;

//@property (nonatomic, strong)  NSArray *signinlist;

@property (nonatomic, copy) NSString *status;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 类型 */
@property (nonatomic, assign) int type;
/** 客户类型 */
@property (nonatomic, assign) BpcType kh_lb;
/** 工号 */
@property (nonatomic, copy) NSString *userid;
/** 客户工作类别 */
@property (nonatomic, assign) int leveltype;
/** 客户具体工作项 */
@property (nonatomic, copy) NSString *jobtype;
/** 备注 */
@property (nonatomic, copy) NSString *jobremark;
/** 工程号 */
@property (nonatomic, copy) NSString *projectid;
/** 备注占位符 */
@property (nonatomic, copy) NSString *jobremark_placeholder;

@end
