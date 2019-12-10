//
//  YwjbViewController.m
//  HYWork
//
//  Created by information on 2017/6/16.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "YwjbViewController.h"

@interface YwjbViewController ()

@end

@implementation YwjbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = self.view.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在开发中...";
    [self.view addSubview:label];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
