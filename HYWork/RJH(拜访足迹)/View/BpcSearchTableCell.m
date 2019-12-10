//
//  BpcSearchTableCell.m
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "BpcSearchTableCell.h"
#define BpcSearchTableCellLabelFont [UIFont systemFontOfSize:13]
#define BpcSearchTableCellBorderWith 0.5

@interface BpcSearchTableCell()
/** 客户代码 */
@property (nonatomic, weak) UILabel  *khdmLabel;
/** 客户名称 */
@property (nonatomic, weak) UILabel  *khmcLabel;
@end

@implementation BpcSearchTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"bpcSearchTableCell";
    BpcSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BpcSearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 客户代码
        UILabel *khdmLabel = [[UILabel alloc] init];
        khdmLabel.font = BpcSearchTableCellLabelFont;
        khdmLabel.layer.borderWidth = BpcSearchTableCellBorderWith;
        khdmLabel.textAlignment = NSTextAlignmentCenter;
        _khdmLabel = khdmLabel;
        [self.contentView addSubview:khdmLabel];
        
        // 客户名称
        UILabel *khmcLabel = [[UILabel alloc] init];
        khmcLabel.font = BpcSearchTableCellLabelFont;
        khmcLabel.layer.borderWidth = BpcSearchTableCellBorderWith;
        khmcLabel.numberOfLines = 0;
        khmcLabel.textAlignment = NSTextAlignmentCenter;
        _khmcLabel = khmcLabel;
        [self.contentView addSubview:khmcLabel];
    }
    return self;
}

- (void)setBpc:(RjhBPC *)bpc {
    _bpc = bpc;
    
    //客户代码
    self.khdmLabel.text = bpc.khdm;
    
    //客户名称
    self.khmcLabel.text = bpc.khmc;
}

- (void)setQzbpc:(QzBpc *)qzbpc {
    _qzbpc = qzbpc;
    
    //客户代码
    self.khdmLabel.text = [NSString stringWithFormat:@"%@", qzbpc.xh];
    
    //客户名称
    self.khmcLabel.text = qzbpc.mc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    
    CGFloat khdmLabelX = 0;
    CGFloat khdmLabelY = 0;
    CGFloat khdmLabelW = 100;
    CGFloat khdmLabelH = parentH;
    _khdmLabel.frame = CGRectMake(khdmLabelX, khdmLabelY, khdmLabelW, khdmLabelH);
    
    CGFloat khmcLabelX = CGRectGetMaxX(_khdmLabel.frame);
    CGFloat khmcLabelY = 0;
    CGFloat khmcLabelW = parentW - khmcLabelX;
    CGFloat khmcLabelH = parentH;
    _khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
}

@end
