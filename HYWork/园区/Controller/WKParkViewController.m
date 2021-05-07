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
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[close, flex, refresh];
}

- (void)refresh {
    [super reload];
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
