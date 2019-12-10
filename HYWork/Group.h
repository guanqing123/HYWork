//
//  Group.h
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic,copy) NSString *header;
@property (strong, nonatomic)  NSArray *items;
@property (assign, nonatomic) CGFloat r;
@property (assign, nonatomic) CGFloat g;
@property (assign, nonatomic) CGFloat b;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
