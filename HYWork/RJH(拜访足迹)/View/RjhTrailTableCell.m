//
//  RjhTrailTableCell.m
//  HYWork
//
//  Created by information on 2017/7/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhTrailTableCell.h"

@interface RjhTrailTableCell()
@property (nonatomic, weak) UIImageView  *leftImageView;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UILabel  *signInDateLabel;
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation RjhTrailTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"rjhTrailTableCell";
    RjhTrailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RjhTrailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:@"leftimage"];
        _leftImageView = leftImageView;
        [self.contentView addSubview:leftImageView];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:16.0f];
        _detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
        
        UILabel *signInDateLabel = [[UILabel alloc] init];
        signInDateLabel.textAlignment = NSTextAlignmentRight;
        signInDateLabel.font = [UIFont systemFontOfSize:12.0f];
        signInDateLabel.textColor = GQColor(110, 110, 110);
        _signInDateLabel = signInDateLabel;
        [self.contentView addSubview:signInDateLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(229, 229, 229);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setTrail:(RjhTrail *)trail {
    _trail = trail;
    
    self.detailLabel.text = trail.signin;
    
    self.signInDateLabel.text = trail.signin_time;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    CGFloat marginX = 10;
    
    CGFloat leftImageViewX = 0;
    CGFloat leftImageViewY = 0;
    CGFloat leftImageViewW = parentH - 1;
    CGFloat leftImageViewH = leftImageViewW;
    self.leftImageView.frame = CGRectMake(leftImageViewX, leftImageViewY, leftImageViewW, leftImageViewH);
    
    CGFloat detailLabelX = CGRectGetMaxX(_leftImageView.frame);
    CGFloat detailLabelY = 0;
    CGFloat detailLabelW = parentW - leftImageViewW - marginX;
    CGFloat detailLabelH = 44;
    self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
    
    CGFloat signInDateLabelX = detailLabelX;
    CGFloat signInDateLabelY = CGRectGetMaxY(_detailLabel.frame);
    CGFloat signInDateLabelW = detailLabelW;
    CGFloat signInDateLabelH = parentH - detailLabelH;
    self.signInDateLabel.frame = CGRectMake(signInDateLabelX, signInDateLabelY, signInDateLabelW, signInDateLabelH);
    
    CGFloat lineViewX = 0;
    CGFloat lineViewY = parentH - 1;
    CGFloat lineViewW = parentW;
    CGFloat lineViewH = 1;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

@end
