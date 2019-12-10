//
//  YLYTableViewIndexView.h
//  HYWork
//
//  Created by information on 16/4/15.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YLYTableViewIndexDelegate;

@interface YLYTableViewIndexView : UIView

@property (nonatomic, strong)  NSArray *indexes;
@property (nonatomic, weak) id<YLYTableViewIndexDelegate>  tableViewIndexDelegate;

@end

@protocol YLYTableViewIndexDelegate <NSObject>

/**
 *  触摸到索引时触发
 *
 *  @param tableViewIndex 触发didSelectSectionAtIndex对象
 *  @param index          索引下标
 *  @param title          索引文字
 */
- (void)tableViewIndex:(YLYTableViewIndexView *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)tableViewIndexTouchesBegan:(YLYTableViewIndexView *)tableViewIndex;
/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)tableViewIndexTouchesEnd:(YLYTableViewIndexView *)tableViewIndex;

/**
 *  TableView中右边右边索引title
 *
 *  @param tableViewIndex 触发tableViewIndexTitle对象
 *
 *  @return 索引title数组
 */
- (NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableViewIndex;

@end
