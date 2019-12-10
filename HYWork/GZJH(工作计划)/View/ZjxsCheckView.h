//
//  ZjxsCheckView.h
//  HYWork
//
//  Created by information on 16/6/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJXS.h"
@class ZjxsCheckView;

@protocol ZjxsCheckViewDelegate <NSObject>

- (void)zjxsCheckView:(ZjxsCheckView *)zjxsCheckView didClickCell:(ZJXS *)zjxs;

@end

@interface ZjxsCheckView : UIView

@property (nonatomic, copy) NSString *current;

@property (nonatomic, weak) id<ZjxsCheckViewDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame zjxs:(NSArray *)zjxs ygbm:(NSString *)ygbm ygxm:(NSString *)ygxm current:(NSString *)current;

@end
