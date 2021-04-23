//
//  WKFouthTableViewCell.h
//  HYWork
//
//  Created by information on 2021/4/9.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKKQBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKFouthTableViewCell : UITableViewCell

@property (nonatomic, strong)  WKKQBean *kqBean;

@property (nonatomic, copy) dispatch_block_t signInBlock;

@end

NS_ASSUME_NONNULL_END
