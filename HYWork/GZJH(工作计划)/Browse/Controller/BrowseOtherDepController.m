//
//  BrowseOtherDepController.m
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BrowseOtherDepController.h"
#import "TxlManager.h"
#import "LoadViewController.h"
#import "SectionHeaderView.h"
#import "YLYTableViewIndexView.h"
#import "BrowseCell.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "YLYSearchBar.h"
#import "LYConstans.h"

@interface BrowseOtherDepController()<UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexDelegate,UITextFieldDelegate>
{
   YLYSearchBar *_searchTF;
   UIView *_warningView;
}
@property (nonatomic, strong)  NSArray *sectionArray;
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  UILabel *flotageLabel; //显示视图
@property (nonatomic, strong)  YLYTableViewIndexView *ylyView;
@end

@implementation BrowseOtherDepController

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
    
    [self requestOtherDepData];
    
    [self initFlotageLabel];
    
    [self initSearchBar];
    
    [self initWarningLabel];
}

#pragma mark - 初始化tableView
- (void)initTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - 请求所有员工数据
- (void)requestOtherDepData {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:@"allEmp"];
    
    if (data == nil) {
        [self refreshAllEmpsThroughSQLServerWithBlock:^{}];
    } else {
        _citiesDic = [data copy];
        
        _tempDict = [_citiesDic copy];
        
        _sectionArray = [[_tempDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [self.tableView reloadData];
        [self initIndexView];
    }
}

- (void)refreshAllEmpsThroughSQLServerWithBlock:(void (^)())block{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [_ylyView removeFromSuperview];
    
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
            
            _citiesDic = data;
            
            _tempDict = [_citiesDic copy];
            
            _sectionArray = [[_tempDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
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

#pragma mark - 初始化 flotage
- (void)initFlotageLabel {
    self.flotageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64)/2, (_tableView.frame.size.height - 64) / 2, 64, 64)];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
}

- (void)initSearchBar {
    CGFloat searchBarX = 10;
    CGFloat searchBarY = 6;
    CGFloat searchBarW = SCREEN_WIDTH - 2 * searchBarX;
    CGFloat searchBarH = SearchBarHeight - 2 * searchBarY;
    
    _searchTF = [[YLYSearchBar alloc ] init];
    _searchTF.keyboardType = UIKeyboardTypeDefault;
    _searchTF.returnKeyType = UIReturnKeyDone;
    _searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTF.layer.borderWidth = 0.2;
    _searchTF.layer.cornerRadius = 4;
    _searchTF.delegate = self;
    _searchTF.backgroundColor = GQColor(244, 244, 244);
    _searchTF.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchTF];
}

- (void)initWarningLabel {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, SearchBarHeight, self.view.frame.size.width, self.view.frame.size.height - SearchBarHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *warningL = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, (SCREEN_HEIGHT - 40)/2 - 100, 100, 40)];
    warningL.text = @"无结果";
    warningL.font = [UIFont systemFontOfSize:25];
    warningL.textColor = [UIColor grayColor];
    [bgView addSubview:warningL];
    [self.view addSubview:bgView];
    _warningView = bgView;
    _warningView.hidden = YES;
}

#pragma mark - textField字符改变的监听方法UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    [self searchCityWithText:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - 匹配关键字
- (void)searchCityWithText:(NSString *)searchText {
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) { //有中文
        for (NSString *key in _citiesDic.allKeys) {
            
            NSArray *emps = [_citiesDic objectForKey:key];
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
        for (NSString *key in _citiesDic.allKeys) {
            
            NSArray *emps = [_citiesDic objectForKey:key];
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
        _tempDict = [_citiesDic copy];
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

#pragma mark - 初始化 右侧字母表 和 提示框
- (void)initIndexView {
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc] initWithFrame:(CGRect){SCREEN_WIDTH - 20,0,20,SCREEN_HEIGHT}];
    indexView.tableViewIndexDelegate = self;
    _ylyView = indexView;
    [self.view addSubview:indexView];
    
    CGRect rect = indexView.frame;
    rect.size.height = _sectionArray.count * 16;
    rect.origin.y = (SCREEN_HEIGHT - 64 - SearchBarHeight - rect.size.height) / 2;
    indexView.frame = rect;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_sectionArray objectAtIndex:section];
    NSArray  *values = [_tempDict objectForKey:key];
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrowseCell *cell = [BrowseCell cellWithTableView:tableView];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict objectForKey:key];
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
    return [BrowseCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_sectionArray objectAtIndex:indexPath.section];
    NSArray  *array = [_tempDict valueForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBrowseCellClick object:nil userInfo:@{kBrowseCellClick: dict}];
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
