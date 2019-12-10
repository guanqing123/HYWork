//
//  RjhOperatorSearchViewController.m
//  HYWork
//
//  Created by information on 2017/6/9.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhOperatorSearchViewController.h"
#import "OperatorSearchTableCell.h"
#import "YLYSearchBar.h"

@interface RjhOperatorSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OperatorSearchTableCellDelegate>
{
    YLYSearchBar *_searchTF;
    UIView *_warningView;
}
@property (nonatomic, strong)  UITableView *tableView;
@end

@implementation RjhOperatorSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 1.设置导航栏 */
    [self setupNavBar];
    
    /** 2.设置搜索框 */
    [self setupSearchBar];
    
    /** 3.设置tableView */
    [self setupTableView];
    
    /** 4.设置warningLabel */
    [self setupWarningLabel];
}

/** dataArray 懒加载 */
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/** selectDict 懒加载 */
- (NSMutableDictionary *)selectDict {
    if (_selectDict == nil) {
        _selectDict = [NSMutableDictionary dictionary];
    }
    return _selectDict;
}

/** 初始化数据 */
- (void)setOperatorId:(NSString *)operatorid operatorName:(NSString *)operatorname zjxsArray:(NSArray *)zjxsArray {
    _operatorid = operatorid;
    _operatorname = operatorname;
    _zjxsArray = zjxsArray;
    [self.dataArray addObjectsFromArray:zjxsArray];
    if (![operatorid isEqual:[NSNull null]] && ![operatorname isEqual:[NSNull null]] && [operatorid length] > 0) {
        self.operatorArray = [_operatorid componentsSeparatedByString:@","];
        self.operatornameArray = [_operatorname componentsSeparatedByString:@","];
        for (int i = 0; i < [self.operatorArray count]; i++) {
            NSString *key = self.operatorArray[i];
            NSString *value = self.operatornameArray[i];
            [self.selectDict setObject:value forKey:key];
        }
    }
}

#pragma mark - 设置导航栏的内容
- (void)setupNavBar {
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 设置view不要延伸
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //view的颜色
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)back {
    if ([self.delegate respondsToSelector:@selector(operatorSearchViewControllerDidBackLeftBarButtonItem:)]) {
        [self.delegate operatorSearchViewControllerDidBackLeftBarButtonItem:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置搜索栏
- (void)setupSearchBar {
    UIView *superView = [[UIView alloc] init];
    superView.backgroundColor = [UIColor whiteColor];
    superView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0f);
    [self.view addSubview:superView];
    
    CGFloat searchBarX = 10;
    CGFloat searchBarY = 6;
    CGFloat searchBarW = SCREEN_WIDTH - 2 * searchBarX;
    CGFloat searchBarH = 32;
    
    _searchTF = [[YLYSearchBar alloc] init];
    _searchTF.keyboardType = UIKeyboardTypeDefault;
    _searchTF.returnKeyType = UIReturnKeyDone;
    _searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTF.layer.borderWidth = 0.2;
    _searchTF.layer.cornerRadius = 4;
    _searchTF.delegate = self;
    _searchTF.backgroundColor = GQColor(244, 244, 244);
    _searchTF.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [superView addSubview:_searchTF];
}

#pragma mark - 设置tableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 44.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 108.0f);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = GQColor(244, 244, 244);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OperatorSearchTableCell *operatorCell = [OperatorSearchTableCell cellWithTableView:tableView];
    operatorCell.delegate = self;
    
    ZJXS *zjxs = self.dataArray[indexPath.row];
    operatorCell.zjxs = zjxs;
    if ([[self.selectDict allKeys] containsObject:zjxs.ygbm]) {
        operatorCell.choosed =  true;
    }else{
        operatorCell.choosed = false;
    }
    
    return operatorCell;
}

#pragma mark - OperatorSearchTableCellDelegate
- (void)operatorSearchTableCellDidClickMarkBtn:(OperatorSearchTableCell *)tableCell {
    // 1.当前点击的员工
    NSString *ygbm = tableCell.zjxs.ygbm;
    
    // 2.处理点击事务
    if (tableCell.isChoosed) {
        [self.selectDict removeObjectForKey:ygbm];
    }else{
        [self.selectDict setObject:tableCell.zjxs.ygxm forKey:tableCell.zjxs.ygbm];
    }
    
    // 3.刷新tableView
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *headerView = [[UIButton alloc] init];
    [headerView setTitle:@"直接下属" forState:UIControlStateNormal];
    [headerView setTitleColor:GQColor(130, 130, 130) forState:UIControlStateNormal];
    headerView.titleLabel.font = [UIFont systemFontOfSize:14];
    headerView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    headerView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    headerView.backgroundColor = GQColor(244, 244, 244);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 设置警告Label
- (void)setupWarningLabel {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 44.0, self.view.frame.size.width, self.view.frame.size.height - 44.0);
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

- (void)searchCityWithText:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    NSMutableArray *tempArray = [NSMutableArray array];
    if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) {
        for (ZJXS *zjxs in self.zjxsArray) {
            NSRange titleResult = [zjxs.ygxm rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [tempArray addObject:zjxs];
            }
        }
    }
    if (searchText.length > 0) {
        [self.dataArray addObjectsFromArray:tempArray];
    }else{
        [self.dataArray addObjectsFromArray:self.zjxsArray];
    }
    
    if (self.dataArray.count > 0) {
        _warningView.hidden = YES;
    }else{
        _warningView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

/** 判断中文 */
- (BOOL)isIncludeChineseInString:(NSString *)str {
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - scrollViewWillBeginDragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

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
