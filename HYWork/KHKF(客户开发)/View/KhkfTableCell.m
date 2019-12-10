//
//  KhkfTableCell.m
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "KhkfTableCell.h"
#import "CustomerLabel.h"

@interface KhkfTableCell()
/** 客户名称 */
@property (nonatomic, weak) CustomerLabel  *khmcLabel;
/** 类别名称 */
@property (nonatomic, weak) CustomerLabel  *lbmcLabel;
/** 开发状态 */
@property (nonatomic, weak) UILabel  *kfztLabel;
/** 修改日期 */
@property (nonatomic, weak) UILabel  *xgrqLabel;
/** 下划线 */
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation KhkfTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"khkfTableCell";
    KhkfTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KhkfTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CustomerLabel *khmcLabel = [[CustomerLabel alloc] init];
        khmcLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        khmcLabel.font = [UIFont systemFontOfSize:16.0f];
        //khmcLabel.backgroundColor = [UIColor yellowColor];
        _khmcLabel = khmcLabel;
        [self.contentView addSubview:khmcLabel];
        
        CustomerLabel *lbmcLabel = [[CustomerLabel alloc] init];
        lbmcLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        lbmcLabel.font = [UIFont systemFontOfSize:14.0f];
        lbmcLabel.textColor = GQColor(162, 162, 162);
        //lbmcLabel.backgroundColor = [UIColor blueColor];
        _lbmcLabel = lbmcLabel;
        [self.contentView addSubview:lbmcLabel];
        
        UILabel *kfztLabel = [[UILabel alloc] init];
        kfztLabel.font = [UIFont systemFontOfSize:13.0f];
        kfztLabel.textColor = GQColor(100, 100, 100);
        //kfztLabel.backgroundColor = [UIColor redColor];
        _kfztLabel = kfztLabel;
        [self.contentView addSubview:kfztLabel];
        
        UILabel *xgrqLabel = [[UILabel alloc] init];
        xgrqLabel.font = [UIFont systemFontOfSize:13.0f];
        xgrqLabel.textColor = GQColor(162, 162, 162);
        xgrqLabel.textAlignment = NSTextAlignmentRight;
        //xgrqLabel.backgroundColor = [UIColor purpleColor];
        _xgrqLabel = xgrqLabel;
        [self.contentView addSubview:xgrqLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(222, 222, 222);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width - 34;
    CGFloat customerW = 132;
    
    CGFloat khmcLabelX = 0;
    CGFloat khmcLabelY = 0;
    CGFloat khmcLabelW = parentW - customerW/2;
    CGFloat khmcLabelH = 36;
    self.khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
    
    CGFloat lbmcLabelX = 0;
    CGFloat lbmcLabelY = CGRectGetMaxY(_khmcLabel.frame);
    CGFloat lbmcLabelW = parentW - customerW;
    CGFloat lbmcLabelH = 23;
    self.lbmcLabel.frame = CGRectMake(lbmcLabelX, lbmcLabelY, lbmcLabelW, lbmcLabelH);
    
    CGFloat kfztLabelX = CGRectGetMaxX(_khmcLabel.frame);
    CGFloat kfztLabelY = 0;
    CGFloat kfztLabelW = customerW/2;
    CGFloat kfztLabelH = 36;
    self.kfztLabel.frame = CGRectMake(kfztLabelX, kfztLabelY, kfztLabelW, kfztLabelH);
    
    CGFloat xgrqLabelX = CGRectGetMaxX(_lbmcLabel.frame);
    CGFloat xgrqLabelY = CGRectGetMaxY(_kfztLabel.frame);
    CGFloat xgrqLabelW = customerW;
    CGFloat xgrqLabelH = lbmcLabelH;
    self.xgrqLabel.frame = CGRectMake(xgrqLabelX, xgrqLabelY, xgrqLabelW, xgrqLabelH);
    
    CGFloat lineViewX = 0;
    CGFloat lineViewY = CGRectGetMaxY(_lbmcLabel.frame);
    CGFloat lineViewW = parentW + 34;
    CGFloat lineViewH = 1;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

- (void)setQzbpc:(QzBpc *)qzbpc {
    _qzbpc = qzbpc;
    /** 客户名称 */
    self.khmcLabel.text = qzbpc.mc;
    /** 客户类别名称 */
    self.lbmcLabel.text = qzbpc.lbmc;
    /** 开发状态 */
    self.kfztLabel.text = qzbpc.kfzt;
    /** 修改日期 */
    self.xgrqLabel.text = qzbpc.xgrq;
}

@end
