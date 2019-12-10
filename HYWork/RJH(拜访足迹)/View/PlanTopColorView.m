//
//  PlanTopColorView.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "PlanTopColorView.h"
#import "RjhPlanFrame.h"
#import "RjhPlan.h"
#import "CustomerLabel.h"

@interface PlanTopColorView()
/** 时间label */
@property (nonatomic, weak) CustomerLabel  *timeLabel;

/** 承办label*/
@property (nonatomic, weak) UILabel  *undertakeLabel;

/** 考勤按钮 */
@property (nonatomic, weak) UIButton  *attendanceBtn;
@end

@implementation PlanTopColorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        // 1.添加时间label
        CustomerLabel *timeLabel = [[CustomerLabel alloc] init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [timeLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 2.承办信息label
        UILabel *undertakeLabel = [[UILabel alloc] init];
        undertakeLabel.textColor = [UIColor whiteColor];
        [undertakeLabel setFont:[UIFont systemFontOfSize:15]];
        undertakeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:undertakeLabel];
        self.undertakeLabel = undertakeLabel;
        
        // 3.考勤按钮
        UIButton *attendanceBtn = [[UIButton alloc] init];
        [attendanceBtn setImage:[UIImage imageNamed:@"enattendance"] forState:UIControlStateNormal];
        [attendanceBtn setImage:[UIImage imageNamed:@"disattendance"] forState:UIControlStateDisabled];
        [attendanceBtn addTarget:self action:@selector(attendanceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attendanceBtn];
        self.attendanceBtn = attendanceBtn;
    }
    return self;
}

- (void)setPlanFrame:(RjhPlanFrame *)planFrame {
    _planFrame = planFrame;
    
    // 0.取出模型
    RjhPlan *plan = planFrame.plan;
    switch (plan.type) {
        case 1: case 4:
            self.backgroundColor = GQColor(65, 199, 216);
            break;
        case 2: case 5:
            self.backgroundColor = GQColor(255, 204, 0);
            break;
        case 3: case 6:
            self.backgroundColor = GQColor(255, 102, 51);
            break;
        case 7:
            self.backgroundColor = GQColor(0, 255, 0);
            break;
        default:
            break;
    }
    
    // 1.时间label
    self.timeLabel.frame = self.planFrame.timeLabelF;
    if (plan.allday) {
        self.timeLabel.text = @"全天";
    } else {
        int hour = [[plan.logtime substringToIndex:2] intValue];
        if (hour < 8 || hour >= 18) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",@"晚上",plan.logtime];
        }else if (hour >= 8 && hour < 12) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",@"上午",plan.logtime];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",@"下午",plan.logtime];
        }
    }
    
    // 2.中间内容
    self.undertakeLabel.frame = self.planFrame.undertakeLabelF;
    if (![plan.operatorid isEqual:[NSNull null]]) {
        if ([plan.operatorid length] > 0 && [plan.userid isEqualToString:plan.creater]) {
            self.undertakeLabel.text = @"已承办";
        }else if ([plan.operatorid length] > 0 && ![plan.userid isEqualToString:plan.creater]) {
            self.undertakeLabel.text = [NSString stringWithFormat:@"来自%@",plan.creatername];
        }
    }

    // 3.考勤
    self.attendanceBtn.frame = self.planFrame.attendanceBtnF;
    if (![plan.signin isEqual:[NSNull null]] && [plan.signin length] > 0) {
        self.attendanceBtn.enabled = false;
    }else{
        self.attendanceBtn.enabled = true;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //圆角处理
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/** 考勤按钮点击 */
- (void)attendanceBtnClick {
    if ([self.delegate respondsToSelector:@selector(planTopColorViewDidClickAttendanceBtn:)]) {
        [self.delegate planTopColorViewDidClickAttendanceBtn:self];
    }
}

@end
