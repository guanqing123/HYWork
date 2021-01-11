//
//  WKSliderTableViewCell.h
//  HYSmartPlus
//
//  Created by information on 2018/6/12.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKSliderList.h"

@interface WKSliderTableViewCell : UITableViewCell

@property (nonatomic, strong)  WKSliderList *sliderList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
