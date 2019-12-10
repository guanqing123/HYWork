//
//  QyryCell.m
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "QyryCell.h"

@interface QyryCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QyryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"QyryCell";
    QyryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QyryCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setQyryModel:(QyryModel *)qyryModel {
    _qyryModel = qyryModel;
    
    self.dateLabel.text = qyryModel.data;
    
    self.titleLabel.text = qyryModel.title;
}

@end
