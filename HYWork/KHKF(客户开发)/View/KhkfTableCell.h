//
//  KhkfTableCell.h
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QzBpc.h"

@interface KhkfTableCell : UITableViewCell

@property (nonatomic, strong)  QzBpc *qzbpc;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
