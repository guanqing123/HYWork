//
//  WKSliderHeaderView.h
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomeSlider.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^sliderClick) (WKHomeSlider *slider);

@interface WKSliderHeaderView : UIView

@property (nonatomic, copy) sliderClick sliderClickBlock;

+ (instancetype)headerView;

@end

NS_ASSUME_NONNULL_END
