//
//  XpssCell.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "XpssCell.h"
#import "UIImageView+WebCache.h"

@interface XpssCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XpssCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"XpssCell";
    XpssCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XpssCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setXpssModel:(XpssModel *)xpssModel {
    _xpssModel = xpssModel;
    
    NSURL *url = [NSURL URLWithString:xpssModel.imgUrl];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"加载"]];
    
    self.nameLabel.text = xpssModel.title;
    
    self.timeLabel.text = xpssModel.submit_date;
}

@end
