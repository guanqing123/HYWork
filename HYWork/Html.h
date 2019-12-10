//
//  Html.h
//  HYWork
//
//  Created by information on 16/6/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Html : NSObject
/**
 *  网页标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  网页文件名
 */
@property (nonatomic, copy) NSString *html;

@property (nonatomic, copy) NSString *ID;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)htmlWithDict:(NSDictionary *)dict;
@end
