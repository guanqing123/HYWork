//
//  Item.h
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *destVcClass;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *load;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end
