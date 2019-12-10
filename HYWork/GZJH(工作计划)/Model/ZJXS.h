//
//  ZJXS.h
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJXS : NSObject

/**
 *  员工编码
 */
@property (nonatomic, copy) NSString *ygbm;

/**
 *  员工姓名
 */
@property (nonatomic, copy) NSString *ygxm;

/**
 *  标记
 */
@property (nonatomic, assign) BOOL flag;

/**
 行政职级
 */
@property (nonatomic, copy) NSString *xzzj;
@end
