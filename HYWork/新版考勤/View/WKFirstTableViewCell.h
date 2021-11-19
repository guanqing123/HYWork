//
//  WKFirstTableViewCell.h
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WKKQBean.h"

typedef void (^remindKqtx)(int);

NS_ASSUME_NONNULL_BEGIN

@interface WKFirstTableViewCell : UITableViewCell

@property (nonatomic, strong)  WKKQBean *kqBean;

@property (nonatomic, copy) remindKqtx remindBlock;

@end

NS_ASSUME_NONNULL_END
