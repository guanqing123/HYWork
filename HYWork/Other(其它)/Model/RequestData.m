//
//  RequestData.m
//  HYWork
//
//  Created by information on 16/3/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "RequestData.h"

@implementation RequestData

- (instancetype)initWithDataNeedPaginate:(NSString *)need_paginate pageNumber:(NSString *)page_number pageSize:(NSString *)page_size
{
    if (self = [self init]) {
        self.need_paginate = need_paginate;
        self.page_number = page_number;
        self.page_size = page_size;
    }
    return self;
}

+ (instancetype)requestWithDataNeedPaginate:(NSString *)need_paginate pageNumber:(NSString *)page_number pageSize:(NSString *)page_size
{
    return [[self alloc] initWithDataNeedPaginate:need_paginate pageNumber:page_number pageSize:page_size];
}

@end
