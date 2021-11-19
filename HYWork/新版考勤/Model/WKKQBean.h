//
//  WKKQBean.h
//  HYWork
//
//  Created by information on 2021/4/7.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKKQBean : NSObject

// 位置信息
@property (nonatomic, copy) NSString *wzStr;

// 考勤按钮图片名称
@property (nonatomic, copy) NSString *kqBtnStr;

// 考勤按钮状态
@property (nonatomic, assign) BOOL kqBtnClick;

// 刷新按钮图片名称
@property (nonatomic, copy) NSString *refreshBtnStr;

// 刷新按钮状态
@property (nonatomic, assign) BOOL refreshBtnClick;

// 考勤次数
@property (nonatomic, assign) int count;

// 考勤提醒
@property (nonatomic, assign) BOOL kqtx;

// 登陆名
@property (nonatomic, copy) NSString *loginName;

// 日期
@property (nonatomic, copy) NSString *date;

// 时间
@property (nonatomic, copy) NSString *time;

// 考勤时间
@property (nonatomic, copy) NSString *signInTime;

@end

NS_ASSUME_NONNULL_END
