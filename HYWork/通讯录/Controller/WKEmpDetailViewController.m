//
//  WKEmpDetailViewController.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKEmpDetailViewController.h"
#import "WKAddressListTableViewCell.h"
#import "TxlManager.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "EmpDetail.h"


@interface WKEmpDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  EmpDetail *empDetail;
@property (nonatomic, copy) NSString *gh;
@property (nonatomic, strong)  UIWebView *webView;

@end

@implementation WKEmpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self initTableView];
    
    [self loadData];
}

- (instancetype)initWithGh:(NSString *)gh {
    if (self = [super init]) {
        _gh = gh;
        self.title = @"员工详情";
    }
    return self;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [WKAddressListTableViewCell getCellHeight];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0 && [_empDetail.mobile length]>0) {
            return [WKAddressListTableViewCell getCellHeight];
        }else if (indexPath.row == 1 && [_empDetail.telephone length]>0) {
            return [WKAddressListTableViewCell getCellHeight];
        }else if (indexPath.row == 2 && [_empDetail.mobilecall length]>0) {
            return [WKAddressListTableViewCell getCellHeight];
        }else if(indexPath.row == 3){
            return [WKAddressListTableViewCell getCellHeight];
        }else{
            return 0.0f;
        }
    }else{
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120.0f)];
        [imageView setImage:[UIImage imageNamed:@"bg.jpg"]];
        [view addSubview:imageView];
        
        CGFloat  imageViewH = imageView.frame.size.height;
        UILabel *labelF = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewH, 15, 40.0f)];
        labelF.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
        [view addSubview:labelF];
        
        UILabel *labelS = [[UILabel alloc] initWithFrame:CGRectMake(15, imageViewH, SCREEN_WIDTH - 15, 40.0f)];
        labelS.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
        labelS.text = _empDetail.ygxm;
        [view addSubview:labelS];
        
        return view;
    }else if (section == 1) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
        subView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
        return subView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 160.0f;
    }else if (section == 1){
        return 10.0f;
    }
    return 0.0f;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_empDetail.mobile]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_empDetail.telephone]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_empDetail.mobilecall]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_empDetail.zws count];
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.detailTextLabel.textColor = GQColor(150.0f, 150.0f, 150.0f);
    if (indexPath.section == 0) {
        NSString *zw = [_empDetail.zws objectAtIndex:indexPath.row];
        NSArray *arr = [zw componentsSeparatedByString:@"/"];
        cell.textLabel.text = arr[0];
        cell.detailTextLabel.text = arr[1];
    } else if(indexPath.section == 1) {
        if (indexPath.row == 0 && [_empDetail.mobile length]>0) {
            cell.textLabel.text = _empDetail.mobile;
            cell.detailTextLabel.text = @"手机";
            cell.accessoryView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"mobile"]];
        }else if(indexPath.row == 1 && [_empDetail.telephone length]>0) {
            cell.textLabel.text = _empDetail.telephone;
            cell.detailTextLabel.text = @"办公电话";
            cell.accessoryView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"mobile"]];
        }else if(indexPath.row == 2 && [_empDetail.mobilecall length]>0) {
            cell.textLabel.text = _empDetail.mobilecall;
            cell.detailTextLabel.text = @"其他电话";
            cell.accessoryView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"mobile"]];
        }else if (indexPath.row == 3){
            cell.textLabel.text = _empDetail.email;
            cell.detailTextLabel.text = @"电子邮箱";
        }
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, [WKAddressListTableViewCell getCellHeight] - 1, SCREEN_WIDTH, 1);
    lineView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
    [cell.contentView addSubview:lineView];
    
    return cell;
}




#pragma mark - 初始化数据
- (void)loadData {
    [MBProgressHUD showMessage:@"查询中..." toView:self.view];
    [TxlManager getEmpDetailWithGh:_gh Success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [json objectForKey:@"data"];
            _empDetail = [EmpDetail empDetailWithDict:dict];
            [self.tableView reloadData];
        }
    } Fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍候再试"];
    }];
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
