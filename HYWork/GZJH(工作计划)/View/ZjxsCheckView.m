//
//  ZjxsCheckView.m
//  HYWork
//
//  Created by information on 16/6/12.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ZjxsCheckView.h"
#import "ZjxsCheckCell.h"

@interface ZjxsCheckView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong)  NSArray *zjxs;
@property (nonatomic, copy) NSString *ygbm;
@property (nonatomic, copy) NSString *ygxm;

@end

@implementation ZjxsCheckView

- (instancetype)initWithFrame:(CGRect)frame zjxs:(NSArray *)zjxs ygbm:(NSString *)ygbm ygxm:(NSString *)ygxm current:(NSString *)current{
    if (self = [super initWithFrame:frame]) {
        _zjxs = zjxs;
        _ygbm = ygbm;
        _ygxm = ygxm;
        _current = current;
        // 初始化 tableView
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = self.bounds;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (void)setCurrent:(NSString *)current {
    _current = current;
    [self.tableView reloadData];
}

#pragma mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.zjxs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZjxsCheckCell *cell = [ZjxsCheckCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        ZJXS *zjxs = [[ZJXS alloc] init];
        zjxs.ygbm = self.ygbm;
        zjxs.ygxm = self.ygxm;
        if ([self.current isEqualToString:self.ygbm]) {
            zjxs.flag = true;
        }else{
            zjxs.flag = false;
        }
        cell.zjxs = zjxs;
    }else{
        ZJXS *zjxs = [self.zjxs objectAtIndex:indexPath.row];
        if ([zjxs.ygbm isEqualToString:self.current]) {
            zjxs.flag = true;
        }else{
            zjxs.flag = false;
        }
        cell.zjxs = zjxs;
    }
    return cell;
}

#pragma mark - tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *superView = [[UIView alloc] init];
        superView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32.0f);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 1, SCREEN_WIDTH - 10, 31.0f);
        titleLabel.text = @"我的直接下属";
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor lightGrayColor];
        [superView addSubview:titleLabel];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 1.0f);
        backView.backgroundColor = GQColor(195.0f, 195.0f, 195.0f);
        [superView addSubview:backView];
        
        return superView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 32.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJXS *zjxs = [[ZJXS alloc] init];
    if (indexPath.section == 0) {
        zjxs.ygbm = self.ygbm;
        zjxs.ygxm = @"我";
    }else{
        ZJXS *selectZjxs = [self.zjxs objectAtIndex:indexPath.row];
        zjxs = selectZjxs;
    }
    if ([self.delegate respondsToSelector:@selector(zjxsCheckView:didClickCell:)]) {
        [self.delegate zjxsCheckView:self didClickCell:zjxs];
    }
}

@end
