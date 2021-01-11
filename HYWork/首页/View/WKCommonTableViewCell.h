//
//  WKCommonTableViewCell.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"
NS_ASSUME_NONNULL_BEGIN

@interface WKCommonTableViewCell : UITableViewCell

@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *commons;

@end

NS_ASSUME_NONNULL_END
