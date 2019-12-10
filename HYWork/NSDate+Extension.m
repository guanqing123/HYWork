//
//  NSDate+Extension.m
//  HYWork
//
//  Created by information on 16/5/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  根据传入日期 获取这周开始和结束的日期
 *
 *  @param date 传入日期
 *
 *  @return 返回这周开始和结束日期
 */
+ (NSArray *)getWeekBeginAndEndWithNSdate:(NSDate *)date {
    if(date==nil){
        date = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    if (theComponents.weekday >= 5 || theComponents.weekday == 1) {
        date = [date dateByAddingTimeInterval:60*60*24*7];
        return [self getWeekBeginAndEnd:date];
    }else{
        return [self getWeekBeginAndEnd:date];
    }
}


+ (NSArray *)getWeekBeginAndEnd:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日 NSCalendarUnitWeekOfMonth
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSMonthCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [sdf stringFromDate:beginDate];
    NSString *endString = [sdf stringFromDate:endDate];
    NSArray *array = [NSArray arrayWithObjects:beginString , endString, nil];
    return array;
}

/**
 *  返回上一周开始和结束日期
 */
+ (NSArray *)prevWeekBeginAndEndWithNsdate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    date = [date dateByAddingTimeInterval:-60*60*24*7];
    //return [self getWeekBeginAndEndWithNSdate:date];
    return [self getWeekBeginAndEnd:date];
}

/**
 *  返回下一周开始和结束日期
 */
+ (NSArray *)nextWeekBeginAndEndWithNsdate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    date = [date dateByAddingTimeInterval:60*60*24*7];
    //return [self getWeekBeginAndEndWithNSdate:date];
    return [self getWeekBeginAndEnd:date];
}

/**
 *  根据传入日期 获取这月开始和结束的日期
 *
 *  @param date 传入日期
 *
 *  @return 返回这月开始和结束日期
 */
+ (NSArray *)getMonthBeginAndEndWithNSdate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日 NSCalendarUnitWeekOfMonth
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSMonthCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [sdf stringFromDate:beginDate];
    NSString *endString = [sdf stringFromDate:endDate];
    NSArray *array = [NSArray arrayWithObjects:beginString , endString, nil];
    return array;
}

/**
 *  返回上一个月开始和结束日期
 */
+ (NSArray *)prevMonthBeginAndEndWithNsdate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:-1];
    [comps setDay:0];
    NSDate *prevDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    return [self getMonthBeginAndEndWithNSdate:prevDate];
}

/**
 *  返回下一个月开始和结束日期
 */
+ (NSArray *)nextMonthBeginAndEndWithNsdate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:+1];
    [comps setDay:0];
    NSDate *nextDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    return [self getMonthBeginAndEndWithNSdate:nextDate];
}

+ (NSString *)weekdayStringFromStr:(NSString *)inputStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [NSDate weekdayStringFromDate:[formatter dateFromString:inputStr]];
}

/**
 *  根据日期返回日期所对应的星期
 */
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
