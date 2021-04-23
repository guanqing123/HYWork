//
//  WKThirdTableViewCell.m
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKThirdTableViewCell.h"

@interface WKThirdTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *signInTime;
- (IBAction)updateLoc;
@end

@implementation WKThirdTableViewCell

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
    
    self.detailLabel.text = kqBean.wzStr;
    
    [self.refreshBtn setImage:[UIImage imageNamed:kqBean.refreshBtnStr] forState:UIControlStateNormal];
    
    if (kqBean.count > 0) {
        self.signInTime.text = kqBean.signInTime;
    }
}

- (IBAction)updateLoc {
    if (!self.kqBean.refreshBtnClick) return;
    !_updateLocBlock ? : _updateLocBlock();
}
@end
