//
//  HistoryHeaderView.m
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "HistoryHeaderView.h"
#import "CustomerLabel.h"
#import "MBProgressHUD+MJ.h"

#define labelFont [UIFont systemFontOfSize:13]
#define textFont [UIFont systemFontOfSize:14]

@interface HistoryHeaderView()<UITextFieldDelegate>
@property (nonatomic, weak) CustomerLabel  *khdmLabel;
@property (nonatomic, weak) UITextField  *khdmTextField;
@property (nonatomic, weak) UIView  *khdmLineView;

@property (nonatomic, weak) CustomerLabel  *khmcLabel;
@property (nonatomic, weak) UITextField  *khmcTextField;
@property (nonatomic, weak) UIView  *khmcLineView;

@property (nonatomic, weak) UIButton  *resetBtn;
@property (nonatomic, weak) UIButton  *checkBtn;

@property (nonatomic, weak) UILabel  *historyLabel;
@property (nonatomic, weak) UIView  *historyLineView;
@end

@implementation HistoryHeaderView

+ (instancetype)headerView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        // 客户代码label
        CustomerLabel *khdmLabel = [[CustomerLabel alloc] init];
        khdmLabel.textInsets = UIEdgeInsetsMake(12, 20, 12, 0);
        khdmLabel.text = @"客户代码:";
        khdmLabel.font = labelFont;
        khdmLabel.textColor = GQColor(150, 150, 150);
        _khdmLabel = khdmLabel;
        [self addSubview:khdmLabel];
        
        // 客户代码field
        UITextField *khdmTextField = [[UITextField alloc] init];
        khdmTextField.backgroundColor = GQColor(238, 238, 238);
        khdmTextField.returnKeyType = UIReturnKeyDone;
        khdmTextField.borderStyle = UITextBorderStyleRoundedRect;
        khdmTextField.delegate = self;
        khdmTextField.tag = 0;
        khdmTextField.font = textFont;
        _khdmTextField = khdmTextField;
        [self addSubview:khdmTextField];
        
        // 底线
        UIView *khdmLineView = [[UIView alloc] init];
        khdmLineView.backgroundColor = GQColor(238, 238, 238);
        _khdmLineView = khdmLineView;
        [self addSubview:khdmLineView];
        
        // 客户名称label
        CustomerLabel *khmcLabel = [[CustomerLabel alloc] init];
        khmcLabel.textInsets = UIEdgeInsetsMake(12, 20, 12, 0);
        khmcLabel.text = @"客户名称:";
        khmcLabel.font = labelFont;
        khmcLabel.textColor = GQColor(150, 150, 150);
        _khmcLabel = khmcLabel;
        [self addSubview:khmcLabel];
        
        // 客户代码field
        UITextField *khmcTextField = [[UITextField alloc] init];
        khmcTextField.frame = CGRectMake(100, 7, SCREEN_WIDTH - 150, 30);
        khmcTextField.backgroundColor = GQColor(238, 238, 238);
        khmcTextField.returnKeyType = UIReturnKeyDone;
        khmcTextField.borderStyle = UITextBorderStyleRoundedRect;
        khmcTextField.delegate = self;
        khmcTextField.tag = 1;
        khmcTextField.font = textFont;
        _khmcTextField = khmcTextField;
        [self addSubview:khmcTextField];
        
        // 底线
        UIView *khmcLineView = [[UIView alloc] init];
        khmcLineView.backgroundColor = GQColor(238, 238, 238);
        _khmcLineView = khmcLineView;
        [self addSubview:khmcLineView];
        
        // 重置
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        resetBtn.titleLabel.font = textFont;
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetBtn.backgroundColor = GQColor(0, 157, 133);
        resetBtn.tag = HistoryHeaderViewButtonTypeReset;
        [resetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn = resetBtn;
        [self addSubview:resetBtn];
        
        // 查询
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setTitle:@"查询" forState:UIControlStateNormal];
        checkBtn.titleLabel.font = textFont;
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkBtn.backgroundColor = GQColor(0, 157, 133);
        checkBtn.tag = HistoryHeaderViewButtonTypeSearch;
        [checkBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn = checkBtn;
        [self addSubview:checkBtn];
        
        // 历史记录
        CustomerLabel *historyLabel = [[CustomerLabel alloc] init];
        historyLabel.textInsets = UIEdgeInsetsMake(0, 12, 0, 0 );
        historyLabel.text = @"历史记录";
        historyLabel.font = [UIFont boldSystemFontOfSize:15];
        historyLabel.textColor = GQColor(150, 150, 150);
        _historyLabel = historyLabel;
        [self addSubview:historyLabel];
        
        // 底线
        UIView *historyLineView = [[UIView alloc] init];
        historyLineView.backgroundColor = GQColor(238, 238, 238);
        _historyLineView = historyLineView;
        [self addSubview:historyLineView];
    }
    return self;
}

- (void)setConditionBpc:(RjhBPC *)conditionBpc {
    _conditionBpc = conditionBpc;
    
    /** 客户代码 */
    self.khdmTextField.text = conditionBpc.khdm;
    
    /** 客户名称 */
    self.khmcTextField.text = conditionBpc.khmc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    //CGFloat parentH = self.frame.size.height;
    CGFloat marginY = 7;
    CGFloat marginX = 50;
    CGFloat lineHeight = 1;
    
    /** 客户代码 */
    CGFloat khdmLabelX = 0;
    CGFloat khdmLabelY = 0;
    CGFloat khdmLabelW = 100;
    CGFloat khdmLabelH = 43;
    _khdmLabel.frame = CGRectMake(khdmLabelX, khdmLabelY, khdmLabelW, khdmLabelH);
    
    CGFloat khdmTextFieldX = CGRectGetMaxX(_khdmLabel.frame);
    CGFloat khdmTextFieldY = marginY;
    CGFloat khdmTextFieldW = parentW - khdmTextFieldX - marginX;
    CGFloat khdmTextFieldH = 30;
    _khdmTextField.frame = CGRectMake(khdmTextFieldX, khdmTextFieldY, khdmTextFieldW, khdmTextFieldH);
    
    CGFloat khdmLineViewX = 0;
    CGFloat khdmLineViewY = CGRectGetMaxY(_khdmLabel.frame);
    CGFloat khdmLineViewW = parentW;
    CGFloat khdmLineViewH = lineHeight;
    _khdmLineView.frame = CGRectMake(khdmLineViewX, khdmLineViewY, khdmLineViewW, khdmLineViewH);
    
    /** 客户名称 */
    CGFloat khmcLabelX = 0;
    CGFloat khmcLabelY = CGRectGetMaxY(_khdmLineView.frame);
    CGFloat khmcLabelW = khdmLabelW;
    CGFloat khmcLabelH = khdmLabelH;
    _khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
    
    CGFloat khmcTextFieldX = CGRectGetMaxX(_khmcLabel.frame);
    CGFloat khmcTextFieldY = CGRectGetMaxY(_khdmLineView.frame) + marginY;
    CGFloat khmcTextFieldW = parentW - khmcTextFieldX - marginX;
    CGFloat khmcTextFieldH = 30;
    _khmcTextField.frame = CGRectMake(khmcTextFieldX, khmcTextFieldY, khmcTextFieldW, khmcTextFieldH);
    
    CGFloat khmcLineViewX = 0;
    CGFloat khmcLineViewY = CGRectGetMaxY(_khmcLabel.frame);
    CGFloat khmcLineViewW = parentW;
    CGFloat khmcLineViewH = lineHeight;
    _khmcLineView.frame = CGRectMake(khmcLineViewX, khmcLineViewY, khmcLineViewW, khmcLineViewH);
    
    /** 重置 */
    CGFloat resetBtnX = 0;
    CGFloat resetBtnY = CGRectGetMaxY(_khmcLabel.frame);
    CGFloat resetBtnW = parentW/2;
    CGFloat resetBtnH = 36;
    _resetBtn.frame = CGRectMake(resetBtnX, resetBtnY, resetBtnW, resetBtnH);
    
    /** 查询 */
    CGFloat checkBtnX = CGRectGetMaxX(_resetBtn.frame);
    CGFloat checkBtnY = resetBtnY;
    CGFloat checkBtnW = resetBtnW;
    CGFloat checkBtnH = resetBtnH;
    _checkBtn.frame = CGRectMake(checkBtnX, checkBtnY, checkBtnW, checkBtnH);
    
    /** 历史查询 */
    CGFloat historyLabelX = 0;
    CGFloat historyLabelY = CGRectGetMaxY(_resetBtn.frame);
    CGFloat historyLabelW = parentW;
    CGFloat historyLabelH = 30;
    _historyLabel.frame = CGRectMake(historyLabelX, historyLabelY, historyLabelW, historyLabelH);
    
    CGFloat historyLineViewX = 0;
    CGFloat historyLineViewY = CGRectGetMaxY(_historyLabel.frame);
    CGFloat historyLineViewW = parentW;
    CGFloat historyLineViewH = 2 * lineHeight;
    _historyLineView.frame = CGRectMake(historyLineViewX, historyLineViewY, historyLineViewW, historyLineViewH);
}

#pragma mark - button click
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 1) {
        [self endEditing:YES];
        if ([_conditionBpc.khdm length] < 1 && [_conditionBpc.khmc length] < 1) {
            [MBProgressHUD showError:@"客户代码和客户名称不能同时为空"];
            return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(headerView:buttonType:)]) {
        [self.delegate headerView:self buttonType:(int)button.tag];
    }
}

#pragma mark - textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        _conditionBpc.khdm = textField.text;
    }else{
        _conditionBpc.khmc = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}
@end
