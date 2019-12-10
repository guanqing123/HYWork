//
//  FwcxNewView.m
//  HYWork
//
//  Created by information on 2017/11/29.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "FwcxNewView.h"
#import "MBProgressHUD+MJ.h"

@interface FwcxNewView()<UITextFieldDelegate>

@end

@implementation FwcxNewView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.fwmTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.fwmTextField.delegate = self;
}

+ (instancetype)fwcxView {
    return [[[NSBundle mainBundle] loadNibNamed:@"FwcxNewView" owner:nil options:nil] lastObject];
}

- (IBAction)chooseCompany:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 0) {
        [self.hzhyBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
        [self.njptBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    }else{
        [self.hzhyBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        [self.njptBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(fwcxNewView:choosed:)]) {
        [self.delegate fwcxNewView:self choosed:(tag + 1)];
    }
}

- (IBAction)sysItem {
    if ([self.delegate respondsToSelector:@selector(fwcxNewViewDidSysItem:)]) {
        [self.delegate fwcxNewViewDidSysItem:self];
    }
}

- (IBAction)checkItem {
    if ([self.fwmTextField.text length] < 1) {
        [MBProgressHUD showError:@"防伪码长度小于1,无法查询"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(fwcxNewViewDidCheckItem:)]) {
        [self.delegate fwcxNewViewDidCheckItem:self];
    }
}

- (IBAction)resetItem {
    [self.hzhyBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
    [self.njptBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    
    self.fwmTextField.text = @"";
    if ([self.delegate respondsToSelector:@selector(fwcxNewViewDidResetItem:)]) {
        [self.delegate fwcxNewViewDidResetItem:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(fwcxNewView:didChangeTextField:)]) {
        [self.delegate fwcxNewView:self didChangeTextField:textField.text];
    }
}

@end
