//
//  WKChooseAddressView.m
//  HYWork
//
//  Created by information on 2018/5/16.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKChooseAddressView.h"
#import "MBProgressHUD+MJ.h"
#import "WKAddressView.h"
#import "WKAddressTableViewCell.h"

#import "WKAddressTool.h"

#import "WKProvince.h"
#import "WKCity.h"
#import "WKDistrict.h"

static  CGFloat  const  WKTopViewHeight = 40; //顶部视图的高度
static  NSString *cellID = @"WKAddressTableViewCellID";

@interface WKChooseAddressView() <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) WKAddressView  *topTabbar;
@property (nonatomic,strong) NSMutableArray  *topTabbarItems;

@property (nonatomic, weak) UIView  *underLine;

@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic,strong) NSMutableArray *tableViews;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong)  NSArray *dataSource;
@property (nonatomic, strong)  NSArray *cityDataSource;
@property (nonatomic, strong)  NSArray *districtDataSource;

@end

@implementation WKChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        [self setupData];
    }
    return self;
}

- (void)setupUI {
    // 1.标题栏
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, self.dc_width, WKTopViewHeight);
    [self addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择您所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.dc_centerY = topView.dc_height * 0.5;
    titleLabel.dc_centerX = topView.dc_width * 0.5;
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:GQColor(0, 157, 133) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.centerY.equalTo(topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.dc_height - 1 / [UIScreen mainScreen].scale, self.dc_width, 1 / [UIScreen mainScreen].scale)];
    firstLine.backgroundColor = GQColor(222, 222, 222);
    [topView addSubview: firstLine];
    firstLine.dc_y = topView.dc_height - firstLine.dc_height;
    topView.backgroundColor = [UIColor whiteColor];
    
    //2.地址栏
    WKAddressView *topTabbar = [[WKAddressView alloc] init];
    topTabbar.frame = CGRectMake(0, topView.dc_height, self.dc_width, WKTopViewHeight);
    _topTabbar = topTabbar;
    topTabbar.backgroundColor = [UIColor whiteColor];
    [self addSubview:topTabbar];
    [self addTopBarItem];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, topTabbar.dc_height - 1 / [UIScreen mainScreen].scale, self.dc_width, 1 / [UIScreen mainScreen].scale)];
    secondLine.backgroundColor = GQColor(222, 222, 222);
    [topTabbar addSubview:secondLine];
    [self.topTabbar layoutIfNeeded];
    
    UIView *underLine = [[UIView alloc] init];
    underLine.dc_height = 2.0f;
    underLine.dc_y = secondLine.dc_y - underLine.dc_height;
    underLine.backgroundColor = GQColor(0, 157, 133);
    _underLine = underLine;
    [topTabbar addSubview:underLine];
    UIButton *button = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:button];
    
    //3.地址明细
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.dc_width, self.dc_height - 2 * WKTopViewHeight);
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    contentView.pagingEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    _contentView = contentView;
    [self addSubview:contentView];
    
    [self addTableView];
}

//确认
- (void)sureBtnClick {
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    for (UIButton *btn in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] || [btn.currentTitle isEqualToString:@"请选择"]) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

- (void)addTopBarItem {
    UIButton *topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:GQColor(49, 49, 49) forState:UIControlStateNormal];
    [topBarItem setTitleColor:GQColor(0, 157, 133) forState:UIControlStateSelected];
    [topBarItem sizeToFit];
    topBarItem.dc_centerY = self.topTabbar.dc_height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [self.topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.contentView) return;
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        UIButton *button = weakSelf.topTabbarItems[index];
        [weakSelf changeUnderLineFrame:button];
    }];
}

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)button {
    NSInteger index = [self.topTabbarItems indexOfObject:button];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
        [self changeUnderLineFrame:button];
    }];
}

- (NSMutableArray *)topTabbarItems {
    if (!_topTabbarItems) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton *)button {
    _selectedBtn.selected = NO;
    button.selected = YES;
    _selectedBtn = button;
    _underLine.dc_x = button.dc_x;
    _underLine.dc_width = button.dc_width;
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(self.tableViews.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.contentView.dc_height);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    tableView.rowHeight = 44;
    [tableView registerClass:[WKAddressTableViewCell class] forCellReuseIdentifier:cellID];
    [self.contentView addSubview:tableView];
    [self.tableViews addObject:tableView];
}

- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tableViews indexOfObject:tableView] == 0) {
        return self.dataSource.count;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        return self.cityDataSource.count;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        return self.districtDataSource.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 省
    if ([self.tableViews indexOfObject:tableView] == 0) {
        cell.base = self.dataSource[indexPath.row];
    // 市
    }else if ([self.tableViews indexOfObject:tableView] == 1) {
        cell.base = self.cityDataSource[indexPath.row];
    // 区
    }else if ([self.tableViews indexOfObject:tableView] == 2) {
        cell.base = self.districtDataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - tableView Delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViews indexOfObject:tableView] == 0) {
        
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        WKProvince *province = self.dataSource[indexPath.row];
        self.cityDataSource = province.sub;
        if (self.cityDataSource.count == 0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:province.name];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath *indexPath0 = [tableView indexPathForSelectedRow];
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:province.name];
            return indexPath;
        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:province.name];
            return indexPath;
        }
        //之前未选中省,第一次选择省
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:province.name];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        WKCity *city = self.cityDataSource[indexPath.row];
        self.districtDataSource = city.sub;
        NSIndexPath *indexPath0 = [tableView indexPathForSelectedRow];
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count - 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:city.name];
            return indexPath;
        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            [self scrollToNextItem:city.name];
            return indexPath;
        }
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:city.name];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        WKDistrict *district = self.districtDataSource[indexPath.row];
        [self setUpAddress:district.name];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKBase *base;
    if ([self.tableViews indexOfObject:tableView] == 0) {
        base = self.dataSource[indexPath.row];
    }else if([self.tableViews indexOfObject:tableView] == 1) {
        base = self.cityDataSource[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2) {
        base = self.districtDataSource[indexPath.row];
    }
    base.isSelected = YES;
    self.code = base.code;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKBase *base;
    if ([self.tableViews indexOfObject:tableView] == 0) {
        base = self.dataSource[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 1) {
        base = self.cityDataSource[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2) {
        base = self.districtDataSource[indexPath.row];
    }
    base.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem {
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle {
    NSInteger index = self.contentView.contentOffset.x / SCREEN_WIDTH;
    UIButton *button = self.topTabbarItems[index];
    [button setTitle:preTitle forState:UIControlStateNormal];
    [button sizeToFit];
    [self.topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * SCREEN_WIDTH, 0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + SCREEN_WIDTH, offset.y);
        [self changeUnderLineFrame:[self.topTabbar.subviews lastObject]];
    }];
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address {
    NSInteger index = self.contentView.contentOffset.x / SCREEN_WIDTH;
    UIButton *button = self.topTabbarItems[index];
    [button setTitle:address forState:UIControlStateNormal];
    [button sizeToFit];
    [self.topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:button];
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    for (UIButton *btn in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

#pragma mark - setupData
- (void)setupData {
    [MBProgressHUD showMessage:@"加载中..." toView:self.contentView];
    [WKAddressTool getAddressList:[NSDictionary dictionary] success:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.contentView];
        self.dataSource = array;
        UITableView *tableView = self.tableViews[0];
        [tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.contentView];
    }];
}

@end
