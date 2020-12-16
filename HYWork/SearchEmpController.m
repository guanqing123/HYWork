//
//  SearchEmpController.m
//  HYWork
//
//  Created by information on 16/4/14.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SearchEmpController.h"
#import "YLYSearchBar.h"
#import "TxlCell.h"
#import "EmpDetailController.h"

@interface SearchEmpController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    YLYSearchBar *_searchTF;
    UIView *_warningView;
}

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *searchResults;

@end

@implementation SearchEmpController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self initTableView];
    
    [self initSearchBar];
    
    [self initWarningLabel];
}

- (void)setCitiesDic:(NSDictionary *)citiesDic {
    _citiesDic = citiesDic;
}

- (void)initTableView {
    //搜索tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = GQColor(248, 248, 248);
    [self.view addSubview:_tableView];
}

- (void)initSearchBar {
    CGFloat searchViewW = SCREEN_WIDTH;
    CGFloat searchViewH = 44;
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor clearColor];
    searchView.frame = CGRectMake(0, 0, searchViewW, searchViewH);
    
    CGFloat searchBarW = SCREEN_WIDTH - 60;
    CGFloat searchBarH = 32;
    CGFloat searchBarX = 5;
    
    _searchTF = [[YLYSearchBar alloc ] init];
    _searchTF.keyboardType = UIKeyboardTypeWebSearch;
    _searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTF.layer.borderWidth = 0.2;
    _searchTF.layer.cornerRadius = 4;
    _searchTF.delegate = self;
    _searchTF.backgroundColor = GQColor(244, 244, 244);
    _searchTF.frame = CGRectMake(0, searchBarX, searchBarW, searchBarH);
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_searchTF];
    
    CGFloat cancelBtnX = SCREEN_WIDTH - 65;
    CGFloat cancelBtnW = 60;
    CGFloat cancelBtnH = searchBarH;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(cancelBtnX, searchBarX, cancelBtnW, cancelBtnH);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    
    self.navigationItem.titleView = searchView;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [_searchTF becomeFirstResponder];
}

- (void)initWarningLabel {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

#pragma mark - 取消操作
- (void)cancelAction {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageUnCurl";
    animation.type = kCATransitionFade;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TxlCell *cell = [TxlCell cellWithTableView:tableView];
    
    NSDictionary *dict = [_searchResults objectAtIndex:indexPath.row];
    
    cell.ygxm = dict[@"ygxm"];
    cell.mobile = dict[@"mobile"];
    cell.zwsm = [NSString stringWithFormat:@"%@/%@",dict[@"bmmc"],dict[@"zwsm"]];
    
    return cell;
}

#pragma mark - searchResults 懒加载
- (NSMutableArray *)searchResults {
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

#pragma mark - textField字符改变的监听方法UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    [self searchCityWithText:textField.text];
}

#pragma mark - 匹配关键字
- (void)searchCityWithText:(NSString *)searchText {
    [self.searchResults removeAllObjects];
    if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) { //有中文
        for (NSString *key in _citiesDic.allKeys) {
            NSArray *emps = [_citiesDic valueForKey:key];
            for (NSDictionary *dict in emps) {
                NSRange titleResult = [dict[@"ygxm"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange deptResult = [dict[@"bmmc"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0 || deptResult.length > 0) {
                    [self.searchResults addObject:dict];
                }
            }
        }
    }else if (searchText.length > 0 && ![self isIncludeChineseInString:searchText]) { //英文
        for (NSString *key in _citiesDic.allKeys) {
            NSArray *emps = [_citiesDic valueForKey:key];
            for (NSDictionary *dict in emps) {
                NSRange titleResult = [dict[@"pinyinlastname"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange telResult = [dict[@"mobile"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0 || telResult.length > 0) {
                    [self.searchResults addObject:dict];
                }
            }
        }
    }
    if (_searchResults.count > 0) {
        _warningView.hidden = YES;
    }else{
        _warningView.hidden = NO;
    }
    
    [_tableView reloadData];
    
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

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TxlCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_searchTF resignFirstResponder];
    
    NSDictionary *dict = [_searchResults objectAtIndex:indexPath.row];
    
    EmpDetailController *empDetail = [[EmpDetailController alloc] initWithGh:dict[@"ygbm"]];
    empDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:empDetail animated:YES];
}

#pragma mark - scrollView 代理方法
#pragma mark - UIScrollViewDelegate代理
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [_searchTF resignFirstResponder];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
