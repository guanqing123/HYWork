//
//  BpcHistoryCheckView.m
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "BpcHistoryCheckView.h"
#import "HistoryCell.h"
#import "HistoryFooterView.h"
#import "HistoryHeaderView.h"


@interface BpcHistoryCheckView()<UITableViewDataSource,UITableViewDelegate,HistoryHeaderViewDelegate,HistoryFooterViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *historyArray;
@end

@implementation BpcHistoryCheckView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (NSMutableArray *)historyArray {
    if (_historyArray == nil) {
        _historyArray = [NSMutableArray array];
    }
    [_historyArray removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"rjhBpc"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *sort = [array sortedArrayUsingComparator:^NSComparisonResult(RjhBPC *bpc1,RjhBPC *bpc2) {
        return [@(bpc1.bpcId) compare:@(bpc2.bpcId)];
    }];
    [_historyArray addObjectsFromArray:sort];
    return _historyArray;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [HistoryCell cellWithTableView:tableView];

    RjhBPC *bpc = self.historyArray[indexPath.row];
    cell.bpc = bpc;
    
    return cell;
}

#pragma mark - conditionBpc懒加载
- (RjhBPC *)conditionBpc {
    if (_conditionBpc == nil) {
        _conditionBpc = [[RjhBPC alloc] init];
    }
    return _conditionBpc;
}

#pragma mark - tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HistoryHeaderView *headerView = [HistoryHeaderView headerView];
    headerView.conditionBpc = self.conditionBpc;
    headerView.delegate = self;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 155.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HistoryFooterView *footerView = [HistoryFooterView footerView];
    footerView.delegate = self;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _conditionBpc = self.historyArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(historyCheckViewDidSelectHistoryTableCell:)]) {
        [self.delegate historyCheckViewDidSelectHistoryTableCell:self];
    }
}

#pragma mark - HistoryHeaderViewDelegate
- (void)headerView:(HistoryHeaderView *)headerView buttonType:(HistoryHeaderViewButtonType)buttonType {
    switch (buttonType) {
        case HistoryHeaderViewButtonTypeReset:{
            self.conditionBpc.khdm = @"";
            self.conditionBpc.khmc = @"";
            [self.tableView reloadData];
            break;
        }
        case HistoryHeaderViewButtonTypeSearch:{
            [self searchBpcByCondition];
            break;
        }
        default:
            break;
    }
}

/** 根据查询条件来检索产品 */
- (void)searchBpcByCondition {
    if ([self.delegate respondsToSelector:@selector(historyCheckViewDidSearchBpcByCondition:)]) {
        [self.delegate historyCheckViewDidSearchBpcByCondition:self];
    }
}

#pragma mark - HistoryFooterViewDelegate
- (void)footerViewDidReloadTableView:(HistoryFooterView *)footerView {
    [self.tableView reloadData];
}

@end
