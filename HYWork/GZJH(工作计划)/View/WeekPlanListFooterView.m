//
//  WeekPlanListFooterView.m
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanListFooterView.h"
#import "HYButton.h"
#import "DatePickerView.h"

@interface WeekPlanListFooterView()<datePickerDelegate,UIGestureRecognizerDelegate>
/**
 *  开始日期 按钮
 */
@property (nonatomic, weak) HYButton  *beginBtn;
/**
 *  结束日期 按钮
 */
@property (nonatomic, weak) HYButton  *endBtn;
@end

@implementation WeekPlanListFooterView

+ (instancetype)footerView {
    WeekPlanListFooterView *footerView = [[WeekPlanListFooterView alloc] init];
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
        textLabel.text = @"区间:";
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = themeColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        
        // 1.开始日期
        HYButton *beginDate = [HYButton customButton];
        beginDate.frame = CGRectMake(CGRectGetMaxX(textLabel.frame), 6.0f, SCREEN_WIDTH/4, 32.0f);
        beginDate.tag = 1;
        [beginDate addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _beginBtn = beginDate;
        [self addSubview:beginDate];
        
        // 1.5 中间线
        UIView *middleView = [[UIView alloc] init];
        middleView.frame = CGRectMake(CGRectGetMaxX(beginDate.frame) + 2, 22.5f, 10.0f, 1.0f);
        middleView.backgroundColor = [UIColor blackColor];
        [self addSubview:middleView];
        
        // 2.结束日期
        HYButton *endDate = [HYButton customButton];
        endDate.frame = CGRectMake(CGRectGetMaxX(middleView.frame) + 2, 6.0f, SCREEN_WIDTH/4, 32.0f);
        endDate.tag = 2;
        [endDate addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _endBtn = endDate;
        [self addSubview:endDate];
        
        // 3.确定按钮
        HYButton *sureBtn = [HYButton customButton];
        CGFloat sureBtnX = CGRectGetMaxX(endDate.frame) + 5;
        sureBtn.frame = CGRectMake(sureBtnX, 10.0f, SCREEN_WIDTH - sureBtnX - 5, 24.0f);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:themeColor forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
    }
    return self;
}

- (void)setBeginDate:(NSString *)beginDate {
    _beginDate = beginDate;
    [self.beginBtn setTitle:beginDate forState:UIControlStateNormal];
}

- (void)setEndDate:(NSString *)endDate {
    _endDate = endDate;
    [self.endBtn setTitle:endDate forState:UIControlStateNormal];
}

#pragma mark - 点击日期
- (void)dateBtnClick:(HYButton *)btn {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    _datePickerView.tag = btn.tag;
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
    if (datePickerView.tag == 1) {
        switch (buttonType) {
            case DatePickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case DatePickerViewButtonTypeSure:{
                _beginDate = datePickerView.selectedDate;
                [self.beginBtn setTitle:datePickerView.selectedDate forState:UIControlStateNormal];
                if ([self.delegate respondsToSelector:@selector(weekPlanListFooterViewDidClickDateBtn:)]) {
                    [self.delegate weekPlanListFooterViewDidClickDateBtn:self];
                }
                [self tapCover];
                break;
            }
            default:
                break;
        }
    }else if(datePickerView.tag == 2){
        switch (buttonType) {
            case DatePickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case DatePickerViewButtonTypeSure:{
                _endDate = datePickerView.selectedDate;
                [self.endBtn setTitle:datePickerView.selectedDate forState:UIControlStateNormal];
                if ([self.delegate respondsToSelector:@selector(weekPlanListFooterViewDidClickDateBtn:)]) {
                    [self.delegate weekPlanListFooterViewDidClickDateBtn:self];
                }
                [self tapCover];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - sureBtnClick
- (void)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(weekPlanListFooterViewDidClickSureBtn:)]) {
        [self.delegate weekPlanListFooterViewDidClickSureBtn:self];
    }
}

@end
