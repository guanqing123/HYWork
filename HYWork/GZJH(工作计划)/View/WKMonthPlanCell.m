//
//  WKMonthPlanCell.m
//  HYWork
//
//  Created by information on 2019/8/22.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthPlanCell.h"
#import "InsetsLabel.h"
#import "LoadViewController.h"

@interface WKMonthPlanCell()
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UILabel  *stateLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UIImageView  *imgView;
@property (nonatomic, weak) UIView   *lineView;
@end

@implementation WKMonthPlanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"wkMonthPlanCell";
    WKMonthPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WKMonthPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InsetsLabel *titleLabel = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        _titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        InsetsLabel *detailLabel = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        detailLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
        
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _stateLabel = stateLabel;
        [self.contentView addSubview:stateLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = GQColor(162.0f, 162.0f, 162.0f);
        _dateLabel = dateLabel;
        [self.contentView addSubview:dateLabel];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView = imgView;
        [self.contentView addSubview:imgView];
        
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
    _imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = (width - imgW - padding) * 0.7 - titleX;
    CGFloat titleH = height * 0.6;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat stateX = CGRectGetMaxX(_titleLabel.frame);
    CGFloat stateY = titleY;
    CGFloat stateW = (width - imgW - padding) * 0.3;
    CGFloat stateH = titleH;
    _stateLabel.frame = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGFloat detailX = 0;
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

- (void)setMonthPlan:(MonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", monthPlan.hlzb];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@", monthPlan.xdfa];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    
    if ([monthPlan.n_state isKindOfClass:[NSNull class]]||[monthPlan.n_state length]<1) {
        self.stateLabel.text = @"";
    }else{
        self.stateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.n_state];
    }
    self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", monthPlan.yjwc];
    self.dateLabel.font = [UIFont systemFontOfSize:14.0f];
    
    self.imgView.image = [UIImage imageNamed:@"check_mark"];
}

- (void)setWkMonthPlan:(WKMonthPlan *)wkMonthPlan {
    _wkMonthPlan = wkMonthPlan;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.zbms];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.hlzb];
    self.detailLabel.font = [UIFont systemFontOfSize:12.0f];
    
    if ([wkMonthPlan.n_state isKindOfClass:[NSNull class]]||[wkMonthPlan.n_state length]<1) {
        self.stateLabel.text = @"";
    }else{
        self.stateLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.n_state];
    }
    self.stateLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", wkMonthPlan.yjwc];
    self.dateLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.imgView.image = [UIImage imageNamed:@"check_mark"];
}

+ (CGFloat)getCellHeight {
    return 55.0f;
}

+ (CGFloat)getLdCellHeight {
    return 44.0f;
}
@end
