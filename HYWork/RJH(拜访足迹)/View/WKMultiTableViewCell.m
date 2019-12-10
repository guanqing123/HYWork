//
//  WKMultiTableViewCell.m
//  HYWork
//
//  Created by information on 2018/11/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKMultiTableViewCell.h"

@interface WKMultiTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation WKMultiTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"multiTableViewCellID";
    WKMultiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WKMultiTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}
- (IBAction)select {
    if ([self.chooseArray containsObject:[NSString stringWithFormat:@"%d",self.work.jobType]]) {
        [self.chooseArray removeObject:[NSString stringWithFormat:@"%d",self.work.jobType]];
    }else{
        [self.chooseArray addObject:[NSString stringWithFormat:@"%d",self.work.jobType]];
    }
    if ([self.delegate respondsToSelector:@selector(multiTableViewCell:)]) {
        [self.delegate multiTableViewCell:self];
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

- (void)setWork:(WKWork *)work {
    _work = work;
    self.titleLabel.text = work.jobName;
}

- (void)setChooseArray:(NSMutableArray *)chooseArray {
    _chooseArray = chooseArray;
    
    if ([chooseArray containsObject:[NSString stringWithFormat:@"%d",self.work.jobType]]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
    }
}



@end
