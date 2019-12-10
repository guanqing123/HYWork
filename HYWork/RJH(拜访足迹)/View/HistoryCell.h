//
//  HistoryCell.h
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhBPC.h"

@interface HistoryCell : UITableViewCell

@property (nonatomic, strong)  RjhBPC *bpc;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
