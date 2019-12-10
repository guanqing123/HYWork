//
//  CjwtCell.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CjwtCell.h"

@interface CjwtCell()
@property (weak, nonatomic) IBOutlet UIWebView *reasonWeb;
@property (weak, nonatomic) IBOutlet UIWebView *solutionWeb;

@end

@implementation CjwtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cjwtCell";
    CjwtCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CjwtCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
    NSURL *url = [NSURL URLWithString:@"http://218.75.78.166:9101"];

    [self.reasonWeb loadHTMLString:model.reason baseURL:url];
    [self.solutionWeb loadHTMLString:model.solution baseURL:url];
    
}

@end
