//
//  WKMultiXLSelectPickerView.m
//  HYWork
//
//  Created by information on 2018/11/21.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKMultiXLSelectPickerView.h"
#import "WKMultiXLTableViewCell.h"
#import "KhkfManager.h"
#import "MBProgressHUD+MJ.h"

@interface WKMultiXLSelectPickerView () <UITableViewDataSource,UITextFieldDelegate,WKMultiXLTableViewCellDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, strong)  NSArray *xlArray;

@end

@implementation WKMultiXLSelectPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 60, 20)];
        sureButton.tag = 1;
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:themeColor forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [sureButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sureButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        cancelButton.tag = 0;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:themeColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [cancelButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:cancelButton];
        
        UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 196)];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.rowHeight = 44;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (void)itemClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(multiXlSelectPickerView:buttonType:)]) {
        [self.delegate multiXlSelectPickerView:self buttonType:(int)button.tag];
    }
}

- (void)setKhdm:(NSString *)khdm {
    _khdm = khdm;
    [MBProgressHUD showMessage:@"加载中..." toView:self];
    WKTJZ5Param *param = [WKTJZ5Param param:getTjz5];
    param.khdm = khdm;
    [KhkfManager getTjz5ByKhdm:param success:^(NSArray *xlArray) {
        [MBProgressHUD hideHUDForView:self];
        self.xlArray = xlArray;
        [self.tableView reloadData];
    } fail:^{
        [MBProgressHUD hideHUDForView:self];
        [MBProgressHUD showError:@"网络异常" toView:self];
    }];
}

- (void)setChooseArray:(NSMutableArray *)chooseArray {
    _chooseArray = chooseArray;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xlArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKMultiXLTableViewCell *cell = [WKMultiXLTableViewCell cellWithTableView:tableView];
    
    WKTjz5 *tjz5 = self.xlArray[indexPath.row];
    cell.tjz5 = tjz5;
    cell.chooseArray = self.chooseArray;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - WKMultiXLTableViewCellDelegate
- (void)multiXlTableViewCell:(WKMultiXLTableViewCell *)tableViewCell {
    [self.tableView reloadData];
}

@end
