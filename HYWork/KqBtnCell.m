//
//  KqBtnCell.m
//  HYWork
//
//  Created by information on 16/4/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqBtnCell.h"

@interface KqBtnCell()

@property (nonatomic, weak) UIButton  *kqBtn;

@end

@implementation KqBtnCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"kqBtnCell";
    KqBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KqBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *kqBtn = [[UIButton alloc] init];
        [kqBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        _kqBtn = kqBtn;
        [self.contentView addSubview:kqBtn];
    }
    return self;
}

- (void)btnClick {
    if (_btnClick && [self.delegate respondsToSelector:@selector(kqBtnCellDelegateClickToKaoQin:)]) {
        [self.delegate kqBtnCellDelegateClickToKaoQin:self];
    }
}

- (void)layoutSubviews {
    CGSize size = self.frame.size;
    self.kqBtn.frame = CGRectMake(size.width / 2 - 50, size.height / 2 - 50, 100, 100);
}

- (void)setBtnImg:(NSString *)btnImg andClick:(BOOL)click {
    _btnImg = btnImg;
    _btnClick = click;
    [self.kqBtn setImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
}

@end
