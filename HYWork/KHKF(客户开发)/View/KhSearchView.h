//
//  KhSearchView.h
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KhSearchView;
@protocol KhSearchViewDelegate <NSObject>
@optional
/** 点击客户查询按钮 */
- (void)khSearchViewDidSearchBpcByCondition:(KhSearchView *)khSearchView;
@end

@interface KhSearchView : UIView

@property (nonatomic, weak) id<KhSearchViewDelegate> delegate;

@property (nonatomic, copy) NSString *khmcStr;
@property (nonatomic, copy) NSString *khlxcx;

@end
