//
//  WKAfterSaleViewController.m
//  HYWork
//
//  Created by information on 2020/12/3.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKAfterSaleViewController.h"

@interface WKAfterSaleViewController ()

@end

@implementation WKAfterSaleViewController

- (void)viewDidLoad {
    // 初始化访问地址
    self.desUrl = [H5URL stringByAppendingString:AfterSale];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
