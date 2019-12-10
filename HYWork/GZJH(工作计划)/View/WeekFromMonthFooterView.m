//
//  WeekFromMonthFooterView.m
//  HYWork
//
//  Created by information on 16/6/8.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekFromMonthFooterView.h"
#import "HYButton.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"

@interface WeekFromMonthFooterView()<datePickerDelegate,UIGestureRecognizerDelegate>
/**
 *  开始日期 按钮
 */
@property (nonatomic, weak) HYButton  *beginBtn;
/**
 *  结束日期 按钮
 */
@property (nonatomic, weak) HYButton  *endBtn;
@end

@implementation WeekFromMonthFooterView

+ (instancetype)footerView {
    WeekFromMonthFooterView *footerView = [[WeekFromMonthFooterView alloc] init];
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        lineView.backgroundColor = themeColor;
        [self addSubview:lineView];
        
        // 0.区间
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH/5, 44.0f);
        textLabel.text = @"日期:";
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = themeColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        
        // 1.开始日期
        HYButton *beginDate = [HYButton customButton];
        beginDate.frame = CGRectMake(CGRectGetMaxX(textLabel.frame), 6.0f, SCREEN_WIDTH/2, 32.0f);
        [beginDate addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _beginBtn = beginDate;
        [self addSubview:beginDate];
        
        // 2.确定按钮
        HYButton *sureBtn = [HYButton customButton];
        CGFloat sureBtnX = CGRectGetMaxX(beginDate.frame) + 5;
        sureBtn.frame = CGRectMake(sureBtnX, 10.0f, SCREEN_WIDTH - sureBtnX - 5, 24.0f);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:themeColor forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
    }
    return self;
}

- (void)setBeginDate:(NSString *)beginDate {
    _beginDate = [beginDate copy];
    [self.beginBtn setTitle:beginDate forState:UIControlStateNormal];
}

#pragma mark - 点击日期
- (void)dateBtnClick:(HYButton *)btn {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview addSubview:self.cover];
}

#pragma mark - cover
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

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
            [sdf setDateFormat:@"yyyy-MM-dd"];
            NSString *tempDate = [NSDate getMonthBeginAndEndWithNSdate:[sdf dateFromString:datePickerView.selectedDate]][0];
            _beginDate = tempDate;
            [self.beginBtn setTitle:tempDate forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(WeekFromMonthFooterViewDidClickDateBtn:)]) {
                [self.delegate WeekFromMonthFooterViewDidClickDateBtn:self];
            }
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - sureBtnClick
- (void)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(WeekFromMonthFooterViewDidClickSureBtn:)]) {
        [self.delegate WeekFromMonthFooterViewDidClickSureBtn:self];
    }
}

@end
