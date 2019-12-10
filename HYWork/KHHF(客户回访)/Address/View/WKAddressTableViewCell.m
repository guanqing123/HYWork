//
//  WKAddressTableViewCell.m
//  HYWork
//
//  Created by information on 2018/5/17.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKAddressTableViewCell.h"

static  CGFloat  const  WKFontH = 22; //地址字体高度限制

@interface WKAddressTableViewCell()

@property (nonatomic, strong)  UILabel *addressLabel;        // 地址名称
@property (nonatomic, strong)  UIImageView *selectImageView; // 选中标志

@end

@implementation WKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加地址名称
        [self.contentView addSubview:self.addressLabel];
        // 添加选中标志
        [self.contentView addSubview:self.selectImageView];
    }
    return self;
}

- (void)setBase:(WKBase *)base {
    _base = base;
    self.addressLabel.text = base.name;
    CGSize fontSize = [self getSizeByString:base.name sizeConstraint:CGSizeMake(SCREEN_WIDTH, WKFontH) font:[UIFont systemFontOfSize:16]];
    self.addressLabel.frame = CGRectMake(20, 10, fontSize.width, WKFontH);
    self.addressLabel.textColor = base.isSelected ? GQColor(0, 157, 133) : [UIColor blackColor];
    self.selectImageView.hidden = !base.isSelected;
    self.selectImageView.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 5, 14.5, 15, 15);
}

// 传入字符串，计算大小2
- (CGSize)getSizeByString:(NSString *)string sizeConstraint:(CGSize)sizeConstraint font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:sizeConstraint
                                       options:NSStringDrawingTruncatesLastVisibleLine
                   | NSStringDrawingUsesLineFragmentOrigin
                   | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil].size;
    size.width += 8;
    return size;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.frame = CGRectMake(20, 10, 100, WKFontH);
        _addressLabel.font = [UIFont systemFontOfSize:16.0f];
        _addressLabel.textColor = [UIColor blackColor];
    }
    return _addressLabel;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"selectFlag"];
        _selectImageView.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 5, 14.5, 15, 15);
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

@end
