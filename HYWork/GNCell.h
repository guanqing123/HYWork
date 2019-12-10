//
//  GNCell.h
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface GNCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView  *imgView;
@property (nonatomic,weak) UILabel  *label;
@property (strong, nonatomic)  Item *item;
@end
