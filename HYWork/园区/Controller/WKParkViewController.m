//
//  WKParkViewController.m
//  HYWork
//
//  Created by information on 2020/12/4.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKParkViewController.h"

@interface WKParkViewController ()

@end

@implementation WKParkViewController

- (void)viewDidLoad {
    self.desUrl = [H5URL stringByAppendingString:ParkLife];
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
