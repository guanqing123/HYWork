//
//  DkViewController.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DkViewController.h"
#import "DkHeaderView.h"
#import "DkCell.h"

@interface DkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat changeY;
}
@end

@implementation DkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    changeY = 64.0f;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanxuan"] style:UIBarButtonItemStyleDone target:self action:@selector(shanxuan)];
    self.navigationItem.rightBarButtonItem = right;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1280.0f, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    scrollView.contentSize = tableView.contentSize = CGSizeMake(1280.0f, 0);
    [scrollView addSubview:tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 32.0f, self.view.frame.size.width, 32.0f)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
    [self.view addSubview:bottomView];
    
    UILabel *hkzjeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 6.0f, 200.0f, 20.0f)];
    _hkzje = @"0.0";
    NSString *str = [NSString stringWithFormat:@"到款总金额: %@",_hkzje];
    hkzjeLabel.text = str;
    hkzjeLabel.font = [UIFont systemFontOfSize:14];
    hkzjeLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:hkzjeLabel];
    
    [self shanxuan];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shanxuan {
    if (_dkConditionView == nil) {
        _dkConditionView = [[DkConditionView alloc] initWithFrame:CGRectMake(0, -264, self.view.frame.size.width, 264)];
        [self.view addSubview:_dkConditionView];
    }
    if (!self.isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
            _dkConditionView.frame = CGRectMake(0, changeY, self.view.frame.size.width, 264);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _dkConditionView.frame = CGRectMake(0, -264, self.view.frame.size.width, 264);
        }];
    }
    _appeared = !self.isAppeared;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DkCell *cell = [DkCell cellWithTableView:tableView];
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DkHeaderView *headerView = [DkHeaderView headerView:CGRectMake(0.0f, 0.0f, 1280.0f, 44.0f)];
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
