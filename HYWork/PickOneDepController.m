//
//  PickOneDepController.m
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "PickOneDepController.h"
#import "TxlManager.h"
#import "LoadViewController.h"
#import "EmpDetailController.h"
#import "SectionHeaderView.h"
#import "YLYTableViewIndexView.h"
#import "TxlCell.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"

@interface PickOneDepController () <UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexDelegate>

@property (nonatomic, strong)  NSArray *sectionArray;

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  UILabel *flotageLabel; //显示视图

@property (nonatomic, copy) NSString *gh;

@property (nonatomic, strong)  YLYTableViewIndexView *ylyView;

@end

@implementation PickOneDepController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionArray = [NSMutableArray arrayWithCapacity:1];
        self.citiesDic = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.flotageLabel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    
    [self requestOneDepData];
    
    [self initFlotageLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![_sectionArray count]) {
        [self requestOneDepData];
    }
//    NSString *ygbm = [LoadViewController shareInstance].emp.ygbm;
//    if ([_sectionArray count] < 1 || ![_gh isEqualToString:ygbm]) {
//        _gh = ygbm;
//        [self requestOneDepDataWithBlock:^{}];
//    }
}

- (NSString *)gh {
    LoadViewController *loadController = [LoadViewController shareInstance];
    return loadController.emp.ygbm;
}

- (void)requestOneDepData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"oneEmp"];
    
    if (data == nil) {
        [self requestOneDepDataWithBlock:^{}];
    } else {
        _citiesDic = [data copy];
        _sectionArray = [[_citiesDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [self.tableView reloadData];
        [self initIndexView];
    }
}

#pragma mark - 请求同部门数据
- (void)requestOneDepDataWithBlock:(void (^)())block {
    if (self.gh == nil) {
        return;
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [_ylyView removeFromSuperview];
    [TxlManager getEmpsInfoWithGh:self.gh Type:@"1" Success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *data = [json objectForKey:@"data"];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:data forKey:@"oneEmp"];
            [userDefault synchronize];
            
            _citiesDic = [data copy];
            
            _sectionArray = [[data allKeys] sortedArrayUsingSelector:@selector(compare:)];
            [self.tableView reloadData];
            
            [self initIndexView];
            
             block();
        }
       
    } Fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍候再试"];
        block();
    }];
}

#pragma mark - 初始化tableView
- (void)initTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight - HWBottomTabH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - 初始化 flotage
- (void)initFlotageLabel {
    self.flotageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64)/2, (_tableView.frame.size.height - 64) / 2, 64, 64)];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
}

#pragma mark - 初始化 右侧字母表 和 提示框
- (void)initIndexView {
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc] initWithFrame:(CGRect){SCREEN_WIDTH - 20,0,20,SCREEN_HEIGHT}];
    indexView.tableViewIndexDelegate = self;
    _ylyView = indexView;
    [self.view addSubview:indexView];
    
    CGRect tempRect = indexView.frame;
    tempRect.size.height = _sectionArray.count * 16;
    tempRect.origin.y = ((SCREEN_HEIGHT - HWTopNavH - SearchBarHeight - HWBottomTabH) - tempRect.size.height) / 2;
    indexView.frame = tempRect;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_sectionArray objectAtIndex:section];
    NSArray  *values = [_citiesDic objectForKey:key];
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TxlCell *cell = [TxlCell cellWithTableView:tableView];

    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_citiesDic valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    cell.ygxm = dict[@"ygxm"];
    cell.mobile = dict[@"mobile"];
    cell.zwsm = [NSString stringWithFormat:@"%@/%@",dict[@"bmmc"],dict[@"zwsm"]];
    
    return cell;
}

#pragma mark - tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
    headerView.text = [_sectionArray objectAtIndex:section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [SectionHeaderView getSectionHeadHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TxlCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_citiesDic valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    EmpDetailController *empDetail = [[EmpDetailController alloc] initWithGh:dict[@"ygbm"]];
    empDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:empDetail animated:YES];
}

#pragma mark - YLYTableViewIndexDelegate
- (void)tableViewIndex:(YLYTableViewIndexView *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title {
    if ([_tableView numberOfSections] > index && index > -1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.flotageLabel.text = title;
    }
}

- (void)tableViewIndexTouchesBegan:(YLYTableViewIndexView *)tableViewIndex {
    self.flotageLabel.hidden = NO;
}

- (void)tableViewIndexTouchesEnd:(YLYTableViewIndexView *)tableViewIndex {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
    self.flotageLabel.hidden = YES;
}

- (NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableViewIndex {
    return _sectionArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
