//
//  WKSecondTableViewCell.m
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKSecondTableViewCell.h"

@interface WKSecondTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation WKSecondTableViewCell

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
    
    self.dateLabel.text = kqBean.date;
    
    self.timeLabel.text = kqBean.time;
}

@end
