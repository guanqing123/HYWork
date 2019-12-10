//
//  WKBrowseAllViewController.m
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBrowseAllViewController.h"
#import "WKBrowseSearchBar.h"
#import "WKBrowseTableViewCell.h"
#import "SectionHeaderView.h"
#import "YLYTableViewIndexView.h"
#import "LYConstans.h"
#import "MBProgressHUD+MJ.h"
#import "TxlManager.h"
#import "Utils.h"

@interface WKBrowseAllViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexDelegate>

@property (nonatomic, strong)  NSArray *sectionArray;
@property (nonatomic, strong)  NSDictionary *commonDict;
@property (nonatomic, strong)  NSDictionary *tempDict;

@property (nonatomic, weak) WKBrowseSearchBar  *searchBar;

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, strong)  UIView *warningView;

@property (nonatomic, strong)  UILabel *flotageLabel; //显示视图

@property (nonatomic, strong)  YLYTableViewIndexView *ylyView;

@property (nonatomic, weak) UIButton  *addButton;

@end

@implementation WKBrowseAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置搜索框
    [self setupSearchBar];
    
    // 2.设置 tableView
    [self setupTableView];
    
    // 3.设置 警告view
    [self setupWarningView];
    
    // 4.设置 FlotageLabel
    [self setupFlotageLabel];
    
    // 5.获取 数据
    [self setupData];
    
    // 6.设置 右边字母表
    [self setupIndexView];
    
    // 7.设置 编辑按钮
    [self setupEditorState];
}

#pragma mark - 设置搜索框
- (void)setupSearchBar {
    CGFloat searchBarX = 10;
    CGFloat searchBarY = 6;
    CGFloat searchBarW = SCREEN_WIDTH - 2 * searchBarX;
    CGFloat searchBarH = SearchBarHeight - 2 * searchBarY;
    
    WKBrowseSearchBar *searchBar = [[WKBrowseSearchBar alloc ] init];
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBar.layer.borderWidth = 0.2;
    searchBar.layer.cornerRadius = 4;
    searchBar.delegate = self;
    searchBar.backgroundColor = GQColor(244, 244, 244);
    searchBar.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    [searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _searchBar = searchBar;
    [self.view addSubview:searchBar];
}

#pragma mark - 设置 tableView
- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    _tableView = tableView;
    [self.view addSubview:tableView];
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
    WKBrowseTableViewCell *cell = [WKBrowseTableViewCell cellWithTableView:tableView];
    
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
    return [WKBrowseTableViewCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:rjhBrowseCellClick object:nil userInfo:@{rjhBrowseCellClick : dict}];
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 设置 警告View
- (void)setupWarningView {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, SearchBarHeight, self.view.dc_width, self.view.dc_height - SearchBarHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *warningL = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, (SCREEN_HEIGHT - 40)/2 - 100, 100, 40)];
    warningL.text = @"无结果";
    warningL.font = [UIFont systemFontOfSize:25];
    warningL.textColor = [UIColor grayColor];
    [bgView addSubview:warningL];
    [self.view addSubview:bgView];
    self.warningView = bgView;
    self.warningView.hidden = YES;
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
    _commonDict = [data copy];
    _tempDict = [_commonDict copy];
    _sectionArray = [[_tempDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
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

#pragma mark - textField字符改变的监听方法UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    [self searchEmp:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - 匹配关键字
- (void)searchEmp:(NSString *)searchText {
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) { //有中文
        for (NSString *key in _commonDict.allKeys) {
            
            NSArray *emps = [_commonDict valueForKey:key];
            NSMutableArray *tempEmps = [NSMutableArray array];
            
            for (NSDictionary *dict in emps) {
                NSRange titleResult = [dict[@"ygxm"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [tempEmps addObject:dict];
                }
            }
            if (tempEmps.count > 0) {
                [tempDict setObject:tempEmps forKey:key];
            }
        }
    }else if (searchText.length > 0 && ![self isIncludeChineseInString:searchText]) { //英文
        for (NSString *key in _commonDict.allKeys) {
            
            NSArray *emps = [_commonDict valueForKey:key];
            NSMutableArray *tempEmps = [NSMutableArray array];
            
            for (NSDictionary *dict in emps) {
                NSRange titleResult = [dict[@"pinyinlastname"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [tempEmps addObject:dict];
                }
            }
            if (tempEmps.count > 0) {
                [tempDict setObject:tempEmps forKey:key];
            }
        }
    }
    
    if (searchText.length > 0) {
        _tempDict = [tempDict copy];
    }else{
        _tempDict = [_commonDict copy];
    }
    _sectionArray = [[_tempDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (_sectionArray.count > 0) {
        _warningView.hidden = YES;
    }else{
        _warningView.hidden = NO;
    }
    
    [self.tableView reloadData];
}


#pragma mark - 判断中文
- (BOOL)isIncludeChineseInString:(NSString *)str {
    for (int i=0; i<str.length;i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 刷新本地数据
- (void)refreshAllEmpsThroughSQLServerWithBlock:(void (^)())block{
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
    addButton.frame = CGRectMake(self.view.dc_width - addButtonW - addButtonH, self.view.dc_height - HWTopNavH - 2 * addButtonH, addButtonW, addButtonH);
    [addButton addTarget:self action:@selector(editorAdd:) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.borderColor = GQColor(0, 157, 133).CGColor;
    addButton.layer.borderWidth = 1;
    addButton.layer.cornerRadius = 10;
    _addButton = addButton;
    [self.view addSubview:addButton];
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
