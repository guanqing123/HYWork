//
//  KqBtnCell.h
//  HYWork
//
//  Created by information on 16/4/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KqBtnCell;

@protocol kqBtnCellDelegate <NSObject>
@optional

- (void)kqBtnCellDelegateClickToKaoQin:(KqBtnCell *)kqBtnCell;

@end

@interface KqBtnCell : UITableViewCell

@property (nonatomic, copy) NSString *btnImg;

@property (nonatomic, assign, getter=isBtnClick) BOOL btnClick;

@property (nonatomic, weak) id<kqBtnCellDelegate>  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setBtnImg:(NSString *)btnImg andClick:(BOOL)click;

@end
