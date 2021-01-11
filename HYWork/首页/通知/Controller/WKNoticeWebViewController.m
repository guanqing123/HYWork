//
//  WKNoticeWebViewController.m
//  HYWork
//
//  Created by information on 2021/1/11.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKNoticeWebViewController.h"

@interface WKNoticeWebViewController ()

@end

@implementation WKNoticeWebViewController

- (void)viewDidLoad {
    self.desUrl = [H5URL stringByAppendingFormat:@"/gnotice/gnotice.html"];
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
