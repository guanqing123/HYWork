//
//  WeekFooterView.m
//  HYWork
//
//  Created by information on 16/5/25.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekFooterView.h"

@interface WeekFooterView()

@property (nonatomic, weak) UIButton  *addBtn;
@property (nonatomic, weak) UIButton  *deleteBtn;
@property (nonatomic, weak) UIButton  *pauseBtn;
@property (nonatomic, weak) UIButton  *finishBtn;
@property (nonatomic, weak) UIButton  *commitBtn;

@end

@implementation WeekFooterView

+ (instancetype)footerView:(CGRect)frame ly:(NSString *)ly {
    WeekFooterView *footerView = [[WeekFooterView alloc] initWithFrame:frame ly:ly];
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame ly:(NSString *)ly {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat lineX = 0.0f;
        CGFloat lineY = 0.0f;
        CGFloat lineW = frame.size.width;
        CGFloat lineH = 1.0f;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
        [self addSubview:lineView];
        
        
        CGFloat addBtnX = 0.0f;
        CGFloat addBtnY = lineY + lineH;
        CGFloat addBtnW = lineW;
        CGFloat addBtnH = frame.size.height - lineH;
        
        UIButton *addBtn = [[UIButton alloc] init];
        addBtn.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitle:@"添加计划" forState:UIControlStateNormal];
        [addBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        addBtn.hidden = YES;
        _addBtn = addBtn;
        [self addSubview:addBtn];
        
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        
        deleteBtn.tag = WeekFooterViewButtonTypeDelete;
        [deleteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:themeColor forState:UIControlStateNormal];
        deleteBtn.hidden = YES;
        _deleteBtn = deleteBtn;
        [self addSubview:deleteBtn];
        
        UIButton *pauseBtn = [[UIButton alloc] init];
        
        pauseBtn.tag = WeekFooterViewButtonTypePause;
        [pauseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [pauseBtn setTitleColor:themeColor forState:UIControlStateNormal];
        pauseBtn.hidden = YES;
        _pauseBtn = pauseBtn;

        
        UIButton *finishBtn = [[UIButton alloc] init];
        finishBtn.tag = WeekFooterViewButtonTypeFinish;
        [finishBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [finishBtn setTitle:@"办结" forState:UIControlStateNormal];
        [finishBtn setTitleColor:themeColor forState:UIControlStateNormal];
        finishBtn.hidden = YES;
        _finishBtn = finishBtn;
        
        
        UIButton *commitBtn = [[UIButton alloc] init];
        commitBtn.tag = WeekFooterViewButtonTypeCommit;
        [commitBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:themeColor forState:UIControlStateNormal];
        commitBtn.hidden = YES;
        _commitBtn = commitBtn;
        [self addSubview:commitBtn];
        
        if ([ly isEqualToString:@"week"]) {
            [self addSubview:pauseBtn];
            [self addSubview:finishBtn];
            deleteBtn.frame = CGRectMake(0.0f, addBtnY, addBtnW * 0.25, addBtnH);
            pauseBtn.frame = CGRectMake(addBtnW * 0.25, addBtnY, addBtnW * 0.25, addBtnH);
            finishBtn.frame = CGRectMake(addBtnW * 0.5, addBtnY, addBtnW * 0.25, addBtnH);
            commitBtn.frame = CGRectMake(addBtnW * 0.75, addBtnY, addBtnW * 0.25, addBtnH);
        }else{
            deleteBtn.frame = CGRectMake(0.0f, addBtnY, addBtnW * 0.5, addBtnH);
            commitBtn.frame = CGRectMake(addBtnW * 0.5, addBtnY, addBtnW * 0.5, addBtnH);
        }
    }
    return self;
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    if (_edit) {
        _addBtn.hidden = YES;
        _deleteBtn.hidden = NO;
        _pauseBtn.hidden = NO;
        _finishBtn.hidden = NO;
        _commitBtn.hidden = NO;
    }else{
        _addBtn.hidden = NO;
        _deleteBtn.hidden = YES;
        _pauseBtn.hidden = YES;
        _finishBtn.hidden = YES;
        _commitBtn.hidden = YES;
    }
}


- (void)fillDel:(BOOL)del pause:(BOOL)pause finish:(BOOL)finish sateType:(WeekPlanStateType)stateType {
    _del = del;
    _pause = pause;
    _finish = finish;
    _stateType = stateType;
    
    /** 删除按钮 */
    if (_del) {
        [self setBtn:self.deleteBtn title:@"删除" titleColor:themeColor userInteractionEnabled:_del];
    }else{
        [self setBtn:self.deleteBtn title:@"删除" titleColor:[UIColor grayColor] userInteractionEnabled:_del];
    }
    
    /** 暂停按钮 */
    if (_pause) {
        [self setBtn:self.pauseBtn title:@"暂停" titleColor:themeColor userInteractionEnabled:_pause];
    }else{
        [self setBtn:self.pauseBtn title:@"暂停" titleColor:[UIColor grayColor] userInteractionEnabled:_pause];
    }
    
    /** 办结按钮 */
    if (_finish) {
        [self setBtn:self.finishBtn title:@"办结" titleColor:themeColor userInteractionEnabled:_finish];
    }else{
        [self setBtn:self.finishBtn title:@"办结" titleColor:[UIColor grayColor] userInteractionEnabled:_finish];
    }
    
    /** 提交/取消提交 按钮 */
    switch (stateType) {
        case WeekPlanStateTypeDefault:
            [self setBtn:self.commitBtn title:@"提交" titleColor:[UIColor grayColor] userInteractionEnabled:false];
            break;
        case WeekPlanStateTypeCommit:
            [self setBtn:self.commitBtn title:@"提交" titleColor:themeColor userInteractionEnabled:true];
            break;
        case WeekPlanStateTypeCancel:
            [self setBtn:self.commitBtn title:@"取消提交" titleColor:themeColor userInteractionEnabled:true];
            break;
        default:
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
 *  点击添加按钮
 *
 *  @param addBtn 添加按钮
 */
- (void)addBtnClick:(UIButton *)addBtn {
    if ([self.delegate respondsToSelector:@selector(weekFooterViewDidClickAddBtn:)]) {
        [self.delegate weekFooterViewDidClickAddBtn:self];
    }
}

/**
 *  点击按钮
 *
 *  @param button 被点击按钮
 */
- (void)buttonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(weekFooterView:didClickButton:)]) {
        [self.delegate weekFooterView:self didClickButton:(WeekFooterViewButtonType)button.tag];
    }
}

@end
