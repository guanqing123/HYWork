//
//  MonthPlan.h
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthPlan : NSObject

@property (nonatomic, copy) NSString *cbr;
@property (nonatomic, copy) NSString *dfld;
@property (nonatomic, copy) NSString *fbr;
@property (nonatomic, copy) NSString *fz;
@property (nonatomic, copy) NSString *gznr;
@property (nonatomic, copy) NSString *hlzb;
/**
 *  自评.任务状态
 */
@property (nonatomic, copy) NSString *jhzt;
@property (nonatomic, copy) NSString *khbz;
@property (nonatomic, copy) NSString *kssj;
@property (nonatomic, copy) NSString *n_cbr;
@property (nonatomic, copy) NSString *n_dfld;
@property (nonatomic, copy) NSString *n_fbr;
@property (nonatomic, copy) NSString *n_jhzt;
@property (nonatomic, copy) NSString *n_shld;
@property (nonatomic, copy) NSString *n_state;
@property (nonatomic, copy) NSString *n_xbr;
@property (nonatomic, copy) NSString *n_zblx;
/**
 *  自评.评议
 */
@property (nonatomic, copy) NSString *py;
@property (nonatomic, copy) NSString *shld;
@property (nonatomic, copy) NSString *sjxh;
@property (nonatomic, copy) NSString *sjxz;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *xbr;
@property (nonatomic, copy) NSString *xdfa;
@property (nonatomic, copy) NSString *xh;
@property (nonatomic, copy) NSString *ygznr;
@property (nonatomic, copy) NSString *yjwc;
@property (nonatomic, copy) NSString *zblx;
@property (nonatomic, copy) NSString *zbxh;

@property (nonatomic, assign) int flag;

@end
