//
//  KqViewCell.m
//  HYWork
//
//  Created by information on 16/3/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqViewCell.h"

@interface KqViewCell()
@property (nonatomic, weak) UIImageView  *imgView;
@property (nonatomic, weak) UILabel  *dqwzLabel;
@property (nonatomic, weak) UILabel  *detailLabel;
@property (nonatomic, weak) UIButton  *updateBtn;
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation KqViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KqCell";
    KqViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KqViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.1);
    CGRect  rectangle = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"dinweidizhi"];
        _imgView = imgView;
        [self.contentView addSubview:imgView];
        
        UILabel *dqwzLabel = [[UILabel alloc] init];
        dqwzLabel.text = @"当前位置";
        dqwzLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        dqwzLabel.font = [UIFont systemFontOfSize:14];
        _dqwzLabel = dqwzLabel;
        [self.contentView addSubview:dqwzLabel];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel = detailLabel;
        detailLabel.numberOfLines = 0;
        [self.contentView addSubview:detailLabel];
        
        UIButton *updateBtn = [[UIButton alloc] init];
        [updateBtn addTarget:self action:@selector(updateLoc) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn = updateBtn;
        [self.contentView addSubview:updateBtn];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8];
        _lineView = view;
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)updateLoc {
    if (_click && [self.delegate respondsToSelector:@selector(kqViewCellBtnClickToRefreshLocation:)]) {
        [self.delegate kqViewCellBtnClickToRefreshLocation:self];
    }
}

- (void)setWz:(NSString *)wz {
    _wz = wz;
    self.detailLabel.text = wz;
}

- (void)setBtnImg:(NSString *)imgName andClick:(BOOL)click {
    _imgName = imgName;
    _click = click;
    [self.updateBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.dc_height;
    self.imgView.frame = CGRectMake(15, 5, 25, 30);
    
    self.dqwzLabel.frame = CGRectMake(40, 10, 60, 20);
    
    self.detailLabel.frame = CGRectMake(105, 0, width - 165, 40);
    
    self.updateBtn.frame = CGRectMake(width - 55, 0, 40, 40);
    
    self.lineView.frame = CGRectMake(15, 40, width - 30, 1);
    
    CGFloat mapViewX = 15;
    CGFloat mapViewY = CGRectGetMaxY(self.lineView.frame);
    CGFloat mapViewW = width - 2 * mapViewX;
    CGFloat mapViewH = height - mapViewY;
    self.mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
}

@end
