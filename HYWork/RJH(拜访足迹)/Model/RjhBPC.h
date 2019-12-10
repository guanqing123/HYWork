//
//  RjhBPC.h
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RjhBPC : NSObject
/** 客户排序id */
@property (nonatomic, assign) int bpcId;
/** 客户代码 */
@property (nonatomic, copy) NSString *khdm;
/** 客户名称 */
@property (nonatomic, copy) NSString *khmc;
@end
