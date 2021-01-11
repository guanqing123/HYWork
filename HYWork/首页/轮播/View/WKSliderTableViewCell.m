//
//  WKSliderTableViewCell.m
//  HYSmartPlus
//
//  Created by information on 2018/6/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKSliderTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WKSliderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *nonTopImageView;

@property (weak, nonatomic) IBOutlet UILabel *nonTopTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nonTopTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *jingpinBtn;

@end

@implementation WKSliderTableViewCell

static NSString *WKSliderTableViewCellID = @"WKSliderTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WKSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKSliderTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WKSliderTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSliderList:(WKSliderList *)sliderList {
    _sliderList = sliderList;
    
    [self.nonTopImageView sd_setImageWithURL:[NSURL URLWithString:sliderList.imgUrl] placeholderImage:[UIImage imageNamed:@"slide_backgroud_icon"]];
    
    self.nonTopTitleLabel.text = sliderList.title;
    
    self.nonTopTimeLabel.text = sliderList.createDate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
