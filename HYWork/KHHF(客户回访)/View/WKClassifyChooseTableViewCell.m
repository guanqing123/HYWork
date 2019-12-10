//
//  WKClassifyChooseTableViewCell.m
//  HYWork
//
//  Created by information on 2018/6/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKClassifyChooseTableViewCell.h"

@interface WKClassifyChooseTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation WKClassifyChooseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WKClassifyChooseTableViewCellID";
    WKClassifyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WKClassifyChooseTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
