//
//  WKXmSearchViewController.m
//  HYWork
//
//  Created by information on 2021/10/3.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKXmSearchViewController.h"
#import "YLYSearchBar.h"

#import "AddButton.h"
#import "WKGckhViewController.h"
#import "LoadViewController.h"
#import "WKProjectParam.h"
#import "RjhManager.h"

@interface WKXmSearchViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    YLYSearchBar *_searchTF;
    UIView *_warningView;
}
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *searchXmArray;

@property (nonatomic, copy) NSString *ywy;

@end

@implementation WKXmSearchViewController

static NSString *WKXmTableViewCellID = @"WKXmTableViewCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.create) {
        WKProjectParam *param = [WKProjectParam param:project];
        param.userid = [LoadViewController shareInstance].emp.ygbm;
    //    param.userid = @"05208";
        WEAKSELF
        [SVProgressHUD show];
        [RjhManager getProjectList:param success:^(NSArray *projectList) {
            [SVProgressHUD dismiss];
            weakSelf.create = NO;
            [weakSelf setXmArray:projectList];
            [weakSelf.tableView reloadData];
        } fail:^{
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检索项目";
    // Do any additional setup after loading the view.
    [self initNavigation];
    
    [self initSearchBar];
    
    [self initTableView];
    
    [self initWarningLabel];
    
    [self setupAddButton];
}

-(void)setXmArray:(NSArray *)xmArray {
    _xmArray = xmArray;
    [self.searchXmArray removeAllObjects];
    [self.searchXmArray addObjectsFromArray:xmArray];
}

- (void)initNavigation {
    //设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)initTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SearchBarHeight - HWTopNavH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)initSearchBar {
    UIView *superView = [[UIView alloc] init];
    superView.backgroundColor = [UIColor whiteColor];
    superView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SearchBarHeight);
    [self.view addSubview:superView];
    
    CGFloat searchBarX = 10;
    CGFloat searchBarY = 6;
    CGFloat searchBarW = SCREEN_WIDTH - 2 * searchBarX;
    CGFloat searchBarH = SearchBarHeight - 2 * searchBarY;
    
    _searchTF = [[YLYSearchBar alloc ] init];
    _searchTF.keyboardType = UIKeyboardTypeDefault;
    _searchTF.placeholder = @"项目名称/项目号";
    _searchTF.returnKeyType = UIReturnKeyDone;
    _searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTF.layer.borderWidth = 0.2;
    _searchTF.layer.cornerRadius = 4;
    _searchTF.delegate = self;
    _searchTF.backgroundColor = GQColor(244, 244, 244);
    _searchTF.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [superView addSubview:_searchTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchBarHeight - 1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = GQColor(233, 233, 233);
    [superView addSubview:lineView];
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

#pragma mark - 初始化右下角+号按钮
- (void)setupAddButton {
    CGFloat  addButtonW = 60;
    CGFloat  addButtonH = 60;
    CGFloat  addButtonX = SCREEN_WIDTH - addButtonW - 15;
    CGFloat  addButtonY = SCREEN_HEIGHT - NAV_BAR_HEIGHT - addButtonH - 15;
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
    self.create = YES;
    self.hasCreate = YES;
    WKGckhViewController *gckhVc = [[WKGckhViewController alloc] initWithXh:@"0" ywy:self.ywy];
    gckhVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:gckhVc animated:YES];
}

- (NSString *)ywy {
    if (_ywy == nil) {
        _ywy = [LoadViewController shareInstance].emp.ygbm;
    }
    return _ywy;
}

#pragma mark - textField字符改变的监听方法UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    [self searchXmWithText:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(NSArray *)searchXmArray {
    if (!_searchXmArray) {
        _searchXmArray = [NSMutableArray array];
    }
    return _searchXmArray;
}

#pragma mark - 匹配关键字
- (void)searchXmWithText:(NSString *)searchText {
    NSMutableArray *tempArray = [NSMutableArray array];
    if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) { //有中文
        for (WKProjectResult *result in self.xmArray) {
            NSRange xmResult = [result.projectname rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (xmResult.length > 0) {
                [tempArray addObject:result];
            }
        }
    }else{
        for (WKProjectResult *result in self.xmArray) {
            NSRange xmResult = [result.projectid rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (xmResult.length > 0) {
                [tempArray addObject:result];
            }
        }
    }

    if (searchText.length <= 0) {
        [self.searchXmArray removeAllObjects];
        [self.searchXmArray addObjectsFromArray:self.xmArray];
    } else {
        [self.searchXmArray removeAllObjects];
        [self.searchXmArray addObjectsFromArray:tempArray];
    }

    if (self.searchXmArray.count > 0) {
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

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchXmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKXmTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WKXmTableViewCellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(223, 223, 223);
        [cell.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            [[make leading] trailing].equalTo([cell contentView]);
            [make bottom].equalTo([cell.contentView mas_bottom]);
            [make height].mas_equalTo(@(1));
        }];
    }
    
    WKProjectResult *result = self.searchXmArray[indexPath.row];
    cell.textLabel.text = result.projectid;
    cell.detailTextLabel.text = result.projectname;
    
    return cell;
}

#pragma mark -tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPR = self.searchXmArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(xmSearchViewDidSelectXm:)]) {
        [self.delegate xmSearchViewDidSelectXm:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
