//
//  RjhTrail.h
//  HYWork
//
//  Created by information on 2017/6/15.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RjhTrail : NSObject
/** 维度 */
@property (nonatomic, assign) double signin_latitude;
/** 考勤地址 */
@property (nonatomic, copy) NSString *signin;
/** 经度 */
@property (nonatomic, assign) double signin_longitude;
/** 考勤时间 */
@property (nonatomic, copy) NSString *signin_time;
@end
