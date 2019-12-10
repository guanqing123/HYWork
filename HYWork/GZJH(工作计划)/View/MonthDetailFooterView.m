//
//  MonthDetailFooterView.m
//  HYWork
//
//  Created by information on 16/6/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//
#import "MonthDetailFooterView.h"

@interface MonthDetailFooterView() <UIAlertViewDelegate>

@property (nonatomic, weak) UIButton  *deleteBtn;
@property (nonatomic, weak) UIButton  *saveBtn;
@property (nonatomic, weak) UIButton  *cancelBtn;

@end

@implementation MonthDetailFooterView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView {
    static  NSString *ID = @"monthDetailFooterView";
    MonthDetailFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footerView == nil) {
        footerView = [[MonthDetailFooterView alloc] initWithReuseIdentifier:ID];
    }
    return footerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        CGFloat deleteBtnX = 0.0f;
        CGFloat deleteBtnY = 0.0f;
        CGFloat deleteBtnW = SCREEN_WIDTH / 3;
        CGFloat deleteBtnH = 45.0f;
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.frame = CGRectMake(deleteBtnX, deleteBtnY, deleteBtnW, deleteBtnH);
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn = deleteBtn;
        [self.contentView addSubview:deleteBtn];
        
        UIButton *saveBtn = [[UIButton alloc] init];
        saveBtn.frame = CGRectMake(CGRectGetMaxX(deleteBtn.frame), deleteBtnY, deleteBtnW, deleteBtnH);
        [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = saveBtn;
        [self.contentView addSubview:saveBtn];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        CGFloat cancelBtnX = CGRectGetMaxX(saveBtn.frame);
        CGFloat cancelBtnW = SCREEN_WIDTH - cancelBtnX;
        cancelBtn.frame = CGRectMake(cancelBtnX, deleteBtnY, cancelBtnW, deleteBtnH);
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = cancelBtn;
        [self.contentView addSubview:cancelBtn];
    }
    return self;
}


- (void)setMonthPlan:(MonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    // 1.删除按钮
    if (![monthPlan.state intValue] && monthPlan.xh) {
        [self setBtn:self.deleteBtn title:@"删除" titleColor:themeColor userInteractionEnabled:YES];
    }else{
        [self setBtn:self.deleteBtn title:@"删除" titleColor:[UIColor grayColor] userInteractionEnabled:NO];
    }
    
    // 2.保存
    [self setBtn:self.saveBtn title:@"保存" titleColor:themeColor userInteractionEnabled:YES];
    /*
    if (![monthPlan.state intValue]) {
        [self setBtn:self.saveBtn title:@"保存" titleColor:themeColor userInteractionEnabled:YES];
    }else{
        [self setBtn:self.saveBtn title:@"保存" titleColor:[UIColor grayColor] userInteractionEnabled:NO];
    }*/
    
    // 3.提交/取消提交
    switch ([monthPlan.state intValue]) {
        case 0:
            [self setBtn:self.cancelBtn title:@"保存且提交" titleColor:themeColor userInteractionEnabled:YES];
            break;
        case 1:
            [self setBtn:self.cancelBtn title:@"取消提交" titleColor:themeColor userInteractionEnabled:YES];
            break;
        default:
            [self setBtn:self.cancelBtn title:@"取消提交" titleColor:[UIColor grayColor] userInteractionEnabled:NO];
            break;
    }
}

/**
 *  设置按钮的状态
 *
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @param userInter  是否可点击
 */
- (void)setBtn:(UIButton *)button title:(NSString *)title titleColor:(UIColor *)titleColor userInteractionEnabled:(BOOL)userInter {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.userInteractionEnabled = userInter;
}

/**
 *  删除
 *
 *  @param addBtn 删除按钮
 */
- (void)deleteBtnClick:(UIButton *)delBtn {
    if ([self.delegate respondsToSelector:@selector(monthDetailFooterViewDidClickDeleteBtn:)]) {
        [self.delegate monthDetailFooterViewDidClickDeleteBtn:self];
    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除该计划" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.delegate = self;
//    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        if ([self.delegate respondsToSelector:@selector(monthDetailFooterViewDidClickDeleteBtn:)]) {
            [self.delegate monthDetailFooterViewDidClickDeleteBtn:self];
        }
    }
}

/**
 *  保存
 *
 *  @param addBtn 保存按钮
 */
- (void)saveBtnClick:(UIButton *)addBtn {
    if ([self.delegate respondsToSelector:@selector(monthDetailFooterViewDidClickSaveBtn:)]) {
        [self.delegate monthDetailFooterViewDidClickSaveBtn:self];
    }
}

/**
 *  提交/取消提交
 *
 *  @param cancelBtn 提交/取消提交按钮
 */
- (void)cancelBtnClick:(UIButton *)cancelBtn {
    if ([self.delegate respondsToSelector:@selector(monthDetailFooterViewDidClickCancelBtn:)]) {
        [self.delegate monthDetailFooterViewDidClickCancelBtn:self];
    }
}

@end
