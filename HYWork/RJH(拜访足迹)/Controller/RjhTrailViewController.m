//
//  RjhTrailViewController.m
//  HYWork
//
//  Created by information on 2017/6/15.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhTrailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RjhAnnotation.h"
#import "RjhTrailTableCell.h"

@interface RjhTrailViewController () <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) MKMapView  *mapView;
@property (strong, nonatomic) MKPolyline *myPolyline;
@property (nonatomic, weak) UIButton  *locationBtn;
@property (nonatomic, weak) UITableView  *tableView;
@end

@implementation RjhTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 设置view的拓展 */
    [self setupViewConfig];
    
    /** 设置mapView*/
    [self setupMapView];
    
    /** 设置导航栏 */
    [self setupNavBar];
    
    /** 设置中文轨迹列表*/
    [self setupTableView];
}

/** 设置view的拓展 */
- (void)setupViewConfig {
    // 设置view不要延伸
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (NSString *)trailTitle {
    if (_trailTitle == nil) {
        _trailTitle = @"拜访轨迹";
    }
    return _trailTitle;
}

/** 设置导航栏 */
- (void)setupNavBar {
    /** 标题 */
    self.title = self.trailTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** 返回 */
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    /** 重定位 */
    UIButton *locationBtn = [[UIButton alloc] init];
    locationBtn.frame = CGRectMake(10, 10, 40, 40);
    locationBtn.backgroundColor = GQColor(250, 250, 250);
    locationBtn.layer.borderWidth = 1;
    locationBtn.layer.cornerRadius = 5;
    locationBtn.layer.borderColor = [GQColor(200, 200, 200) CGColor];
    [locationBtn addTarget:self action:@selector(relocation) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn setImage:[UIImage imageNamed:@"relocation"] forState:UIControlStateNormal];
    self.locationBtn = locationBtn;
    [self.view addSubview:locationBtn];
}

/** 重回 */
- (void)relocation {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

/** 返回 */
- (void)back {
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

/** 销毁 */
- (void)dealloc {
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
}

/** 初始化tableView */
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2 - NAV_BAR_HEIGHT);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trailArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RjhTrailTableCell *cell = [RjhTrailTableCell cellWithTableView:tableView];
    
    RjhTrail *trail = self.trailArray[indexPath.row];
    cell.trail = trail;
    
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = GQColor(229, 229, 229);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RjhTrail *trail = self.trailArray[indexPath.row];
    //设置地图的中心点
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(trail.signin_latitude, trail.signin_longitude);
    //设置地图的显示范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}

/** 设置mapView */
- (void)setupMapView {
    // 初始化mapView
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    mapView.delegate = self;
    self.mapView = mapView;
    [self.view addSubview:mapView];
    
    // 设置代理
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    // 设置大头针
    [self setAnnotationView];
    
    // 画轨迹
    [self setTrail];
    
    // 取出用户当前的经纬度
    if ([self.trailArray count] > 0) {
        RjhTrail *trail = [self.trailArray objectAtIndex:0];
        //设置地图的中心点
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(trail.signin_latitude, trail.signin_longitude);
        //设置地图的显示范围
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
    }
}



/** 添加大头针 */
- (void)setAnnotationView {
    int i = 0;
    for (RjhTrail *trail in self.trailArray) {
        i++;
        RjhAnnotation *anno = [[RjhAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(trail.signin_latitude, trail.signin_longitude);
        anno.title = [NSString stringWithFormat:@"[%d]时间:%@",i,trail.signin_time];
        anno.subtitle = [NSString stringWithFormat:@"地址:%@",trail.signin];
        [self.mapView addAnnotation:anno];
    }
}

- (void)setTrail{
    CLLocationCoordinate2D pointToUse[2];
    int total = (int)self.trailArray.count;
    for (NSInteger i = 0; i < total - 1; i++) {
        RjhTrail *fromTrail = self.trailArray[i];
        CLLocationCoordinate2D coordinate_from = CLLocationCoordinate2DMake(fromTrail.signin_latitude, fromTrail.signin_longitude);
        pointToUse[0] = coordinate_from;
        
        RjhTrail *toTrail = self.trailArray[i+1];
        CLLocationCoordinate2D coordinate_to = CLLocationCoordinate2DMake(toTrail.signin_latitude, toTrail.signin_longitude);
        pointToUse[1] = coordinate_to;
        
        self.myPolyline = [MKPolyline polylineWithCoordinates:pointToUse count:2];
        [self.mapView addOverlay:self.myPolyline];
    }
}

- (void)setTrailArray:(NSArray *)trailArray {
    _trailArray = trailArray;
}


#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (![annotation isKindOfClass:[RjhAnnotation class]]) return nil;
    
    static NSString *ID = @"rjhtrail";
    // 从缓存池中取出可以循环利用的大头针view
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示子标题和标题
        annoView.canShowCallout = YES;
    }
    return annoView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = GQColor(0, 146, 253);
    renderer.lineJoin = kCGLineJoinRound;
    renderer.lineCap = kCGLineCapRound;
    renderer.lineWidth = 5;
    return renderer;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.mapView removeFromSuperview];
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:self.locationBtn];
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
