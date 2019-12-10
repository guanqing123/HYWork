//
//  QyryModel.h
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QyryModel : NSObject

@property (nonatomic, copy) NSString *honerId;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
