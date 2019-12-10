//
//  BxFooterView.h
//  HYWork
//
//  Created by information on 16/5/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BxFooterView;


@protocol BxFooterViewDelegate <NSObject>
@optional
- (void)footerViewSuggestBtnClick:(BxFooterView *)footerView;
@end


@interface BxFooterView : UIView <UITextFieldDelegate>

/**
 *  转发按钮
 */
@property (nonatomic, weak) UIButton  *transmitBtn;

/**
 *  提交按钮
 */
@property (nonatomic, weak) UIButton  *commitBtn;

/**
 *  退回按钮
 */
@property (nonatomic, weak) UIButton  *backBtn;

/**
 *  签字意见
 */
@property (nonatomic, weak) UITextField  *signField;

/**
 *  浏览意见
 */
@property (nonatomic, weak) UIButton  *suggestBtn;

/**
 *  判断是否正在编辑
 */
@property (nonatomic, assign, getter=isEditing) BOOL editing;

/**
 *  代理
 */
@property (nonatomic, weak) id<BxFooterViewDelegate> delegate;

@end
