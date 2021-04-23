//
//  WKFouthTableViewCell.m
//  HYWork
//
//  Created by information on 2021/4/9.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFouthTableViewCell.h"

@interface WKFouthTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signIn;
@end

@implementation WKFouthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKqBean:(WKKQBean *)kqBean {
    _kqBean = kqBean;
    
    [self.signInBtn setImage:[UIImage imageNamed:kqBean.kqBtnStr] forState:UIControlStateNormal];
}

- (IBAction)signIn {
    if (!_kqBean.kqBtnClick) return;
    !_signInBlock ? : _signInBlock();
}
@end
