//
//  QyryCell.h
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QyryModel.h"

@interface QyryCell : UITableViewCell

@property (nonatomic, strong)  QyryModel *qyryModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
