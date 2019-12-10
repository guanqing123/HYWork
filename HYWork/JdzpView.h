//
//  JdzpView.h
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JdzpView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

- (void)createView:(NSString *)imgUrl titleStr:(NSString *)title;

@end
