//
//  Txl.h
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Txl : NSObject

/**
 *  部门名称
 */
@property (nonatomic, copy) NSString *bmmc;
/**
 *  泛微 id
 */
@property (nonatomic, copy) NSString *ecologyid;
/**
 *  手机
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  拼音简写
 */
@property (nonatomic, copy) NSString *pinyinlastname;
/**
 *  员工编码
 */
@property (nonatomic, copy) NSString *ygbm;
/**
 *  员工姓名
 */
@property (nonatomic, copy) NSString *ygxm;
/**
 *  职位说明
 */
@property (nonatomic, copy) NSString *zwsm;

@end
