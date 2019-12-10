//
//  BxFooterView.m
//  HYWork
//
//  Created by information on 16/5/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BxFooterView.h"

@implementation BxFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0f)];
        subView.backgroundColor = GQColor(222.0f, 222.0f, 223.0f);
        [self addSubview:subView];
        
        UITextField *signField = [[UITextField alloc] init];
        signField.delegate = self;
        signField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        signField.leftViewMode = UITextFieldViewModeAlways;
        signField.placeholder = @"签字意见...";
        signField.returnKeyType = UIReturnKeyDone;
        signField.borderStyle = UITextBorderStyleRoundedRect;
        //[signField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        signField.backgroundColor = [UIColor whiteColor];
        _signField = signField;
        [subView addSubview:signField];
        
        UIButton *suggestBtn = [[UIButton alloc] init];
        [suggestBtn setImage:[UIImage imageNamed:@"suggest"] forState:UIControlStateNormal];
        suggestBtn.backgroundColor = GQColor(0.0f, 146.0f, 239.0f);
        [suggestBtn.layer setCornerRadius:5.0f];
        [suggestBtn.layer setMasksToBounds:YES];
        [suggestBtn addTarget:self action:@selector(suggestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _suggestBtn = suggestBtn;
        [subView addSubview:suggestBtn];
        
        UIButton *transmitBtn = [[UIButton alloc] init];
        [transmitBtn.layer setCornerRadius:5.0f];
        [transmitBtn.layer setMasksToBounds:YES];
        [transmitBtn setTitle:@"转发" forState:UIControlStateNormal];
        transmitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        transmitBtn.backgroundColor = GQColor(0.0f, 146.0f, 239.0f);
         _transmitBtn = transmitBtn;
        [self addSubview:transmitBtn];
        
        UIButton *commitBtn = [[UIButton alloc] init];
        [commitBtn.layer setCornerRadius:5.0f];
        [commitBtn.layer setMasksToBounds:YES];
        [commitBtn setTitle:@"提交/批准" forState:UIControlStateNormal];
        commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        commitBtn.backgroundColor = GQColor(68.0f, 219.0f, 94.0f);
        _commitBtn = commitBtn;
        [self addSubview:commitBtn];
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn.layer setCornerRadius:5.0f];
        [backBtn.layer setMasksToBounds:YES];
        [backBtn setTitle:@"退回" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        backBtn.backgroundColor = GQColor(249.0f, 53.0f, 50.0f);
        _backBtn = backBtn;
        [self addSubview:backBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginX = 10;
    
    
    _signField.frame = CGRectMake(25.0f, 8.0f, SCREEN_WIDTH - 45.0f - 30.0f, 28.0f);
    
    CGFloat suggestX = CGRectGetMaxX(_signField.frame) + marginX;
    _suggestBtn.frame = CGRectMake(suggestX, 8.0f, 30.0f, 28.0f);
    
    int  columns = 3;
    CGFloat transmitBtnY = 8 + 44;
    CGFloat transmitBtnW = (SCREEN_WIDTH - ( columns * 2 ) * marginX ) / columns;
    CGFloat transmitBtnH = 28;
    
    _transmitBtn.frame = CGRectMake(marginX, transmitBtnY, transmitBtnW, transmitBtnH);
    
    CGFloat commitBtnX = CGRectGetMaxX(_transmitBtn.frame) + marginX * 2;
    
    _commitBtn.frame = CGRectMake(commitBtnX, transmitBtnY, transmitBtnW, transmitBtnH);
    
    CGFloat backBtnX = CGRectGetMaxX(_commitBtn.frame) + marginX * 2;
    
    _backBtn.frame = CGRectMake(backBtnX, transmitBtnY, transmitBtnW, transmitBtnH);
    
}


- (void)suggestBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(footerViewSuggestBtnClick:)]) {
        [self.delegate footerViewSuggestBtnClick:self];
    }
}


#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editing = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editing = NO;
}

@end
