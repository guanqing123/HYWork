//
//  WKFirstTableViewCell.m
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKFirstTableViewCell.h"

@interface WKFirstTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UISwitch *kqtxSwitch;
- (IBAction)remindMe:(id)sender;
@end

@implementation WKFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.kqtxSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setKqBean:(WKKQBean *)kqBean {
    _kqBean = kqBean;
    
    self.nameLabel.text = kqBean.loginName;
    
    [self.kqtxSwitch setOn:kqBean.kqtx animated:YES];
    
    self.signInLabel.text = [NSString stringWithFormat:@"今日您已完成签到 %d 次", kqBean.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)remindMe:(id)sender {
    !_remindBlock ? : _remindBlock(self.kqtxSwitch.on);
}
@end
