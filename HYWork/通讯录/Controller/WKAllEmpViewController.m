//
//  WKAllEmpViewController.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKAllEmpViewController.h"
#import "WKEmpDetailViewController.h"

#import "WKAddressListTableViewCell.h"
#import "SectionHeaderView.h"
#import "YLYTableViewIndexView.h"
#import "LYConstans.h"
#import "MBProgressHUD+MJ.h"
#import "TxlManager.h"
#import "Utils.h"

@interface WKAllEmpViewController ()<UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexDelegate>
@property (nonatomic, strong)  NSArray *sectionArray;
@property (nonatomic, strong)  NSDictionary *tempDict;

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, strong)  UILabel *flotageLabel; //显示视图

@property (nonatomic, strong)  YLYTableViewIndexView *ylyView;

@property (nonatomic, weak) UIButton  *addButton;
@end

@implementation WKAllEmpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.设置 tableView
    [self setupTableView];
    
    // 2.设置 FlotageLabel
    [self setupFlotageLabel];
    
    // 3.获取 数据
    [self setupData];
    
    // 4.设置 编辑按钮
    [self setupEditorState];
}

#pragma mark - 设置 tableView
- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    //tableView.frame = CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight);
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
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self addCommon:indexPath];
    }
}

/*- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *addCommon = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加常用组" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf addCommon:indexPath];
    }];
    addCommon.backgroundColor = [UIColor greenColor];
    return @[addCommon];
}*/

- (void)addCommon:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"commonEmp"];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    NSString *first = [dict[@"pinyinlastname"] substringToIndex:1];
    
    NSArray *arrayInData = [data objectForKey:first];
    
    if (arrayInData) {
        int i = 0;
        for (NSDictionary *d in arrayInData) {
            if ([[d objectForKey:@"ygbm"] isEqualToString:dict[@"ygbm"]]) {
                i = 1;
                break;
            }
        }
        if (i == 0) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arrayInData];
            [tempArray addObject:dict];
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
            [tempDict setObject:tempArray forKey:first];
            [userDefault setObject:tempDict forKey:@"commonEmp"];
            [userDefault synchronize];
            [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:rjhBrowseCellAddCommon object:nil userInfo:nil];
        } else {
            [MBProgressHUD showError:@"已在常用组,无法添加" toView:self.view];
        }
    }else{
        NSMutableArray *tempArray = [NSMutableArray arrayWithObject:dict];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
        [tempDict setObject:tempArray forKey:first];
        [userDefault setObject:tempDict forKey:@"commonEmp"];
        [userDefault synchronize];
        [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:rjhBrowseCellAddCommon object:nil userInfo:nil];
    }
}

#pragma mark - 设置 flotage
- (void)setupFlotageLabel {
    self.flotageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64)/2, (_tableView.frame.size.height - 64) / 2, 64, 64)];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
}

#pragma mark - 获取数据
- (void)setupData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"allEmp"];
    
    if (data == nil || [[data allKeys] count] < 1) {
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        
        WEAKSELF
        [TxlManager getEmpsInfoWithGh:@"admin" Type:@"0" Success:^(id json) {
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *data = [json objectForKey:@"data"];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:data forKey:@"allEmp"];
                [userDefault synchronize];
                
                [weakSelf refreshAll];
            }
        } Fail:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常,请稍候再试"];
        }];
    } else {
        _commonDict = [data copy];
        _tempDict = [_commonDict copy];
        _sectionArray = [[_tempDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
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
//    rect.origin.y = (SCREEN_HEIGHT - HWTopNavH - SearchBarHeight - rect.size.height) / 2;
    rect.origin.y = (SCREEN_HEIGHT - HWTopNavH - SearchBarHeight)/2 - (rect.size.height)/2;
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

#pragma mark - 刷新本地数据
- (void)requestAllEmpsThroughSQLServerWithBlock:(void (^)())block{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [_ylyView removeFromSuperview];
    
    WEAKSELF
    [TxlManager getEmpsInfoWithGh:@"admin" Type:@"0" Success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *data = [json objectForKey:@"data"];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:data forKey:@"allEmp"];
            [userDefault synchronize];
            
            [weakSelf refreshAll];
            
            block();
        }
    } Fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍候再试"];
        
        block();
    }];
}

- (void)refreshAll {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"allEmp"];
    _commonDict = [data copy];
    _tempDict = [_commonDict copy];
    _sectionArray = [[_commonDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
    
    [self.ylyView removeFromSuperview];
    [self setupIndexView];
}

#pragma mark - setupEditorState
- (void)setupEditorState {
    UIButton *addButton = [[UIButton alloc] init];
    CGFloat addButtonW = 60;
    CGFloat addButtonH = 30;
    [addButton setTitle:@"编辑" forState:UIControlStateNormal];
    [addButton setTitleColor:GQColor(0, 157, 133) forState:UIControlStateNormal];
//    addButton.frame = CGRectMake(self.view.dc_width - addButtonW - addButtonH, self.view.dc_height - HWTopNavH - 2 * addButtonH, addButtonW, addButtonH);
    [addButton addTarget:self action:@selector(editorAdd:) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.borderColor = GQColor(0, 157, 133).CGColor;
    addButton.layer.borderWidth = 1;
    addButton.layer.cornerRadius = 10;
    _addButton = addButton;
    [self.view addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(addButtonW, addButtonH));

        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];

        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif

        [make right].equalTo(self.view).mas_offset(-addButtonH);
        [make bottom].equalTo(bottom).mas_offset(-addButtonH);
    }];
}

- (void)editorAdd:(UIButton *)button {
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
