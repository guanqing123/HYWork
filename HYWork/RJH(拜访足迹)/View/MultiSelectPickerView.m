//
//  MultiSelectPickerView.m
//  HYWork
//
//  Created by information on 2018/11/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "MultiSelectPickerView.h"
#import "WKMultiTableViewCell.h"

@interface MultiSelectPickerView ()<UITableViewDataSource,UITableViewDelegate,WKMultiTableViewCellDelegate>
@property (nonatomic, weak) UITableView  *tableView;
@end

@implementation MultiSelectPickerView

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
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (void)itemClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didFinishMultiSelectPicker:buttonType:)]) {
        [self.delegate didFinishMultiSelectPicker:self buttonType:(int)button.tag];
    }
}

- (void)setChooseArray:(NSMutableArray *)chooseArray {
    _chooseArray = chooseArray;
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKMultiTableViewCell *cell = [WKMultiTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    
    WKWork *work = self.workArray[indexPath.row];
    cell.work = work;
    cell.chooseArray = self.chooseArray;
    
    return cell;
}

#pragma mark - WKMultiTableViewCellDelegate
- (void)multiTableViewCell:(WKMultiTableViewCell *)tableViewCell {
    [self.tableView reloadData];
}

@end
