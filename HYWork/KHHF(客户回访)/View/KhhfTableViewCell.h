//
//  KhhfTableViewCell.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKKhhf.h"

@interface KhhfTableViewCell : UITableViewCell

@property (nonatomic, strong)  WKKhhf *kh;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
