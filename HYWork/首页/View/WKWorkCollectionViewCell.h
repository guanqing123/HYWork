//
//  WKWorkCollectionViewCell.h
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWorkCollectionViewCell : UICollectionViewCell

/** 属性数据 */
@property (nonatomic, strong)  WKHomeWork *homeWork;

@end

NS_ASSUME_NONNULL_END
