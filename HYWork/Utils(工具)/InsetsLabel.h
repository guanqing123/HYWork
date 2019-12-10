//
//  InsetsLabel.h
//  HYWork
//
//  Created by information on 16/3/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel

@property (nonatomic) UIEdgeInsets insets;
- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;
- (instancetype)initWithInsets:(UIEdgeInsets)insets;
@end
