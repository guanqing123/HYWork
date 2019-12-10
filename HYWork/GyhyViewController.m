//
//  GyhyViewController.m
//  HYWork
//
//  Created by information on 16/7/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "GyhyViewController.h"
#import "QygkViewController.h"
#import "QyryViewController.h"
#import "QyzzViewController.h"

@interface GyhyViewController ()
@property (weak, nonatomic) IBOutlet UIView *qygk;
@property (weak, nonatomic) IBOutlet UIView *qyry;
@property (weak, nonatomic) IBOutlet UIView *qyzz;

@end

@implementation GyhyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    NSArray *array = [NSArray arrayWithObjects:self.qygk,self.qyry,self.qyzz, nil];
    for (UIView *subView in array) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [subView addGestureRecognizer:tap];
    }
    
}

- (void)tapView:(UITapGestureRecognizer *)recognizer {
    switch (recognizer.view.tag) {
        case 1 : {
            QygkViewController *qygkVc = [[QygkViewController alloc] init];
            qygkVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:qygkVc animated:YES];
            break;
        }
        case 2 : {
            QyryViewController *qyryVc = [[QyryViewController alloc] init];
            qyryVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:qyryVc animated:YES];
            break;
        }
        case 3 : {
            QyzzViewController *qyzzVc = [[QyzzViewController alloc] init];
            qyzzVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:qyzzVc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
