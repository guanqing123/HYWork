//
//  MonthPlanCell.m
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "MonthPlanCell.h"
#import "InsetsLabel.h"
#import "LoadViewController.h"

@interface MonthPlanCell()
@property (nonatomic, weak) UILabel  *scoreLabel;
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UILabel  *stateLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UIButton  *imgBtn;
@property (nonatomic, weak) UIView   *lineView;

/**
 *  行政职级
 */
@property (nonatomic, copy) NSString *xzzj;

@end

@implementation MonthPlanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"weekPlanCell";
    MonthPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MonthPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InsetsLabel *scoreLabel = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        scoreLabel.font = [UIFont systemFontOfSize:16.0f];
        scoreLabel.textColor = themeColor;
        _scoreLabel = scoreLabel;
        [self.contentView addSubview:scoreLabel];
        
        InsetsLabel *titleLabel = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        InsetsLabel *detailLabel = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        detailLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
        
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.font = [UIFont systemFontOfSize:14.0f];
        stateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _stateLabel = stateLabel;
        [self.contentView addSubview:stateLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [UIFont systemFontOfSize:14.0f];
        dateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _dateLabel = dateLabel;
        [self.contentView addSubview:dateLabel];
        
        UIButton *imgBtn = [[UIButton alloc] init];
        imgBtn.adjustsImageWhenHighlighted = NO;
        imgBtn.contentMode = UIViewContentModeCenter;
        [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn = imgBtn;
        [self.contentView addSubview:imgBtn];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(192.0f, 192.0f, 192.0f);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (NSString *)xzzj {
    if (_xzzj == nil) {
        _xzzj = [LoadViewController shareInstance].emp.xzzj;
    }
    return _xzzj;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat padding = 5.0f;
    
    CGFloat imgW = 20.0f;
    CGFloat imgH = height;
    CGFloat imgX = width - imgW - padding;
    CGFloat imgY = 0.0f;
    _imgBtn.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat scoreX = 0;
    CGFloat scoreY = 0;
    CGFloat scoreW = 0;
    if ([self.xzzj intValue] > 2) {
        scoreW = 0;
    }else{
        scoreW = 50;
    }
    CGFloat scoreH = height * 0.6;
    _scoreLabel.frame = CGRectMake(scoreX, scoreY, scoreW, scoreH);
    
    CGFloat titleX = CGRectGetMaxX(_scoreLabel.frame);
    CGFloat titleY = 0;
    CGFloat titleW = (width - imgW - padding) * 0.7 - titleX;
    CGFloat titleH = scoreH;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat stateX = CGRectGetMaxX(_titleLabel.frame);
    CGFloat stateY = titleY;
    CGFloat stateW = (width - imgW - padding) * 0.3;
    CGFloat stateH = titleH;
    _stateLabel.frame = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGFloat detailX = scoreX;
    CGFloat detailY = scoreH;
    CGFloat detailW = (width - imgW - padding) * 0.7;
    CGFloat detailH = height * 0.4;
    _detailLabel.frame = CGRectMake(detailX, detailY, detailW, detailH);
    
    CGFloat dateX = CGRectGetMaxX(_detailLabel.frame);
    CGFloat dateY = detailY;
    CGFloat dateW = (width - imgW - padding) * 0.3;
    CGFloat dateH = detailH;
    _dateLabel.frame = CGRectMake(dateX, dateY, dateW, dateH);
    
    _lineView.frame =  CGRectMake(0, height - 1, width, 1);
}

- (void)setWkMonthPlan:(WKMonthPlan *)wkMonthPlan {
    _wkMonthPlan = wkMonthPlan;
    
    self.titleLabel.text = wkMonthPlan.hlzb;
    
    self.detailLabel.text = wkMonthPlan.xdfa;
    
    if ([wkMonthPlan.n_state isKindOfClass:[NSNull class]]||[wkMonthPlan.n_state length]<1) {
        self.stateLabel.text = @"";
    }else{
        self.stateLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.n_state];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.yjwc];
}

- (void)setMonthPlan:(MonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    if ([monthPlan.fz isKindOfClass:[NSNull class]]) {
        self.scoreLabel.text = @"0分";
    }else{
        self.scoreLabel.text = [NSString stringWithFormat:@"%d分",[monthPlan.fz intValue]];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", monthPlan.hlzb];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@", monthPlan.xdfa];
    
    if ([monthPlan.n_state isKindOfClass:[NSNull class]]||[monthPlan.n_state length]<1) {
        self.stateLabel.text = @"";
    }else{
        self.stateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.n_state];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.yjwc];
    
    if (monthPlan.flag) {
        if (monthPlan.flag == 1) {
            [self.imgBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
        }else{
            [self.imgBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
        }
        self.imgBtn.userInteractionEnabled = YES;
    }else{
        [self.imgBtn setImage:[UIImage imageNamed:@"check_mark"] forState:UIControlStateNormal];
        self.imgBtn.userInteractionEnabled = NO;
    }
}

- (void)imgBtnClick:(UIButton *)btn {
    if (_monthPlan.flag == 1) {
        _monthPlan.flag = 2;
        [self.imgBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
    }else {
        _monthPlan.flag = 1;
        [self.imgBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(monthPlanCellDidChoose:)]) {
        [self.delegate monthPlanCellDidChoose:self];
    }
}

+ (CGFloat)getCellHeight {
    return 55.0f;
}

@end
