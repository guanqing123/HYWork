//
//  WeekPlanListCell.m
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanListCell.h"
#import "InsetsLabel.h"
#import "WeekPlan.h"

@interface WeekPlanListCell()
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UILabel  *stateLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UIButton  *imgBtn;
@property (nonatomic, weak) UIView   *lineView;
@end

@implementation WeekPlanListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WeekPlanListCell";
    WeekPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WeekPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        [imgBtn setImage:[UIImage imageNamed:@"check_mark"] forState:UIControlStateNormal];
        _imgBtn = imgBtn;
        [self.contentView addSubview:imgBtn];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(192.0f, 192.0f, 192.0f);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
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
    
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = (width - imgW - padding) * 0.7;
    CGFloat titleH = height * 0.6;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat stateX = CGRectGetMaxX(_titleLabel.frame);
    CGFloat stateY = titleY;
    CGFloat stateW = (width - imgW - padding) * 0.3;
    CGFloat stateH = titleH;
    _stateLabel.frame = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGFloat detailX = titleX;
    CGFloat detailY = titleH;
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

- (void)setWeekPlan:(WeekPlan *)weekPlan {
    _weekPlan = weekPlan;
    
    self.titleLabel.text = weekPlan.mbz;
    
    self.detailLabel.text = weekPlan.gkmb;
    
    self.stateLabel.text = [NSString stringWithFormat:@"来自 %@",weekPlan.n_fbr];
    
    self.dateLabel.text = weekPlan.yjwc;
}

+ (CGFloat)getCellHeight {
    return 55.0f;
}

@end
