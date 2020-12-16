//
//  WKKQViewController.m
//  HYWork
//
//  Created by information on 2020/6/18.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKKQViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKey.h"

@interface WKKQViewController ()

@end

@implementation WKKQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    //把地图添加至view
    [self.view addSubview:mapView];
    
    //开启室内地图
    mapView.showsIndoorMap = YES;
    //路况
    mapView.showTraffic = YES;
    
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
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
