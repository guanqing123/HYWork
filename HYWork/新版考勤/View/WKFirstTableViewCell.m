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
@end

@implementation WKFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setKqBean:(WKKQBean *)kqBean {
    _kqBean = kqBean;
    
    self.nameLabel.text = kqBean.loginName;
    
    self.signInLabel.text = [NSString stringWithFormat:@"今日您已完成签到 %d 次", kqBean.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
