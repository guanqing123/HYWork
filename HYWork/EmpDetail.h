//
//  EmpDetail.h
//  HYWork
//
//  Created by information on 16/4/19.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmpDetail : NSObject
/**
 *  部门职位
 */
@property (nonatomic, copy) NSString *bmzw;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  手机
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  mobilecall
 */
@property (nonatomic, copy) NSString *mobilecall;
/**
 *  telephone
 */
@property (nonatomic, copy) NSString *telephone;
/**
 *  员工姓名
 */
@property (nonatomic, copy) NSString *ygxm;

/**
 *  职位数组
 */
@property (nonatomic, strong)  NSArray *zws;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)empDetailWithDict:(NSDictionary *)dict;
@end
