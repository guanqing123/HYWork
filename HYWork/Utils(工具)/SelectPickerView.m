//
//  SelectPickerView.m
//  HYWork
//
//  Created by information on 16/6/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SelectPickerView.h"
#import "WKWorkTypeResult.h"

@interface SelectPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation SelectPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 60, 20)];
        sureButton.tag = 1;
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:themeColor forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [sureButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sureButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        cancelButton.tag = 0;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:themeColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [cancelButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:cancelButton];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 196)];
        pickerView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        pickerView.delegate = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        _pickerView = pickerView;
        [self addSubview:pickerView];
    }
    return self;
}

- (void)itemClick:(UIButton *)button {
    _index = [self.pickerView selectedRowInComponent:0];
    if ([self.delegate respondsToSelector:@selector(didFinishSelectPicker:buttonType:)]) {
        [self.delegate didFinishSelectPicker:self buttonType:(int)button.tag];
    }
}

- (void)sureClick {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    if (row < [_dataArry count]) {
        _key = [_dataArry objectAtIndex:row];
    }
//    if ([self.delegate respondsToSelector:@selector(selectPickerViewDidClickSureBtn:)]) {
//        [self.delegate selectPickerViewDidClickSureBtn:self];
//    }
    [self removeFromSuperview];
}

- (void)cancelClick {
    [self removeFromSuperview];
}

#pragma mark - pickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArry.count;
}

#pragma mark - pickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_dataArry objectAtIndex:row];
}

@end
