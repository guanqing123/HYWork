//
//  Emp.h
//  HYWork
//
//  Created by information on 16/4/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emp : NSObject <NSCoding>
/**
 *  部门编码
 */
@property (nonatomic, copy) NSString *bmbm;
/**
 *  部门名称
 */
@property (nonatomic, copy) NSString *bmmc;
/**
 *  部门ID
 */
@property (nonatomic, copy) NSString *ecologydeptid;
/**
 *  泛微用户ID
 */
@property (nonatomic, copy) NSString *ecologyid;
/**
 *  员工编码
 */
@property (nonatomic, copy) NSString *ygbm;
/**
 *  部门编码
 */
@property (nonatomic, copy) NSString *jzbmbm;
/**
 *  手机/电话
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  短号
 */
@property (nonatomic, copy) NSString *mobilecall;
/**
 *  oa 密码
 */
@property (nonatomic, copy) NSString *oamm;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *slave;
/**
 *  状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  手机
 */
@property (nonatomic, copy) NSString *telephone;
/**
 *  员工姓名
 */
@property (nonatomic, copy) NSString *ygxm;

/**
 * 行政职级
 */
@property (nonatomic, copy) NSString *xzzj;

/**
 *  帆软地址
 */
@property (nonatomic, copy) NSString *frdz;

/**
 密码
 */
@property (nonatomic, copy) NSString *mm;

@end
