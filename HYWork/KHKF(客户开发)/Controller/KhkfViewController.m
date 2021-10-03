//
//  KhkfViewController.m
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "KhkfViewController.h"
#import "MJRefresh.h"
#import "KhSearchView.h"
#import "LoadViewController.h"
#import "KhkfManager.h"
#import "Utils.h"
#import "QzBpc.h"
#import "MJExtension.h"
#import "KhkfTableCell.h"
#import "KhkfWebViewController.h"
#import "WKZlkhViewController.h"
#import "WKGckhViewController.h"
#import "AddButton.h"
#import "MBProgressHUD+MJ.h"
#import "CustomActionSheet.h"
#import "WKQdkhViewController.h"

@interface KhkfViewController ()<UITableViewDataSource,UITableViewDelegate,KhSearchViewDelegate,KhkfWebViewControllerDelegate,CustomActionSheetDelagate,WKQdkhViewControllerDelegate>
@property (nonatomic, assign) BOOL isAppeared;

@property (nonatomic, weak)  UITableView *tableView;
@property (nonatomic, strong)  KhSearchView *khSearchView;

@property (nonatomic, assign) int page_number;

@property (nonatomic, assign) int page_size;

@property (nonatomic, copy) NSString *khmc;
@property (nonatomic, copy) NSString *khlxcx;

@property (nonatomic, strong)  NSMutableArray *qzBpcArray;

@property (nonatomic, copy) NSString *ywy;
@end

@implementation KhkfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置导航栏的内容
    [self setupNavBar];
    
    // 2.设置tableView
    [self setupTableView];
    
    // 3.初始化searchConditionView
    [self setupSearchConditionView];
    
    // 4.添加Add 加号
    [self setupAddButton];
}

#pragma mark - 设置导航栏的内容
- (void)setupNavBar {
    // 标题 & tableView后划线不显示
    self.navigationItem.title = @"客户开发";
    
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"]
       style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanxuan"]
       style:UIBarButtonItemStyleDone target:self action:@selector(shanxuan)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shanxuan {
    if (!_isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
//            _khSearchView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, 80.0f);
            self->_khSearchView.alpha = 1.0;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
//            _khSearchView.frame = CGRectMake(0, HWTopNavH - 80.0f, SCREEN_WIDTH, 80.0f);
            self->_khSearchView.alpha = 0;
        }];
    }
    _isAppeared = !_isAppeared;
}

#pragma mark - 设置tableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 36.0f;
    tableView.showsVerticalScrollIndicator = NO;
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);//iPhoneX这里是88
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    // 分页条件
    _page_size = 20;
    _page_number = 1;
}

- (NSMutableArray *)qzBpcArray {
    if (_qzBpcArray == nil) {
        _qzBpcArray = [NSMutableArray array];
    }
    return _qzBpcArray;
}

- (NSString *)ywy {
    if (_ywy == nil) {
        _ywy = [LoadViewController shareInstance].emp.ygbm;
    }
    return _ywy;
}

- (void)headerRefreshing {
    _page_number = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_size"] = @(self.page_size);
    params[@"page_number"] = @(self.page_number);
    params[@"khmc"] = self.khmc;
    params[@"lb"] = self.khlxcx;
    params[@"ywy"] = self.ywy;
    [KhkfManager getQzKhListByCondition:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            [self.qzBpcArray removeAllObjects];
            NSArray *tempArray = [QzBpc mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            [self.qzBpcArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
            int totalPage = [[data objectForKey:@"totalPage"] intValue];
            if (totalPage > 1) {
                [self setupFooterRefresh];
            }
            self->_page_number++;
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"获取客户列表失败"];
    }];
}

- (void)setupFooterRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_size"] = @(self.page_size);
    params[@"page_number"] = @(self.page_number);
    params[@"khmc"] = self.khmc;
    params[@"lb"] = self.khlxcx;
    params[@"ywy"] = self.ywy;
    [KhkfManager getQzKhListByCondition:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            NSArray *tempArray = [QzBpc mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            [self.qzBpcArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
            int totalPage = [[data objectForKey:@"totalPage"] intValue];
            self->_page_number ++;
            if (self->_page_number > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } fail:^{
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"获取客户列表失败"];
    }];
}

#pragma mark - 初始化khSearchView
/** 初始化khSearchView */
- (void)setupSearchConditionView {
    if (_khSearchView == nil) {
        _khSearchView = [[KhSearchView alloc] initWithFrame:CGRectMake(0, HWTopNavH, SCREEN_WIDTH, 124.0f)];
        _khSearchView.delegate = self;
        _isAppeared = YES;
        [self.view addSubview:_khSearchView];
    }
}

/** 初始化右下角+号按钮 */
#pragma mark - 初始化右下角+号按钮
- (void)setupAddButton {
    CGFloat  addButtonW = 60;
    CGFloat  addButtonH = 60;
    CGFloat  addButtonX = SCREEN_WIDTH - addButtonW - 15;
    CGFloat  addButtonY = SCREEN_HEIGHT - addButtonH - 15;
    AddButton *addButton = [[AddButton alloc] initWithFrame:CGRectMake(addButtonX, addButtonY, addButtonW, addButtonH)]; //把按钮设置成正方形
    addButton.backgroundColor = GQColor(222, 222, 222);
    addButton.layer.cornerRadius = addButtonW / 2; //设置按钮的拐角为宽的一半
    addButton.layer.borderWidth = 0.5; // 边框的宽
    addButton.layer.borderColor = [UIColor whiteColor].CGColor; // 边框的颜色
    addButton.layer.masksToBounds = YES; // 这个属性很重要,把超出边框的部分去除
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchDown];
    [addButton setImage:[UIImage imageNamed:@"tianjia_128"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
}

- (void)addButtonClick {
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"请选择操作" otherButtonTitles:@[@"渠道客户(分销商)",@"经销客户新增",@"战略客户新增",@"工程客户新增"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)addButtonClick1 {
    if (_isAppeared) {
        [self shanxuan];
    }
    KhkfWebViewController *webVc = [[KhkfWebViewController alloc] initWithXh:@"" ywy:self.ywy];
    webVc.view.backgroundColor = [UIColor whiteColor];
    webVc.delegate = self;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - CustomActionSheetDelagate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_isAppeared) {
        [self shanxuan];
    }
    switch (buttonIndex) {
        case 0: {//渠道客户 05
            WKQdkhViewController *qdkhVc = [[WKQdkhViewController alloc] init];
            qdkhVc.delegate = self;
            qdkhVc.bzxh = @"";
            [self.navigationController pushViewController:qdkhVc animated:YES];
            break;
        }
        case 1: {
            //经销客户 01
            KhkfWebViewController *webVc = [[KhkfWebViewController alloc] initWithXh:@"0" ywy:self.ywy];
            webVc.view.backgroundColor = [UIColor whiteColor];
            webVc.delegate = self;
            [self.navigationController pushViewController:webVc animated:YES];
            break;
        }
        case 2: {
            //战略客户 5
            WKZlkhViewController *zlkhVc = [[WKZlkhViewController alloc] initWithXh:@"0" ywy:self.ywy];
            zlkhVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:zlkhVc animated:YES];
            break;
        }
        case 3: {
            //工程客户
            WKGckhViewController *gckhVc = [[WKGckhViewController alloc] initWithXh:@"0" ywy:self.ywy];
            gckhVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:gckhVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - khSearchViewDelegate
- (void)khSearchViewDidSearchBpcByCondition:(KhSearchView *)khSearchView {
    [self shanxuan];
    self.khmc = khSearchView.khmcStr;
    self.khlxcx = khSearchView.khlxcx;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.qzBpcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KhkfTableCell *cell = [KhkfTableCell cellWithTableView:tableView];

    QzBpc *bpc = self.qzBpcArray[indexPath.row];
    cell.qzbpc = bpc;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteQzkhByXh:indexPath];
    }
}

#pragma mark - 根据xh删除cell
- (void)deleteQzkhByXh:(NSIndexPath *)indexPath{
    [MBProgressHUD showMessage:@"正在删除中..." toView:self.view];
    QzBpc *bpc = self.qzBpcArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObject:bpc.xh forKey:@"xh"];
    [KhkfManager deleteQzkhByXh:param success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"删除成功"];
        [weakSelf.tableView.mj_header beginRefreshing];
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"删除失败"];
    }];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QzBpc *bpc = self.qzBpcArray[indexPath.row];
    if ([bpc.lb isEqualToString:@"05"]) {
        //渠道客户 05
        WKQdkhViewController *qdkhVc = [[WKQdkhViewController alloc] init];
        qdkhVc.delegate = self;
        qdkhVc.bzxh = bpc.xh;
        [self.navigationController pushViewController:qdkhVc animated:YES];
    }else if([bpc.lb isEqualToString:@"01"]) {
        //经销客户 01
        KhkfWebViewController *webVc = [[KhkfWebViewController alloc] initWithXh:bpc.xh ywy:self.ywy];
        webVc.view.backgroundColor = [UIColor whiteColor];
        webVc.delegate = self;
        [self.navigationController pushViewController:webVc animated:YES];
    } else if([bpc.lb isEqualToString:@"5"]){
        //战略客户 5
        WKZlkhViewController *zlkhVc = [[WKZlkhViewController alloc] initWithXh:bpc.xh ywy:self.ywy];
        zlkhVc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:zlkhVc animated:YES];
    }
}


#pragma mark - KhkfWebViewControllerDelegate
- (void)khkfWebViewControllerDidBackItem:(KhkfWebViewController *)webVc {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - WKQdkhViewControllerDelegate
- (void)qdkhViewControllerFinishSave:(WKQdkhViewController *)qdkhVc {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
