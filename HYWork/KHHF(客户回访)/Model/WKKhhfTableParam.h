//
//  WKKhhfTableParam.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBaseParam.h"

@interface WKKhhfTableParam : WKBaseParam

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *khdm;

@property (nonatomic, copy) NSString *khmc;

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *dq;

@property (nonatomic, copy) NSString *lb;

@end
