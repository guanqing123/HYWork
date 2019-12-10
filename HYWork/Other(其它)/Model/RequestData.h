//
//  RequestData.h
//  HYWork
//
//  Created by information on 16/3/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject

@property (nonatomic,copy) NSString *need_paginate;
@property (nonatomic,copy) NSString *page_number;
@property (nonatomic,copy) NSString *page_size;

- (instancetype)initWithDataNeedPaginate:(NSString *)need_paginate pageNumber:(NSString *)page_number pageSize:(NSString *)page_size;

+ (instancetype)requestWithDataNeedPaginate:(NSString *)need_paginate pageNumber:(NSString *)page_number pageSize:(NSString *)page_size;

@end
