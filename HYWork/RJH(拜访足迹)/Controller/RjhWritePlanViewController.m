//
//  RjhWritePlanViewController.m
//  HYWork
//
//  Created by information on 2017/5/22.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhWritePlanViewController.h"
#import "PlanWriteTableCell.h"
#import "RjhOperatorSearchViewController.h"
#import "RjhBpcSearchViewController.h"
#import "RjhManager.h"
#import "Utils.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

// 检索项目
#import "WKXmSearchViewController.h"

#import "RjhSignInTableViewController.h"
#import "KhSearchViewController.h"

#import "LoadViewController.h"

#import "RXAddressiOS9.h"
#import "RXAddressiOS10.h"

#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)

@interface RjhWritePlanViewController ()<PlanWriteTableCellDelegate,RjhBpcSearchViewControllerDelegate,RjhOperatorSearchViewControllerDelegate,KhSearchViewControllerDelegate,WKXmSearchViewControllerDelegate>
{
    RXAddressiOS9 * _objct9;
    RXAddressiOS10 * _objct10;
}
@property (nonatomic, strong)  NSArray *selectData;
@property (nonatomic, strong)  NSArray *workTypeArray;
@property (nonatomic, strong)  NSArray *workArray;
@property (nonatomic, strong)  NSArray *projectList;
@end

@implementation RjhWritePlanViewController

#pragma mark - viewLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置导航栏的内容
    [self setupNavBar];
    
    // 2.设置tableView的属性
    [self setupTableView];
    
    // 3.设置readAddress
    [self setupReadAddress];
    
    // 4.初始化数据
    [self setupData];
    
    // 5.获取工程列表
    [self loadProjectList];
}

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - 1.设置导航栏的内容
- (void)setupNavBar {
    // title
    self.navigationItem.title = @"拜访轨迹";
    
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = right;
}

// 回退
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
- (void)save {
    if ([_plan.khdm length] < 1 || [_plan.khmc length] < 1) {
        [MBProgressHUD showError:@"客户不能为空!" toView:self.view];
        return;
    }
    if ([_plan.jobtype length] < 1) {
        [MBProgressHUD showError:@"客户具体工作项不能为空!" toView:self.view];
        return;
    }
    if (_plan.leveltype == 4 && [_plan.projectid length] < 1) {
        [MBProgressHUD showError:@"工程项目不能为空!" toView:self.view];
        return;
    }
    if ([_plan.jobremark_placeholder length] > 1 && [_plan.jobremark length] < 1) {
        [MBProgressHUD showError:@"备注不能为空!" toView:self.view];
        return;
    }
    if ([_plan.title length] < 1) {
        for (WKWorkTypeResult* wk in self.selectData) {
            if (_plan.type == wk.type) {
                _plan.title = wk.typeName;
                break;
            }
        }
    }
    [MBProgressHUD showMessage:@"正在保存中..." toView:self.view];
    NSDictionary *params = [self.plan mj_keyValues];
    [RjhManager saveRjhPlanWithParameters:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD showSuccess:@"保存成功"];
            if ([self.delegate respondsToSelector:@selector(rjhWritePlanViewControllerSavePlan:)]) {
                [self.delegate rjhWritePlanViewControllerSavePlan:self];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存出错"];
    }];
}

#pragma mark - 2.设置tableView的属性
- (void)setupTableView {
    self.tableView.backgroundColor = GQColor(242, 242, 242);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - 3.设置readAddress
- (void)setupReadAddress {
    __weak typeof(self)weakSelf = self;
    
    _objct10 = [[RXAddressiOS10 alloc] init];
    _objct10.complete = ^(BOOL status, NSString * phoneNum, NSString * nameString) {
        if(status) {
            weakSelf.plan.kh_lxdh = phoneNum;
        }
        weakSelf.plan.kh_lxr = nameString;
        [weakSelf.tableView reloadData];
    };
    _objct9 = [[RXAddressiOS9 alloc] init];
    _objct9.complete = ^(BOOL status, NSString * phoneNum, NSString * nameString) {
        if(status) {
            weakSelf.plan.kh_lxdh = phoneNum;
        }
        weakSelf.plan.kh_lxr = nameString;
        [weakSelf.tableView reloadData];
    };
}

#pragma mark - 4.设置数据
- (void)setupData {
    [MBProgressHUD showMessage:@"数据加载中..." toView:self.view];
    WKWorkTypeParam *param = [WKWorkTypeParam param:workType];
    [RjhManager getWorkType:param success:^(NSArray *work) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self->_selectData = work;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败"];
    }];
}

#pragma mark - 5.加载项目
- (void)loadProjectList {
    WKProjectParam *param = [WKProjectParam param:project];
    param.userid = [LoadViewController shareInstance].emp.ygbm;
//    param.userid = @"05208";
    [RjhManager getProjectList:param success:^(NSArray *projectList) {
        self->_projectList = projectList;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^{
    }];
}

- (void)setPlan:(RjhPlan *)plan {
    _plan = plan;
}

- (void)setZjxs:(NSArray *)zjxs {
    _zjxs = zjxs;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 13;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanWriteTableCell *cell = [PlanWriteTableCell cellWithTable:tableView indexPath:indexPath];
    cell.delegate = self;
    cell.zjxs = _zjxs;
    cell.selectData = _selectData;
    cell.workTypeArray = _workTypeArray;
    cell.workArray = _workArray;
    cell.projectList = _projectList;
    cell.plan = _plan;
    return cell;
}

#pragma mark - PlanWriteTableCellDelegate
- (void)didFinishPlanType:(PlanWriteTableCell *)planWriteCell {
    self.workTypeArray = planWriteCell.workTypeArray;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2],[NSIndexPath indexPathForRow:7 inSection:2],[NSIndexPath indexPathForRow:8 inSection:2],[NSIndexPath indexPathForRow:9 inSection:2],[NSIndexPath indexPathForRow:10 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didFinishBpcType:(PlanWriteTableCell *)planWriteCell {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didFinishWorkType:(PlanWriteTableCell *)planWriteCell {
    self.workArray = planWriteCell.workArray;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:2],[NSIndexPath indexPathForRow:9 inSection:2],[NSIndexPath indexPathForRow:10 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didFinishWork:(PlanWriteTableCell *)planWriteCell {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:10 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadSection:(PlanWriteTableCell *)planWriteCell {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)planWriteTableCellReloadTableView:(PlanWriteTableCell *)planWriteCell {
    [self.tableView reloadData];
}

- (void)planWriteTableCellDidClickOperatorSearch:(PlanWriteTableCell *)planWriteCell {
    RjhOperatorSearchViewController *operatorSearchVc = [[RjhOperatorSearchViewController alloc] init];
    operatorSearchVc.delegate = self;
    [operatorSearchVc setOperatorId:planWriteCell.plan.operatorid operatorName:planWriteCell.plan.operatorname zjxsArray:_zjxs];
    [self.navigationController pushViewController:operatorSearchVc animated:YES];
}

- (void)planWriteTableCellDidClickBpcSearch:(PlanWriteTableCell *)planWriteCell bpcType:(BpcType)bpcType{
    switch (bpcType) {
        case BpcTypePotential:{
            KhSearchViewController *khSearchVc = [[KhSearchViewController alloc] init];
            khSearchVc.delegate = self;
            [self.navigationController pushViewController:khSearchVc animated:YES];
            break;
            }
        case BpcTypeSigning:{
            RjhBpcSearchViewController *bpcSearchVc = [[RjhBpcSearchViewController alloc] init];
            bpcSearchVc.delegate = self;
            [self.navigationController pushViewController:bpcSearchVc animated:YES];
            break;
            }
        default:
            break;
    }
}

- (void)planWriteTableCellDidClickXmSearch:(PlanWriteTableCell *)planWriteCell {
    WKXmSearchViewController *xmSearchVc = [[WKXmSearchViewController alloc] init];
    xmSearchVc.delegate = self;
    xmSearchVc.xmArray = self.projectList;
    [self.navigationController pushViewController:xmSearchVc animated:YES];
}

- (void)xmSearchViewDidSelectXm:(WKXmSearchViewController *)xmSearchVc {
    if (xmSearchVc.hasCreate) {
        [self loadProjectList];
    }
    self.plan.projectid = xmSearchVc.selectPR.projectid;
    [self.tableView reloadData];
}

- (void)planWriteTableCellDidClickTrack:(PlanWriteTableCell *)planWriteCell {
    RjhSignInTableViewController *signIn = [[RjhSignInTableViewController alloc] initWithPlan:_plan];
    [self.navigationController pushViewController:signIn animated:YES];
}


#pragma mark - RjhOperatorSearchViewControllerDelegate
/** 承办人选择之后返回 */
- (void)operatorSearchViewControllerDidBackLeftBarButtonItem:(RjhOperatorSearchViewController *)operatorSearchVc {
    NSArray *keys = [operatorSearchVc.selectDict allKeys];
    NSMutableString *tempOperatorid = [NSMutableString string];
    NSMutableString *tempOperatorname = [NSMutableString string];
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [operatorSearchVc.selectDict objectForKey:key];
        if (i == [keys count] - 1) {
            [tempOperatorid appendString:key];
            [tempOperatorname appendString:value];
        }else{
            [tempOperatorid appendString:[NSString stringWithFormat:@"%@,",key]];
            [tempOperatorname appendString:[NSString stringWithFormat:@"%@,",value]];
        }
    }
    self.plan.operatorid = [tempOperatorid copy];
    self.plan.operatorname = [tempOperatorname copy];
    [self.tableView reloadData];
}

#pragma mark - 检索联系人
- (void)planWriteTableCellDidClickTelSearch:(PlanWriteTableCell *)planWriteCell {
    if (iOS9OrLater) {
        [_objct10 getAddress:self];
    }else{
        [_objct9 getAddress:self];
    }
}

#pragma mark - KhSearchViewControllerDelegate
/** 潜在客户检索完成之后返回 */
- (void)khSearchViewControllerChooseKh:(KhSearchViewController *)khSearchVc qzkh:(QzBpc *)qzbpc {
    self.plan.khdm = [NSString stringWithFormat:@"%@",qzbpc.xh];
    self.plan.khmc = [NSString stringWithFormat:@"%@",qzbpc.mc];
    [self.tableView reloadData];
}

#pragma mark - RjhBpcSearchViewControllerDelegate
/** 客户检索完成之后返回 */
- (void)rjhBpcSearchViewControllerDidSelectBpc:(RjhBpcSearchViewController *)bpcSearchVc {
    self.plan.khdm = bpcSearchVc.bpc.khdm;
    self.plan.khmc = bpcSearchVc.bpc.khmc;
    [self.tableView reloadData];
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 12) {
        return 44.0f * 5;
    }else if(indexPath.section == 2 && indexPath.row == 10){
        return [_plan.jobremark_placeholder length] > 0 ? 44.0f : 0.0f;
    }else if(indexPath.section == 2 && indexPath.row == 9){
        return _plan.leveltype == 4 ? 44.0f : 0.0f;
    }else if(indexPath.section == 2 && indexPath.row == 2){
        return self.zjxs.count > 0 ? 44.0f : 0.0f;
    }else{
        return 44.0f;
    }
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
