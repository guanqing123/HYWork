//
//  CusFunCell.h
//  HYWork
//
//  Created by information on 16/4/19.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface CusFunCell : UITableViewCell

@property (nonatomic, strong)  Item *item;

@property (nonatomic, assign, getter=isChoosed) BOOL choose;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
