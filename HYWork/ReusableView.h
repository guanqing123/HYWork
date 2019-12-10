//
//  ReusableView.h
//  HYWork
//
//  Created by information on 16/3/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReusableView : UICollectionReusableView

@property (nonatomic, copy) NSString *text;

@property (nonatomic,weak) UILabel  *label;
@property (nonatomic,weak) UIView  *subView1;

- (void)initText:(NSString *)text r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
@end
