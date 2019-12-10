//
//  WKClassifyChooseView.m
//  HYWork
//
//  Created by information on 2018/6/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKClassifyChooseView.h"
#import "WKClassifyChooseTableViewCell.h"

@interface WKClassifyChooseView()<UITableViewDataSource,UITableViewDelegate>


@end

static  CGFloat  const  WKTopViewHeight = 40; //顶部视图的高度

@implementation WKClassifyChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
//        [self setupData];
    }
    return self;
}

- (void)setupUI {
    // 1.标题栏
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, self.dc_width, WKTopViewHeight);
    [self addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择分类";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.dc_centerY = topView.dc_height * 0.5;
    titleLabel.dc_centerX = topView.dc_width * 0.5;
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.dc_height - 1 / [UIScreen mainScreen].scale, self.dc_width, 1 / [UIScreen mainScreen].scale)];
    firstLine.backgroundColor = GQColor(222, 222, 222);
    [topView addSubview: firstLine];
    firstLine.dc_y = topView.dc_height - firstLine.dc_height;
    topView.backgroundColor = [UIColor whiteColor];

    [self addTableView];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, WKTopViewHeight, SCREEN_WIDTH, self.dc_height - WKTopViewHeight);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    [self addSubview:tableView];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKClassifyChooseTableViewCell *cell = [WKClassifyChooseTableViewCell cellWithTableView:tableView];
    NSArray *array = [NSArray arrayWithObjects:@"已准入客户",@"待准入客户", nil];
    cell.title = [array objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray arrayWithObjects:@"已准入客户",@"待准入客户", nil];
    self.fl = [array objectAtIndex:indexPath.row];
    self.code = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    if (self.chooseFinish) {
        self.chooseFinish();
    }
}

@end
