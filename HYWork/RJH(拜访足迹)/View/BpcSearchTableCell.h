//
//  BpcSearchTableCell.h
//  HYWork
//
//  Created by information on 2017/6/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhBPC.h"
#import "QzBpc.h"

@interface BpcSearchTableCell : UITableViewCell

@property (nonatomic, strong)  RjhBPC *bpc;

@property (nonatomic, strong)  QzBpc *qzbpc;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
