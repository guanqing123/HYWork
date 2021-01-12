//
//  NSObject+Extension.h
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/** 获取当前星期几,年月日,时分 */
+ (NSArray *)getCurrentWeekDateAndTime;

/** 获取当年月日,时分 */
+ (NSArray *)getCurrentDateAndTime;

@end
