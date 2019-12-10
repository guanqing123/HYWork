//
//  WKKhhfTableResult.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBaseResult.h"
#import "WKKhhf.h"

@interface WKKhhfTableResult : WKBaseResult

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, strong)  NSArray *list;

@property (nonatomic, assign) NSInteger totalPage;

@end
