//
//  DtViewCell.h
//  HYWork
//
//  Created by information on 16/3/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtCellModel.h"

@interface DtViewCell : UITableViewCell

@property (strong, nonatomic) DtCellModel  *dtCellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
