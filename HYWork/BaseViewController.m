//
//  BaseViewController.m
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingGroup.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "SettingCell.h"
#import "LoadViewController.h"
#import "AppDelegate.h"

@interface BaseViewController()<SettingCellDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建cell
    SettingCell *cell = [SettingCell cellWithTableView:tableView];
    
    //2.给cell传递模型数据
    SettingGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.delegate = self;
    
    //3.返回cell
    return cell;
}

- (void)tableViewCellRestartApp:(SettingCell *)settingCell {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"切换风格" message:@"app退出重启才能生效" preferredStyle:UIAlertControllerStyleAlert];
    
    WEAKSELF
    UIAlertAction *rightnow = [UIAlertAction actionWithTitle:@"立即退出" style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf exitApplication];
    }];
    
    UIAlertAction *cancle =  [UIAlertAction actionWithTitle:@"稍后再试" style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {}];
    [alertVc addAction:cancle];
    [alertVc addAction:rightnow];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)exitApplication {

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
     // 动画 1
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
     
}


#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    SettingGroup *group = self.data[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    
    //判断登陆
    if (item.loaded && ![LoadViewController shareInstance].isLoaded) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        loadVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loadVc animated:YES];
        return;
    }
    
    if (item.option) { // block有值(点击这个cell,有特定的操作
        item.option();
    } else if ([item isKindOfClass:[SettingArrowItem class]]) { // 箭头
        SettingArrowItem *arrowItem = (SettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
        vc.title = arrowItem.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
