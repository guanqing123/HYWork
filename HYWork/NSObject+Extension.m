//
//  NSObject+Extension.m
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

+ (NSArray *)getCurrentWeekDateAndTime{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    long week = [comps weekday];
    long year=[comps year];
    long month = [comps month];
    long day = [comps day];
    long hour = [comps hour];
    long  minute = [comps minute];
    NSString *currentDate = [NSString stringWithFormat:@"%@: %ld.%02ld.%02ld",[arrWeek objectAtIndex:week - 1],year,month,day];
    NSString *currentTime = [NSString stringWithFormat:@"当前时间: %02ld:%02ld",hour,minute];
    NSArray *dateAndTime = [NSArray arrayWithObjects:currentDate,currentTime, nil];
    return dateAndTime;
}

+ (NSArray *)getCurrentDateAndTime{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    long year=[comps year];
    long month = [comps month];
    long day = [comps day];
    long hour = [comps hour];
    long  minute = [comps minute];
    NSString *currentDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day];
    NSString *currentTime = [NSString stringWithFormat:@"%02ld:%02ld",hour,minute];
    NSArray *dateAndTime = [NSArray arrayWithObjects:currentDate,currentTime, nil];
    return dateAndTime;
}


@end
