//
//  WKMultiXLTableViewCell.m
//  HYWork
//
//  Created by information on 2018/11/21.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKMultiXLTableViewCell.h"

@interface WKMultiXLTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tjz5Label;
@property (weak, nonatomic) IBOutlet UILabel *tjz5mcLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)select;

@end

@implementation WKMultiXLTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"multiTableViewCellID";
    WKMultiXLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WKMultiXLTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setTjz5:(WKTjz5 *)tjz5 {
    _tjz5 = tjz5;
    
    self.tjz5Label.text = tjz5.tjz5;
    
    self.tjz5mcLabel.text = tjz5.tjz5mc;
}

- (void)setChooseArray:(NSMutableArray *)chooseArray {
    _chooseArray = chooseArray;
    
    BOOL flag = false;
    for (WKTjz5* tjz5 in chooseArray) {
        if ([tjz5.tjz5 isEqualToString:self.tjz5.tjz5]) {
            flag = true;
            break;
        }
    }
    if (flag) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)select {
    BOOL flag = true;
    for (WKTjz5 *tjz5 in self.chooseArray) {
        if ([tjz5.tjz5 isEqualToString:self.tjz5.tjz5]) {
            [self.chooseArray removeObject:tjz5];
            flag = false;
            break;
        }
    }
    if (flag) {
        [self.chooseArray addObject:self.tjz5];
    }
    if ([self.delegate respondsToSelector:@selector(multiXlTableViewCell:)]) {
        [self.delegate multiXlTableViewCell:self];
    }
}
@end
