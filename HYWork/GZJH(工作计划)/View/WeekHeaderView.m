//
//  WeekHeaderView.m
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekHeaderView.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"

@interface WeekHeaderView() <datePickerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIButton  *prevText;
@property (nonatomic, weak) UIButton  *prevBtn;
@property (nonatomic, weak) UIButton  *middleBtn;
@property (nonatomic, weak) UIButton  *nextBtn;
@property (nonatomic, weak) UIButton  *nextText;
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;

@end

@implementation WeekHeaderView

+ (instancetype)headerView:(CGRect)frame {
    WeekHeaderView *headerView = [[WeekHeaderView alloc] initWithFrame:frame];
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
        
        CGFloat  height = frame.size.height;
        
        UIButton *prevText = [UIButton buttonWithType:UIButtonTypeCustom];
        prevText.frame = CGRectMake(0, 0, SCREEN_WIDTH/8, height - 1);
        [prevText setTitle:@"取消" forState:UIControlStateNormal];
        [prevText setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        [prevText addTarget:self action:@selector(prevTextClick:) forControlEvents:UIControlEventTouchUpInside];
        prevText.hidden = YES;
        _prevText = prevText;
        [self addSubview:prevText];
        
        UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        prevBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/8, height - 1);
        [prevBtn setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
        [prevBtn addTarget:self action:@selector(prevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        prevBtn.hidden = YES;
        _prevBtn = prevBtn;
        [self addSubview:prevBtn];
        
        UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        middleBtn.frame = CGRectMake(SCREEN_WIDTH/8, 0, SCREEN_WIDTH * 3/4, height - 1);
        [middleBtn setTitleColor:GQColor(129.0f, 129.0f, 129.0f) forState:UIControlStateNormal];
        [middleBtn addTarget:self action:@selector(middleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        middleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _middleBtn = middleBtn;
        [self addSubview:middleBtn];
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(SCREEN_WIDTH * 7/8, 0, SCREEN_WIDTH - CGRectGetMaxX(middleBtn.frame), height - 1);
        [nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.hidden = YES;
        _nextBtn = nextBtn;
        [self addSubview:nextBtn];
        
        UIButton *nextText = [UIButton buttonWithType:UIButtonTypeCustom];
        nextText.frame = CGRectMake(SCREEN_WIDTH * 7/8, 0, SCREEN_WIDTH - CGRectGetMaxX(middleBtn.frame), height - 1);
        [nextText setTitle:@"全选" forState:UIControlStateNormal];
        [nextText setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        [nextText addTarget:self action:@selector(nextTextClick:) forControlEvents:UIControlEventTouchUpInside];
        nextText.hidden = YES;
        _nextText = nextText;
        [self addSubview:nextText];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0.0f, 35.0f, SCREEN_WIDTH, 1.0f);
        lineView.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        [self addSubview:lineView];
    }
    return self;
}


- (void)setEdit:(BOOL)edit {
    _edit = edit;
    if (edit) {
        self.prevText.hidden = NO;
        self.nextText.hidden = NO;
        self.prevBtn.hidden = YES;
        self.nextBtn.hidden = YES;
    }else{
        self.prevText.hidden = YES;
        self.nextText.hidden = YES;
        self.prevBtn.hidden = NO;
        self.nextBtn.hidden = NO;
    }
}

/**
 *  点击取消按钮
 *
 *  @param prevText 按钮
 */
- (void)prevTextClick:(UIButton *)prevText {
    if ([self.delegate respondsToSelector:@selector(weekHeaderDidClickCancelButtonLoadData:)]) {
        [self.delegate weekHeaderDidClickCancelButtonLoadData:self];
    }
}

/**
 *  点击全选按钮
 *
 *  @param nextText 按钮
 */
- (void)nextTextClick:(UIButton *)nextText {
    if ([self.delegate respondsToSelector:@selector(weekHeaderDidClickAllChooseButtonLoadData:)]) {
        [self.delegate weekHeaderDidClickAllChooseButtonLoadData:self];
    }
}

/**
 *  刚进页面初始化
 *
 *  @param date 日期
 */
- (void)fillBeginAndEndDateWithPickDate:(NSDate *)date gzjhPlanType:(GzjhPlanType)planType{
    _planType = planType;
    
    NSArray *array = nil;
    switch (planType) {
        case GzjhPlanTypeWeek:
            array = [NSDate getWeekBeginAndEndWithNSdate:date];
            break;
        case GzjhPlanTypeMonth:
            array = [NSDate getMonthBeginAndEndWithNSdate:date];
        default:
            break;
    }
    
    if (array) {
        [self setBeginAndEndDateWithNSArray:array];
    }
}

/**
 *  点击向前日期按钮
 *
 *  @param prevBtn 按钮
 */
- (void)prevBtnClick:(UIButton *)prevBtn {
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [sdf dateFromString:_beginDate];
    
    NSArray *array = nil;
    
    switch (_planType) {
        case GzjhPlanTypeWeek:
            array = [NSDate prevWeekBeginAndEndWithNsdate:date];
            break;
        case GzjhPlanTypeMonth:
            array = [NSDate prevMonthBeginAndEndWithNsdate:date];
            break;
        default:
            break;
    }
    
    if (array) {
        [self setBeginAndEndDateWithNSArray:array];
    }
}

/**
 *  点击向后日期按钮
 *
 *  @param nextBtn 按钮
 */
- (void)nextBtnClick:(UIButton *)nextBtn {
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [sdf dateFromString:_beginDate];
    
    NSArray *array = nil;
    
    switch (_planType) {
        case GzjhPlanTypeWeek:
            array = [NSDate nextWeekBeginAndEndWithNsdate:date];
            break;
        case GzjhPlanTypeMonth:
            array = [NSDate nextMonthBeginAndEndWithNsdate:date];
            break;
        default:
            break;
    }
    
    if (array) {
        [self setBeginAndEndDateWithNSArray:array];
    }
}

/**
 *  调用代理,加载工作计划
 *
 *  @param array 开始和结束日期
 */
- (void)setBeginAndEndDateWithNSArray:(NSArray *)array {
    _beginDate = array[0];
    _endDate = array[1];
    NSString *title = [NSString stringWithFormat:@"%@ 至 %@",_beginDate,_endDate];
    [self.middleBtn setTitle:title forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(weekHeaderFinishDateDidLoadTableData:)]) {
        [self.delegate weekHeaderFinishDateDidLoadTableData:self];
    }
}

/**
 *  中间按钮点击
 */
- (void)middleBtnClick:(UIButton *)middleBtn {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.superview.dc_height - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview addSubview:self.cover];
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.superview.dc_height)];
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

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure: {
            NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
            [sdf setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [sdf dateFromString:datePickerView.selectedDate];
            [self fillBeginAndEndDateWithPickDate:date gzjhPlanType:self.planType];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

@end
