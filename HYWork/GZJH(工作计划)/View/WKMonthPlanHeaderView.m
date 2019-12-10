//
//  WKMonthPlanHeaderView.m
//  HYWork
//
//  Created by information on 2019/9/17.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthPlanHeaderView.h"

@interface WKMonthPlanHeaderView()
@property (nonatomic, weak) UIButton *expendBtn;
@property (nonatomic, weak) UIButton *contentBtn;
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UILabel  *stateLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UIButton  *addBtn;
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation WKMonthPlanHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"wkMonthPlanHeaderView";
    WKMonthPlanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [[WKMonthPlanHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *expendBtn = [[UIButton alloc] init];
        [expendBtn addTarget:self action:@selector(expend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:expendBtn];
        self.expendBtn = expendBtn;
        
        UIButton *contentBtn = [[UIButton alloc] init];
        [contentBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:contentBtn];
        self.contentBtn = contentBtn;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        detailLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.font = [UIFont systemFontOfSize:14.0f];
        stateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        [self.contentView addSubview:stateLabel];
        self.stateLabel = stateLabel;
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:14.0f];
        dateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addBtn];
        self.addBtn = addBtn;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(192.0f, 192.0f, 192.0f);
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.dc_width;
    CGFloat parnetH = self.dc_height;
    
    CGFloat addBtnW = parnetH;
    CGFloat addBtnH = parnetH;
    CGFloat addBtnX = parentW - addBtnW;
    CGFloat addBtnY = 0.0f;
    self.addBtn.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    
    CGFloat expendBtnX = 0;
    CGFloat expendBtnY = 0;
    CGFloat expendBtnW = 30;
    CGFloat expendBtnH = parnetH;
    self.expendBtn.frame = CGRectMake(expendBtnX, expendBtnY, expendBtnW, expendBtnH);

    CGFloat contentBtnX = CGRectGetMaxX(self.expendBtn.frame);
    CGFloat contentBtnY = 0;
    CGFloat contentBtnW = addBtnX - contentBtnX;
    CGFloat contentBtnH = parnetH;
    self.contentBtn.frame = CGRectMake(contentBtnX, contentBtnY, contentBtnW, contentBtnH);
    
    CGFloat titleX = CGRectGetMaxX(self.expendBtn.frame);
    CGFloat titleY = 0;
    CGFloat titleW = (parentW - addBtnW - expendBtnW) * 0.7;
    CGFloat titleH = parnetH * 0.6;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat stateX = CGRectGetMaxX(self.titleLabel.frame);
    CGFloat stateY = titleY;
    CGFloat stateW = (parentW - addBtnW - expendBtnW) * 0.3;
    CGFloat stateH = titleH;
    self.stateLabel.frame = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGFloat detailX = CGRectGetMaxX(self.expendBtn.frame);
    CGFloat detailY = titleH;
    CGFloat detailW = titleW;
    CGFloat detailH = parnetH * 0.4;
    self.detailLabel.frame = CGRectMake(detailX, detailY, detailW, detailH);
    
    CGFloat dateX = CGRectGetMaxX(self.detailLabel.frame);
    CGFloat dateY = detailY;
    CGFloat dateW = stateW;
    CGFloat dateH = detailH;
    self.dateLabel.frame = CGRectMake(dateX, dateY, dateW, dateH);
    
    self.lineView.frame =  CGRectMake(0, parnetH - 1, parentW, 1);
}

- (void)setMonthPlan:(WKMonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    if ([monthPlan.zblx isEqualToString:@"6"]) {
        self.expendBtn.hidden = NO;
        self.addBtn.hidden = NO;
    }else{
        self.expendBtn.hidden = YES;
        self.addBtn.hidden = YES;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@", monthPlan.zbms];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@", monthPlan.hlzb];
    
    if ([monthPlan.n_state isKindOfClass:[NSNull class]]||[monthPlan.n_state length]<1) {
        self.stateLabel.text = @"";
    }else{
        self.stateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.n_state];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.yjwc];
    
    if (!monthPlan.extend) {
        [self.expendBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    } else {
        [self.expendBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    }
}


/**
 点击展开按钮
 */
- (void)expend {
    // 1.修改组模型的标记(状态取反)
    self.monthPlan.extend = !self.monthPlan.extend;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickExpend:)]) {
        [self.delegate headerViewDidClickExpend:self];
    }
}


/**
 点击查看详情
 */
- (void)detail {
    // 查看详情
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickDetail:)]) {
        [self.delegate headerViewDidClickDetail:self];
    }
}


/**
 点击添加子计划
 */
- (void)add {
    // 添加子计划
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickAdd:)]) {
        [self.delegate headerViewDidClickAdd:self];
    }
}

@end
