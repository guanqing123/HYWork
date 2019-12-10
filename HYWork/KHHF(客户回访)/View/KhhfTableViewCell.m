//
//  KhhfTableViewCell.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "KhhfTableViewCell.h"

@interface KhhfTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *khdmLabel;

@property (weak, nonatomic) IBOutlet UILabel *khmcLabel;

@end

@implementation KhhfTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"khhfTableViewCellID";
    KhhfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KhhfTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setKh:(WKKhhf *)kh {
    _kh = kh;
    self.khdmLabel.text = kh.khdm;
    self.khmcLabel.text = kh.khmc;
}

@end
