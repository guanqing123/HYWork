//
//  HistoryCell.m
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "HistoryCell.h"
#define labelFont [UIFont systemFontOfSize:13]

@interface HistoryCell()
/** 序号 */
@property (nonatomic, weak) UILabel  *orderLabel;
/** 客户代码 */
@property (nonatomic, weak) UILabel  *khdmLabel;
/** 客户名称 */
@property (nonatomic, weak) UILabel  *khmcLabel;
/** 底部横线 */
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation HistoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"historyCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /** 序号 */
        UILabel *orderLabel = [[UILabel alloc] init];
        orderLabel.textAlignment = NSTextAlignmentCenter;
        orderLabel.font = labelFont;
        _orderLabel = orderLabel;
        [self.contentView addSubview:orderLabel];
        
        /** 客户代码 */
        UILabel *khdmLabel = [[UILabel alloc] init];
        khdmLabel.textAlignment = NSTextAlignmentCenter;
        khdmLabel.font = labelFont;
        _khdmLabel = khdmLabel;
        [self.contentView addSubview:khdmLabel];
        
        /** 客户名称 */
        UILabel *khmcLabel = [[UILabel alloc] init];
        khmcLabel.textAlignment = NSTextAlignmentCenter;
        khmcLabel.font = labelFont;
        khmcLabel.numberOfLines = 0;
        _khmcLabel = khmcLabel;
        [self.contentView addSubview:khmcLabel];
        
        /** 底线 */
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(233, 233, 233);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    CGFloat lineHeight = 1;
    
    CGFloat orderLabelX = 0;
    CGFloat orderLabelY = 0;
    CGFloat orderLabelW = 30;
    CGFloat orderLabelH = parentH - lineHeight;
    _orderLabel.frame = CGRectMake(orderLabelX, orderLabelY, orderLabelW, orderLabelH);
    
    CGFloat khdmLabelX = CGRectGetMaxX(_orderLabel.frame);
    CGFloat khdmLabelY = 0;
    CGFloat khdmLabelW = 100;
    CGFloat khdmLabelH = parentH - lineHeight;
    _khdmLabel.frame = CGRectMake(khdmLabelX, khdmLabelY, khdmLabelW, khdmLabelH);
    
    CGFloat khmcLabelX = CGRectGetMaxX(_khdmLabel.frame);
    CGFloat khmcLabelY = 0;
    CGFloat khmcLabelW = parentW - khmcLabelX;
    CGFloat khmcLabelH = parentH - lineHeight;
    _khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
    
    CGFloat lineViewX = 0;
    CGFloat lineViewY = parentH - 1;
    CGFloat lineViewW = parentW;
    CGFloat lineViewH = lineHeight;
    _lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

- (void)setBpc:(RjhBPC *)bpc {
    _bpc = bpc;
    
    /** 序号 */
    self.orderLabel.text = [NSString stringWithFormat:@"%d", bpc.bpcId];
    
    /** 客户代码 */
    self.khdmLabel.text = bpc.khdm;
    
    /** 客户名称 */
    self.khmcLabel.text = bpc.khmc;
}

@end
