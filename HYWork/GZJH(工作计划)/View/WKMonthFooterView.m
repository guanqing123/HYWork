//
//  WKMonthFooterView.m
//  HYWork
//
//  Created by information on 2019/8/23.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthFooterView.h"

@interface WKMonthFooterView()

@property (nonatomic, weak) UIView  *lineView;

@property (nonatomic, weak) UIButton  *addBtn;

@property (nonatomic, weak) UIView  *firstDividerLine;

@property (nonatomic, weak) UIButton  *batchCommitBtn;

@property (nonatomic, weak) UIButton  *batchBackBtn;

@property (nonatomic, weak) UIView  *secondDividerLine;

@property (nonatomic, weak) UIButton  *approveBtn;

@property (nonatomic, weak) UIView  *thirdDividerLine;

@property (nonatomic, weak) UIButton  *cancleApproveBtn;

@end

@implementation WKMonthFooterView

+ (instancetype)footerView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        _lineView = lineView;
        [self addSubview:lineView];
        
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitle:@"添加计划" forState:UIControlStateNormal];
        [addBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        _addBtn = addBtn;
        [self addSubview:addBtn];
        
        UIView *firstDividerLine = [[UIView alloc] init];
        firstDividerLine.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        _firstDividerLine = firstDividerLine;
        [self addSubview:firstDividerLine];
        
        UIButton *batchCommitBtn = [[UIButton alloc] init];
        [batchCommitBtn addTarget:self action:@selector(batchCommitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [batchCommitBtn setTitle:@"批量提交" forState:UIControlStateNormal];
        [batchCommitBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        _batchCommitBtn = batchCommitBtn;
        [self addSubview:batchCommitBtn];
        
        UIView *secondDividerLine = [[UIView alloc] init];
        secondDividerLine.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        _secondDividerLine = secondDividerLine;
        [self addSubview:secondDividerLine];
        
        UIButton *batchBackBtn = [[UIButton alloc] init];
        [batchBackBtn addTarget:self action:@selector(batchBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [batchBackBtn setTitle:@"批量撤回" forState:UIControlStateNormal];
        [batchBackBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        _batchBackBtn = batchBackBtn;
        [self addSubview:batchBackBtn];
        
        UIButton *approveBtn = [[UIButton alloc] init];
        [approveBtn addTarget:self action:@selector(approveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [approveBtn setTitle:@"批量审批" forState:UIControlStateNormal];
        [approveBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        _approveBtn = approveBtn;
        [self addSubview:approveBtn];
        
        UIView *thirdDividerLine = [[UIView alloc] init];
        thirdDividerLine.backgroundColor = GQColor(23.0f, 171.0f, 150.0f);
        _thirdDividerLine = thirdDividerLine;
        [self addSubview:thirdDividerLine];
        
        UIButton *cancleApproveBtn = [[UIButton alloc] init];
        [cancleApproveBtn addTarget:self action:@selector(cancleApproveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cancleApproveBtn setTitle:@"撤回审批" forState:UIControlStateNormal];
        [cancleApproveBtn setTitleColor:GQColor(0.0f, 157.0f, 133.0f) forState:UIControlStateNormal];
        _cancleApproveBtn = cancleApproveBtn;
        [self addSubview:cancleApproveBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, self.dc_width, 1);
    
    self.addBtn.frame = CGRectMake(0, 0, self.dc_width / 3 - 1, self.dc_height);
    
    self.firstDividerLine.frame = CGRectMake(CGRectGetMaxX(self.addBtn.frame), 15, 1, self.dc_height - 30);
    
    self.batchCommitBtn.frame = CGRectMake(CGRectGetMaxX(self.firstDividerLine.frame), 0, self.dc_width / 3, self.dc_height);
    
    self.secondDividerLine.frame = CGRectMake(CGRectGetMaxX(self.batchCommitBtn.frame), 15, 1, self.dc_height - 30);
    
    self.batchBackBtn.frame = CGRectMake(CGRectGetMaxX(self.secondDividerLine.frame), 0, self.dc_width / 3, self.dc_height);
    
    self.approveBtn.frame = CGRectMake(0, 0, self.dc_width / 2, self.dc_height);
    
    self.thirdDividerLine.frame = CGRectMake(CGRectGetMaxX(self.approveBtn.frame), 15, 1, self.dc_height - 30);
    
    self.cancleApproveBtn.frame = CGRectMake(CGRectGetMaxX(self.approveBtn.frame), 0, self.dc_width / 2, self.dc_height);
}

- (void)setLy:(int)ly {
    _ly = ly;
    switch (ly) { // 当前自己
        case 1:
            self.lineView.hidden = NO;
            self.addBtn.hidden = NO;
            self.firstDividerLine.hidden = NO;
            self.batchCommitBtn.hidden = NO;
            self.secondDividerLine.hidden = NO;
            self.batchBackBtn.hidden = NO;
            self.approveBtn.hidden = YES;
            self.thirdDividerLine.hidden = YES;
            self.cancleApproveBtn.hidden = YES;
            break;
        case 2: // 下属三级
            self.lineView.hidden = NO;
            self.addBtn.hidden = YES;
            self.firstDividerLine.hidden = YES;
            self.batchCommitBtn.hidden = YES;
            self.secondDividerLine.hidden = YES;
            self.batchBackBtn.hidden = YES;
            self.approveBtn.hidden = NO;
            self.thirdDividerLine.hidden = NO;
            self.cancleApproveBtn.hidden = NO;
            break;
        case 3: // 下属普通
            self.lineView.hidden = YES;
            self.addBtn.hidden = YES;
            self.firstDividerLine.hidden = YES;
            self.batchCommitBtn.hidden = YES;
            self.secondDividerLine.hidden = YES;
            self.batchBackBtn.hidden = YES;
            self.approveBtn.hidden = YES;
            self.thirdDividerLine.hidden = YES;
            self.cancleApproveBtn.hidden = YES;
            break;
        default:
            break;
    }
}

/**
 点击添加按钮
 */
- (void)addBtnClick {
    if ([self.delegate respondsToSelector:@selector(monthFooterView:buttonType:)]) {
        [self.delegate monthFooterView:self buttonType:WKMonthFooterViewButtonTypeAdd];
    }
}

/**
 点击批量提交按钮
 */
- (void)batchCommitBtnClick {
    if ([self.delegate respondsToSelector:@selector(monthFooterView:buttonType:)]) {
        [self.delegate monthFooterView:self buttonType:WKMonthFooterViewButtonTypeBatchCommit];
    }
}

/**
 点击批量撤回按钮
 */
- (void)batchBackBtnClick {
    if ([self.delegate respondsToSelector:@selector(monthFooterView:buttonType:)]) {
        [self.delegate monthFooterView:self buttonType:WKMonthFooterViewButtonTypeBatchBack];
    }
}

/**
 点击审批按钮
 */
- (void)approveBtnClick {
    if ([self.delegate respondsToSelector:@selector(monthFooterView:buttonType:)]) {
        [self.delegate monthFooterView:self buttonType:WKMonthFooterViewButtonTypeApprove];
    }
}

/**
 点击取消审核按钮
 */
- (void)cancleApproveBtnClick {
    if ([self.delegate respondsToSelector:@selector(monthFooterView:buttonType:)]) {
        [self.delegate monthFooterView:self buttonType:WKMonthFooterViewButtonTypeCancleApprove];
    }
}

@end
