//
//  RjhPlanFrame.h
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 表格的边框宽度 */
#define RjhPlanTableBorder 5

/** cell的边框宽度 */
#define RjhPlanCellBorder 10

// 正文的字体
#define RjhTextFont [UIFont systemFontOfSize:14]


@class RjhPlan;
@interface RjhPlanFrame : NSObject
@property (nonatomic, strong)  RjhPlan *plan;

/** 顶部颜色的view */
@property (nonatomic, assign, readonly) CGRect topColorViewF;
/** 时间label */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 承办人label */
@property (nonatomic, assign, readonly) CGRect undertakeLabelF;
/** 考勤按钮 */
@property (nonatomic, assign, readonly) CGRect attendanceBtnF;

/** 中间文本view */
@property (nonatomic, assign, readonly) CGRect middelTextViewF;
/** 标题label */
@property (nonatomic, assign, readonly) CGRect titleLabelF;
/** 标题内容label */
@property (nonatomic, assign, readonly) CGRect titleF;
/** 客户label */
@property (nonatomic, assign, readonly) CGRect khLabelF;
/** 客户内容label */
@property (nonatomic, assign, readonly) CGRect khF;
/** 联系人/联系电话label */
@property (nonatomic, assign, readonly) CGRect telLabelF;
/** 联系人内容label */
@property (nonatomic, assign, readonly) CGRect telF;
/** 联系电话内容button */
@property (nonatomic, assign, readonly) CGRect phoneBtnF;
/** 考勤图标 */
@property (nonatomic, assign, readonly) CGRect kqBtnF;
/** 考勤地点 */
@property (nonatomic, assign, readonly) CGRect addressLabelF;
/** 考勤时间图标 */
@property (nonatomic, assign, readonly) CGRect kqTimeBtnF;
/** 考勤时间 */
@property (nonatomic, assign, readonly) CGRect kqTimeLabelF;


/** 底部正文/图片view */
@property (nonatomic, assign, readonly) CGRect contentPhotoViewF;
/** 正文内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 图片 */
@property (nonatomic, assign, readonly) CGRect photosViewF;
/** 评论 */
@property (nonatomic, assign, readonly) CGRect commentViewF;

/** 底部共具体 */
@property (nonatomic, assign, readonly) CGRect toolbarViewF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
