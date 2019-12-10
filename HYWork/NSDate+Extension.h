//
//  NSDate+Extension.h
//  HYWork
//
//  Created by information on 16/5/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 获取传入时间所在的周的开始和结束日 */
+ (NSArray *)getWeekBeginAndEndWithNSdate:(NSDate *)date;

/** 获取传入时间所在的周的开始和结束日期*/
+ (NSArray *)getWeekBeginAndEnd:(NSDate *)date;

/** 获取前一周所在的周的开始和结束日 */
+ (NSArray *)prevWeekBeginAndEndWithNsdate:(NSDate *)date;

/** 获取后一周所在的周的开始和结束日 */
+ (NSArray *)nextWeekBeginAndEndWithNsdate:(NSDate *)date;

/** 获取传入时间所在的月的开始和结束日 */
+ (NSArray *)getMonthBeginAndEndWithNSdate:(NSDate *)date;

/** 获取前一个月所在的月的开始和结束日 */
+ (NSArray *)prevMonthBeginAndEndWithNsdate:(NSDate *)date;

/** 获取后一个月所在的月的开始和结束日 */
+ (NSArray *)nextMonthBeginAndEndWithNsdate:(NSDate *)date;

+ (NSString *)weekdayStringFromStr:(NSString *)inputStr;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
