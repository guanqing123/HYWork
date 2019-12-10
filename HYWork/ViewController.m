//
//  ViewController.m
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "ViewController.h"
#import "CygnTableCell.h"
#import "DtManager.h"
#import "RequestData.h"
#import "DtCellModel.h"
#import "DtViewCell.h"
#import "DtFooterCell.h"
#import "ScrollViewManager.h"
#import "ScrollViewModel.h"
#import "LoadViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "Item.h"
#import "Group.h"

#import "YYAnimationIndicator.h"
#import "WKJCFXViewController.h"

#import <FineSoft/IFIntegrationUtils.h>
#import <FineSoft/IFFrameDirectoryViewController.h>
#import <FineSoft/IFEntryNode.h>
#import <FineSoft/IFEntryViewController.h>
#import <FineSoft/IFOEMUtils.h>
#import <FineSoft/IFFrameDirectoryRootViewController.h>
#import <FineSoft/IFFrameAppSettingViewController.h>

@interface ViewController ()<CygnTableCellDelegate,addItemControllerDelegate,ScrollViewDelegate>
{
     IFFrameDirectoryViewController *directoryVC;
     YYAnimationIndicator *indicator;
}
@property (strong, nonatomic)  UITableView *tableView;
/**
 *  公司动态
 */
@property (strong, nonatomic)  NSMutableArray *dtArray;
/**
 *  常用功能
 */
@property (strong, nonatomic)  NSMutableArray *cyArray;

/**
 *  图片数组
 */
@property (nonatomic, strong)  NSMutableArray *imgArry;

/**
 *  图片对象数组
 */
@property (nonatomic, strong)  NSMutableArray *scrollViewArry;

/**
 *  常用功能
 */
@property (nonatomic, strong)  NSMutableArray *gns;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIView];
    
    [self initData];
    
    [self initCygn];
    
    indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:indicator];
    self.navigationItem.leftBarButtonItem = loadingItem;
}


/**
 *  初始化界面
 */
- (void)initUIView{
    //self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - HWBottomTabH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(ios 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_tableView];

    _scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 3)];
    _scrollView.delegate = self;
    [self getImgArray];
    _tableView.tableHeaderView = _scrollView;
}

/**
 *  获取轮播图片
 */
- (void)getImgArray {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    [ScrollViewManager postJSONWithUrl:url Success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *dict = [json objectForKey:@"data"];
            NSMutableArray *scrollViewArry = [ScrollViewModelList getModelList:dict];
            _scrollViewArry = scrollViewArry;
            NSMutableArray *imgArry = [[NSMutableArray alloc] init];
            for (int i = 0; i < scrollViewArry.count; i++) {
                ScrollViewModel *model = [scrollViewArry objectAtIndex:i];
                [imgArry addObject:model.imgUrl];
            }
            _imgArry = imgArry;
            [_scrollView scrollViewCreated:imgArry];
        }
    } Fail:^{
        
    }];
}

- (void)scrollViewImgClick:(NSInteger)index {
    if (_imgArry.count == 1) {
        index = 0;
    } else if (_imgArry.count == 2) {
        if (index > 1) {
            index = index - 2;
        }
    }
    
    ScrollViewModel *model = [_scrollViewArry objectAtIndex:index];
    
    _imgDetailController = [[ImageDetailController alloc] initWithImgUrl:model.content];
    _imgDetailController.view.backgroundColor = [UIColor whiteColor];
    _imgDetailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_imgDetailController animated:YES];
}

/**
 *  初始化数据
 */
- (void)initData {
    [MBProgressHUD showMessage:@"加载中..."];
    _dtArray = [[NSMutableArray alloc] init];
     NSString *url = @"http://218.75.78.166:9101/app/api";
     NSString *pageNumber = [NSString stringWithFormat:@"%d",1];
    RequestData *requestData = [RequestData requestWithDataNeedPaginate:@"true" pageNumber:pageNumber pageSize:@"5"];
    [DtManager postJSONWithUrl:url RequestData:requestData success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [MBProgressHUD hideHUD];
            NSDictionary *dict = [json objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                NSArray *array = [ModelList getModelList:dict].dataArray;
                [_dtArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    } fail:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常,请稍候再试"];
    }];
}


- (NSArray *)gns {
    if (_gns == nil) {
        // 加载JSON的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gns" ofType:@"json"];
        
        // 加载JSON文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 将JSON数据转为NSArray或者NSDictionary
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        // 将字典转成模型
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            if ([[dict objectForKey:@"header"] isEqualToString:@"办公"]) {
                Group *group = [Group groupWithDict:dict];
                [itemArray addObject:group];
            }
        }
        _gns = itemArray;
    }
    return _gns;
}

- (void)initCygn {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if(![userDefault boolForKey:@"firstLaunch"]){
        [userDefault setBool:YES forKey:@"firstLaunch"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        Group *group = [self.gns lastObject];
        for (Item *item in group.items) {
            [dict setObject:item forKey:item.title];
        }
        NSData *new_data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [userDefault setObject:new_data forKey:@"dict"];
        [userDefault synchronize];
    }
    
    NSData *data = [userDefault objectForKey:@"dict"];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([[dict allKeys] count] > 0) {
        NSArray *tempArray = [dict allValues];
        tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Item *i1 = obj1;
            Item *i2 = obj2;
            return [i1.order compare:i2.order];
        }];
        _cyArray = [tempArray mutableCopy];
    }else {
        _cyArray = [NSMutableArray array];
    }
    Item *item = [[Item alloc] init];
    item.image = @"jiahao";
    item.title = @"添加常用";
    item.destVcClass = @"AddItemController";
    [_cyArray addObject:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goIntoNewsViewController {
    if (_dtsController == nil) {
        _dtsController = [[DtsController alloc] init];
        _dtsController.view.backgroundColor = [UIColor whiteColor];
        _dtsController.title = @"公司动态";
    }
    _dtsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_dtsController animated:YES];
}

#pragma mark - CygnTableCellDelegate
- (void)cygnTableCell:(CygnTableCell *)cygnTableCell btnDidClickWithItem:(Item *)item {
    if (item.destVcClass == nil) return;
    LoadViewController *loadController = [LoadViewController shareInstance];
    if ([item.load intValue]){
        if (loadController.isLoaded) {
            if([item.destVcClass isEqualToString:@"AppDelegate4OEM"]) {
                [self invokeFRRootVc:item emp:loadController.emp];
            }else{
                UIViewController *vc = [[NSClassFromString(item.destVcClass) alloc] init];
                vc.title = item.title;
                vc.view.backgroundColor = [UIColor whiteColor];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
           [self.navigationController pushViewController:loadController animated:YES];
        }
    }else{
        if ([item.destVcClass isEqualToString:@"AddItemController"]) {
            AddItemController *vc = [[NSClassFromString(item.destVcClass) alloc] init];
            vc.title = @"添加常用功能";
            vc.delegate = self;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIViewController *vc = [[NSClassFromString(item.destVcClass) alloc] init];
            vc.title = item.title;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - FineReport
- (void)invokeFRRootVc:(Item *)item emp:(Emp *)emp{
    
    NSString *url = emp.frdz;
    NSString *username = emp.ygbm;
    NSString *password = emp.oamm;
    
    if (@available(iOS 13.0, *)) {
        WKJCFXViewController *jcfxVc = [[WKJCFXViewController alloc] initWithUserName:username password:password];
        jcfxVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jcfxVc animated:YES];
    } else {
    
        [indicator startAnimation];  //开始转动
        
        [IFOEMUtils setShowMainMenuLeftBackButton:YES];
        
        //登录服务器
        [IFIntegrationUtils logInto:item.title serverUrl:url withUsername:username andPassword:password success:^(id content){
            //登录成功，加载目录树
            [IFIntegrationUtils loadReportTree:^(NSMutableArray *reportsArray) {
                [indicator stopAnimation];
                //加载成功，展示目录树
                directoryVC = [[IFFrameDirectoryViewController alloc] initWithReportsArray:reportsArray];
                [self.navigationController presentViewController:directoryVC animated:YES completion:nil];
            } failure:^(NSString *msg) {
                [indicator stopAnimation];
            } isObj:NO];
        } failure:^(NSString *msg) {
            [indicator stopAnimation];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
    }
}

#pragma mark - addItemController delegate
- (void)addItemControllerDidFinishChoose:(AddItemController *)addItemController {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"dict"];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    /*if ([[dict allKeys] count] > 0) {
        _cyArray = [[dict allValues] mutableCopy];
    }else {
        _cyArray = [NSMutableArray array];
    }*/
    if ([[dict allKeys] count] > 0) {
        NSArray *tempArray = [dict allValues];
        tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Item *i1 = obj1;
            Item *i2 = obj2;
            return [i1.order compare:i2.order];
        }];
        _cyArray = [tempArray mutableCopy];
    }else {
        _cyArray = [NSMutableArray array];
    }
    
    Item *item = [[Item alloc] init];
    item.image = @"jiahao";
    item.title = @"添加常用";
    item.destVcClass = @"AddItemController";
    [_cyArray addObject:item];
    [self.tableView reloadData];
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

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return _dtArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CygnTableCell *cell = [CygnTableCell cellWithTableView:tableView];
        cell.dataArray = _cyArray;
        cell.delegate = self;
        return cell;
    }else{
        if (indexPath.row < _dtArray.count){
            DtViewCell *cell = [DtViewCell cellWithTableView:tableView];
            cell.dtCellModel = [_dtArray objectAtIndex:indexPath.row];
            return cell;
        }else{
            DtFooterCell *cell = [DtFooterCell cellWithTableView:tableView];
            return cell;
        }
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (1 + ( _cyArray.count - 1 ) / 4) * 75.0f;
    }else{
        if (indexPath.row < _dtArray.count) {
            return 80.0f;
        }else{
            return 44.0f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 40.0f;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *supView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    supView.backgroundColor = [UIColor whiteColor];

    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    subView1.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
    [supView addSubview:subView1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    label.text = @"公司动态";
    label.textColor = [UIColor blackColor];
    [supView addSubview:label];
    
    UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    subView2.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [supView addSubview:subView2];
    
    UIView *subView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    subView3.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [supView addSubview:subView3];
    return supView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    //不加此句时,在二级栏目点击返回时，此行会由选中状态慢慢变成非选中状态;加上此句,返回时直接就是非选中状态。
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < _dtArray.count) {
        DtCellModel *model = [_dtArray objectAtIndex:indexPath.row];
        if (_dtDetailController != nil) {
            _dtDetailController = nil;
        }
        if (_dtDetailController == nil) {
            _dtDetailController = [[DtDetailController alloc] initWithTitle:model.title time:model.time content:model.content imgeUrl:model.imgUrl idStr:model.idStr];
            _dtDetailController.view.backgroundColor = [UIColor whiteColor];
        }
        _dtDetailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_dtDetailController animated:YES];
    } else {
        [self goIntoNewsViewController];
    }
}

@end
