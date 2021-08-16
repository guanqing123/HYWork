//
//  WKCommonGroupViewController.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKCommonGroupViewController.h"
#import "WKEmpDetailViewController.h"
#import "WKAddressListTableViewCell.h"
#import "SectionHeaderView.h"
#import "YLYTableViewIndexView.h"
#import "LYConstans.h"
#import "MBProgressHUD+MJ.h"
#import "TxlManager.h"
#import "LoadViewController.h"
#import "Utils.h"

@interface WKCommonGroupViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexDelegate>

@property (nonatomic, strong)  NSArray *sectionArray;
@property (nonatomic, strong)  NSDictionary *tempDict;

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, strong)  UILabel *flotageLabel; //显示视图

@property (nonatomic, strong)  YLYTableViewIndexView *ylyView;

@property (nonatomic, weak) UIButton  *deleteButton;

@end

@implementation WKCommonGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置 tableView
    [self setupTableView];
    
    // 2.设置 FlotageLabel
    [self setupFlotageLabel];
    
    // 3.获取 数据
    [self setupData];
    
    // 4.响应 notice
    [self setupNotification];
    
    // 5.编辑按钮
    [self setupEditorState];
}

#pragma mark - 设置 tableView
- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
//    tableView.frame = CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        [[make leading] trailing].equalTo([self view]);

        MASViewAttribute *top = [self mas_topLayoutGuideBottom];
        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];

        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                top = [[self view] mas_safeAreaLayoutGuideTop];
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif

        [make top].equalTo(top);
        [make bottom].equalTo(bottom);
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_sectionArray objectAtIndex:section];
    NSArray *values = [_tempDict objectForKey:key];
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKAddressListTableViewCell *cell = [WKAddressListTableViewCell cellWithTableView:tableView];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray *array = [_tempDict objectForKey:key];
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
    return [WKAddressListTableViewCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    WKEmpDetailViewController *empDetail = [[WKEmpDetailViewController alloc] initWithGh:dict[@"ygbm"]];
    empDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:empDetail animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFromCommon:indexPath];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *deleteCommon = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"从常用组删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf deleteFromCommon:indexPath];
    }];
    return @[deleteCommon];
}

- (void)deleteFromCommon:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"commonEmp"];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    NSString *first = [dict[@"pinyinlastname"] substringToIndex:1];
    
    NSArray *arrayInData = [data objectForKey:first];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arrayInData];
    for (NSDictionary *d in tempArray) {
        if ([d[@"ygbm"] isEqualToString:dict[@"ygbm"]]) {
            [tempArray removeObject:d];
            break;
        }
    }
    if (tempArray.count < 1) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
        [tempDict removeObjectForKey:first];
        [userDefault setObject:tempDict forKey:@"commonEmp"];
        [userDefault synchronize];
        [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
    }else{
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
        [tempDict setObject:tempArray forKey:first];
        [userDefault setObject:tempDict forKey:@"commonEmp"];
        [userDefault synchronize];
        [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
    }
    
    [self refreshAddCommon];
}

#pragma mark - 设置 flotage
- (void)setupFlotageLabel {
    self.flotageLabel = [[UILabel alloc] init];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
    
    [_flotageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
}

#pragma mark - 获取数据
- (void)setupData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"commonEmp"];
    if (data == nil || [data.allKeys count] < 1) {
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        NSString *ygbm = [LoadViewController shareInstance].emp.ygbm;
        [_ylyView removeFromSuperview];
        [TxlManager getEmpsInfoWithGh:ygbm Type:@"1" Success:^(id json) {
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *data = [json objectForKey:@"data"];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:data forKey:@"commonEmp"];
                [userDefault synchronize];
                
                self->_commonDict = [data copy];
                self->_tempDict = [self->_commonDict copy];
                self->_sectionArray = [[self->_commonDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
                [self.tableView reloadData];
                
                [self setupIndexView];
            }
        } Fail:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常,请稍候再试"];
        }];
    } else {
        _commonDict = [data copy];
        _tempDict = [_commonDict copy];
        _sectionArray = [[_commonDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [self.tableView reloadData];
        
        [self setupIndexView];
    }
}

#pragma mark - 设置 右边字母表
- (void)setupIndexView {
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc] initWithFrame:(CGRect){SCREEN_WIDTH - 20,0,20,SCREEN_HEIGHT}];
    indexView.tableViewIndexDelegate = self;
    _ylyView = indexView;
    [self.view addSubview:indexView];
    
    CGRect rect = indexView.frame;
    rect.size.height = _sectionArray.count * 16;
    rect.origin.y = (SCREEN_HEIGHT - 64 - SearchBarHeight - rect.size.height) / 2;
    indexView.frame = rect;
}

#pragma mark - YLYTableViewIndexDelegate
- (NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableViewIndex {
    return _sectionArray;
}

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

#pragma mark - setupNotification
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddCommon) name:rjhBrowseCellAddCommon object:nil];
}

- (void)refreshAddCommon {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"commonEmp"];
    _commonDict = [data copy];
    _tempDict = [_commonDict copy];
    _sectionArray = [[_commonDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
    
    [self.ylyView removeFromSuperview];
    [self setupIndexView];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 请求同部门数据
- (void)requestCommonGroupDataWithBlock:(void (^)(void))block {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self refreshAddCommon];
    [MBProgressHUD hideHUDForView:self.view];
    block();
}

#pragma mark - setupEditorState
- (void)setupEditorState {
    UIButton *deleteButton = [[UIButton alloc] init];
    CGFloat deleteButtonW = 60;
    CGFloat deleteButtonH = 30;
    [deleteButton setTitle:@"编辑" forState:UIControlStateNormal];
    [deleteButton setTitleColor:GQColor(0, 157, 133) forState:UIControlStateNormal];
//    deleteButton.frame = CGRectMake(self.view.dc_width - deleteButtonW - deleteButtonH, self.view.dc_height - HWTopNavH - 2 * deleteButtonH, deleteButtonW, deleteButtonH);
    [deleteButton addTarget:self action:@selector(editorDelete:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.layer.borderColor = GQColor(0, 157, 133).CGColor;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.cornerRadius = 10;
    _deleteButton = deleteButton;
    [self.view addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(deleteButtonW, deleteButtonH));

        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];

        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif

        [make right].equalTo(self.view).mas_offset(-deleteButtonH);
        [make bottom].equalTo(bottom).mas_offset(-deleteButtonH);
    }];
}

- (void)editorDelete:(UIButton *)button {
    // 现在是否处于编辑模式
    if (self.tableView.isEditing) {
        // 改变按钮的文本为Edit，并关闭编辑模式
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }else{
        // 改变按钮的文本为Done，并开启编辑模式
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

@end
