//
//  DkHeaderView.h
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DkHeaderView : UIView

@property (strong, nonatomic)  UILabel *khdmLabel;
@property (strong, nonatomic)  UILabel *khmcLabel;
@property (strong, nonatomic)  UILabel *dkdhLabel;
@property (strong, nonatomic)  UILabel *dkddLabel;
@property (strong, nonatomic)  UILabel *hzddLabel;
@property (strong, nonatomic)  UILabel *zjrqLabel;
@property (strong, nonatomic)  UILabel *jeLabel;
@property (strong, nonatomic)  UILabel *ztLabel;
@property (strong, nonatomic)  UILabel *syhbLabel;
@property (strong, nonatomic)  UILabel *syhbbmLabel;

+ (instancetype)headerView:(CGRect)frame;

@end
