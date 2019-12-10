//
//  RjhHeaderView.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhHeaderView.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"

@interface RjhHeaderView()<datePickerDelegate,UIGestureRecognizerDelegate>
/** 轨迹 */
@property (nonatomic, weak) UIButton  *trailBtn;
/** 中间的日期标题 */
@property (nonatomic, weak) UILabel  *dateTitleLabel;
/** 右边的日期控件 */
@property (nonatomic, weak) UIButton  *calendarBtn;
/** 底部横线 */
@property (nonatomic, weak) UIView  *lineView;
/** 日期选择器 */
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;
@end

@implementation RjhHeaderView

+ (instancetype)headerView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 右边的日历控件
        UIButton *trailBtn = [[UIButton alloc] init];
        [trailBtn setImage:[UIImage imageNamed:@"trail"] forState:UIControlStateNormal];
        [trailBtn addTarget:self action:@selector(trailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trailBtn];
        self.trailBtn = trailBtn;
        
        // 中间的日期标题
        UILabel *dateTitleLabel = [[UILabel alloc] init];
        dateTitleLabel.textAlignment = NSTextAlignmentCenter;
        dateTitleLabel.textColor = GQColor(102, 102, 102);
        //dateTitleLabel.text = @"2017年4月26日 星期三";
        [self addSubview:dateTitleLabel];
        self.dateTitleLabel = dateTitleLabel;
        
        // 右边的日历控件
        UIButton *calendarBtn = [[UIButton alloc] init];
        [calendarBtn setImage:[UIImage imageNamed:@"rili_64"] forState:UIControlStateNormal];
        [calendarBtn addTarget:self action:@selector(calendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:calendarBtn];
        self.calendarBtn = calendarBtn;
        
        // 底部横线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(204, 204, 204);
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    
    // 0.轨迹
    CGFloat trailBtnX = 0;
    CGFloat trailBtnY = 0;
    CGFloat trailBtnWH = parentH - 1;
    self.trailBtn.frame = CGRectMake(trailBtnX, trailBtnY, trailBtnWH, trailBtnWH);
    
    // 1.日历 frame
    CGFloat calendarBtnWH = parentH - 1;
    CGFloat calendarBtnX = parentW - calendarBtnWH;
    CGFloat calendarBtnY = 0;
    self.calendarBtn.frame = CGRectMake(calendarBtnX, calendarBtnY, calendarBtnWH, calendarBtnWH);
    
    // 2.title
    CGFloat dateTitleLabelX = calendarBtnWH;
    CGFloat dateTitleLabelY = 0;
    CGFloat dateTitleLabelW = parentW - 2 * calendarBtnWH;
    CGFloat dateTitleLabelH = calendarBtnWH;
    self.dateTitleLabel.frame = CGRectMake(dateTitleLabelX, dateTitleLabelY, dateTitleLabelW, dateTitleLabelH);
    
    // 3. lineView
    CGFloat lineViewX = 0;
    CGFloat lineViewY = calendarBtnWH;
    CGFloat lineViewW = parentW;
    CGFloat lineViewH = 1;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

/** 刚进界面初始化 */
- (void)setupDateCondition {
    NSDate *nowDate = [NSDate date];
    [self formateDate:nowDate];
}

- (void)formateDate:(NSDate *)date {
    NSString *weekday = [NSDate weekdayStringFromDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    self.dateTitleLabel.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date], weekday];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.currentDate = [formatter stringFromDate:date];
    if ([self.delegate respondsToSelector:@selector(headerViewChangeRefreshTableView:)]) {
        [self.delegate headerViewChangeRefreshTableView:self];
    }
}

/** 日期选择器 */
- (void)calendarBtnClick {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.superview.dc_height - 236.0f, self.dc_width, 236.0f)];
        _datePickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview addSubview:self.cover];
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _cover;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.cover.subviews[0].frame, point)) {
        return NO;
    }
    return YES;
}

- (void)tapCover {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.cover removeFromSuperview];
    }];
}

- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *pickDate = [formatter dateFromString:datePickerView.selectedDate];
            [self formateDate:pickDate];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

/** 轨迹图 */
- (void)trailBtnClick {
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickTrailBtn:)]) {
        [self.delegate headerViewDidClickTrailBtn:self];
    }
}

@end
