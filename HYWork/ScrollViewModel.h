//
//  ScrollViewModel.h
//  HYWork
//
//  Created by information on 16/4/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollViewModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)scrollModelWithDict:(NSDictionary *)dict;

@end
