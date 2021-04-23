//
//  WKThirdTableViewCell.h
//  HYWork
//
//  Created by information on 2021/4/8.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKKQBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKThirdTableViewCell : UITableViewCell

@property (nonatomic, strong)  WKKQBean *kqBean;

@property (nonatomic, copy) dispatch_block_t updateLocBlock;

@end

NS_ASSUME_NONNULL_END
