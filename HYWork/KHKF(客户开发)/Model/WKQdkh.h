//
//  WKQdkh.h
//  HYWork
//
//  Created by information on 2018/11/21.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKTjz5.h"
NS_ASSUME_NONNULL_BEGIN

@interface WKQdkh : NSObject

/**
 序号
 */
@property (nonatomic, copy) NSString *xh;

/**
 客户简称
 */
@property (nonatomic, copy) NSString *gjz;

/**
 客户名称
 */
@property (nonatomic, copy) NSString *mc;

/**
 地区代码
 */
@property (nonatomic, copy) NSString *ty20;

/**
 地区名称
 */
@property (nonatomic, copy) NSString *dqmc;

/**
 店面地址
 */
@property (nonatomic, copy) NSString *ty2;

/**
 联系人
 */
@property (nonatomic, copy) NSString *lxr;

/**
 联系方式
 */
@property (nonatomic, copy) NSString *lxfs;

/**
 上级经销商代码
 */
@property (nonatomic, copy) NSString *ty17;

/**
 上级经销商名称
 */
@property (nonatomic, copy) NSString *khmc;

/**
 业务员工号
 */
@property (nonatomic, copy) NSString *ywy;

/**
 门头照片
 */
@property (nonatomic, copy) NSString *fj1;

/**
 店内照片
 */
@property (nonatomic, copy) NSString *fj2;

/**
 销售点类型
 */
@property (nonatomic, copy) NSString *xsdlx;

/**
 经营规模（万）
 */
@property (nonatomic, copy) NSString *yjspjh;

/**
 预计首批进货额
 */
@property (nonatomic, copy)  NSString  *jymsw;

/**
 首次合作时间
 */
@property (nonatomic, copy) NSString *schzsj;

/**
 合作产业
 */
@property (nonatomic, copy) NSString *ty1;

/**
 备注
 */
@property (nonatomic, copy) NSString *bz;

/**
 系列
 */
@property (nonatomic, strong)  NSArray *xl;
@end

NS_ASSUME_NONNULL_END
