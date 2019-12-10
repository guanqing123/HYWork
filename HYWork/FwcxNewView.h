//
//  FwcxNewView.h
//  HYWork
//
//  Created by information on 2017/11/29.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FwcxNewView;

@protocol  FwcxNewViewDelegate <NSObject>
@optional

/**
 返回哪个被点击了

 @param fwcxNewView 防伪查询View
 @param choose 当前选择
 */
- (void)fwcxNewView:(FwcxNewView *)fwcxNewView choosed:(NSInteger)choose;


/**
 点击扫一扫按钮

 @param fwcxNewView 防伪查询View
 */
- (void)fwcxNewViewDidSysItem:(FwcxNewView *)fwcxNewView;


/**
 防伪码变化更新内容

 @param fwcxNewView 防伪查询View
 @param text 防伪码
 */
- (void)fwcxNewView:(FwcxNewView *)fwcxNewView didChangeTextField:(NSString *)text;


/**
 点击认证按钮

 @param fwcxNewView 防伪查询View
 */
- (void)fwcxNewViewDidCheckItem:(FwcxNewView *)fwcxNewView;


/**
 点击重置按钮

 @param fwcxNewView 防伪查询View
 */
- (void)fwcxNewViewDidResetItem:(FwcxNewView *)fwcxNewView;

@end

@interface FwcxNewView : UIView
@property (weak, nonatomic) IBOutlet UIButton *hzhyBtn;
@property (weak, nonatomic) IBOutlet UIButton *njptBtn;
@property (weak, nonatomic) IBOutlet UITextField *fwmTextField;
- (IBAction)chooseCompany:(UIButton *)sender;
- (IBAction)sysItem;
- (IBAction)checkItem;
- (IBAction)resetItem;

+ (instancetype)fwcxView;

@property (nonatomic, weak) id<FwcxNewViewDelegate> delegate;

@end
