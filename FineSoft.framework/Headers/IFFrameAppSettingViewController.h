//
//  IFFrameAppSettingViewController.h
//  IFWidget
//
//  Created by Connery on 14/12/3.
//  Copyright (c) 2014年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//数据分析设置界面
@interface IFFrameAppSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

//新增自定义的设置条目，参数为二维数组，每一个数组对应tableView里的一个section
- (id) initWithCustomItems:(NSArray *) customItems;

@end

//设置条目
@interface IFFrameAppSettingItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasSwitch;
@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic, strong) id hintInfo;

//根据显示文字，执行函数和提示信息初始化
- (id) initWithTitle:(NSString *)title andAction:(void (^)(UITableViewCell *selectedCell))action hintInfo:(id (^)()) hintInfoT;

//根据显示文字，执行函数初始化
- (id) initWithTitle:(NSString *) title andAction:(void (^)(UITableViewCell *selectedCell)) action;

//执行事件
- (void) action:(UITableViewCell *) selectedCell;

@end
