//
//  KqViewController.m
//  HYWork
//
//  Created by information on 16/3/30.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "KqViewController.h"
#import "APIKey.h"
#import "KqViewCell.h"
#import "KqBtnCell.h"
#import "MBProgressHUD+MJ.h"
#import "KqManager.h"
#import "KqResData.h"
#import "Region.h"
#import "SFHFKeychainUtils.h"
#import "LoadViewController.h"
#import "Utils.h"

@interface KqViewController () <UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,kqViewCellDelegate,kqBtnCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) MAMapView  *mapView;

@property (nonatomic, strong)  NSMutableArray *regions;

@property (nonatomic, strong)  AMapLocationManager *locationManager;

@property (nonatomic, copy) NSString *wzStr;

@property (nonatomic, assign) CGRect *frame;

@property (nonatomic, strong)  KqResData *kqResData;

//@property (nonatomic, strong)  MBProgressHUD *progressHUD;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, strong)  UIAlertView *alert;

/**
 *  考勤按钮
 */
@property (nonatomic, copy) NSString *imgName;
/**
 *  考勤按钮状态
 */
@property (nonatomic, assign) BOOL kqClick;

/**
 * 地址按钮状态
 */
@property (nonatomic, assign) BOOL click;
/**
 * 更新地址按钮
 */
@property (nonatomic, copy) NSString *btnImg;

@property (nonatomic, assign) int count;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *time;

@end

@implementation KqViewController
@synthesize mapView = _mapView;

#pragma mark loadView
- (void)loadView {
    [super loadView];
    //1.初始化APIKey
    [self configureAPIKey];
    //2.初始化 mapView
    [self initMapView];
    //3.初始化数据
    [self initData];
}

- (void)initData {
    _wzStr = @"正在定位...";
    _imgName = @"kqBtnN";
    _kqClick = NO;
    _click = NO;
    _btnImg = @"shuaxindinweiH";
}

- (void)configureAPIKey {
//    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
//    [AMapLocationServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] init];
    }
    return _mapView;
}

- (void)initMapView {
    self.mapView.delegate = self;
}


#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLocationManager];
    
    self.regions = [[NSMutableArray alloc] init];
    
    self.mapView.showsUserLocation = YES;
    
    [self setUp];
    
    [self initDateAndTime];
}

#pragma mark - 注册当app从后台进入前台的时候触发的事件
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appWillEnterForegroundNotification {
    [self initDateAndTime];
    [self initData];
    [self.tableView reloadData];
    [self refreshLocationWithLocationManagerWhenAppActive:self.locationManager];
}

#pragma mark - 当view消失的时候 注销通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getCurrentLocation];
}

- (void)getCurrentLocation {
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [weakSelf didSomeThingWithReGeocode:regeocode Error:error];
        [weakSelf addCircleReionForCoordinate:location.coordinate Regeocode:regeocode NSError:error];
    }];
}

- (void)didSomeThingWithReGeocode:(AMapLocationReGeocode *)regeocode Error:(NSError *)error{
    if (error) {
        _wzStr = @"网络连接异常...";
    }else{
        _wzStr = regeocode.formattedAddress;
    }
    _btnImg = @"shuaxindinweiN";
    _click = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addCircleReionForCoordinate:(CLLocationCoordinate2D)coordinate Regeocode:(AMapLocationReGeocode *)regeocode NSError:(NSError *)error {
    if (!error) {
            [KqManager postJsonWithCityCode:regeocode.citycode gh:[LoadViewController shareInstance].emp.ygbm success:^(id json) {
                NSDictionary *header = [json objectForKey:@"header"];
                if ([[header objectForKey:@"succflag"] intValue] > 1) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
                }else{
                    NSDictionary *dict = [json objectForKey:@"data"];
                    if (![dict isKindOfClass:[NSNull class]]) {
                        KqResData *kqResData = [KqResData kqResDataWithDict:dict];
                        _kqResData = kqResData;
                        for (Region *region in kqResData.regions) {
                            [self circleWithLatitude:region.latitude longitude:region.longitude radius:region.radius identifier:[NSString stringWithFormat:@"%d",region.fenceid]];
                        }
                        _count = kqResData.checkInTimes;
                        //局部刷新
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                [self setVisiableMapRect:coordinate];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        } fail:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常,请刷新重试"];
        }];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)circleWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CGFloat)radius identifier:(NSString *)identifier {
    //1.确定圆心
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    //2.创建围栏
    AMapLocationCircleRegion *circleRegion = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate radius:radius identifier:identifier];
    //3.添加地理围栏
    [self.locationManager startMonitoringForRegion:circleRegion];
    //4.保存地理围栏
    [self.regions addObject:circleRegion];
    //5.添加Overlay
    MACircle *circle = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapView addOverlay:circle];
}

- (void)setVisiableMapRect:(CLLocationCoordinate2D)coordinate {
    
    MACircle *visiable = [MACircle circleWithCenterCoordinate:coordinate radius:250];
    [self.mapView setVisibleMapRect:visiable.boundingMapRect];
    
    //指北针
    //self.mapView.compassOrigin = CGPointMake(10, 10);
    
    for (AMapLocationCircleRegion *region in self.regions) {
        if ([region containsCoordinate:coordinate]) {
            _imgName = @"kqBtnH";
            _kqClick = YES;
            //局部刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region {
    _imgName = @"kqBtnH";
    _kqClick = YES;
    //刷新按钮
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self refreshLocationWithLocationManager:manager];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region {
    _imgName = @"kqBtnN";
    _kqClick = NO;
    //刷新按钮
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self refreshLocationWithLocationManager:manager];
}

#pragma mark - 封装进入和离开监控区域
- (void)refreshLocationWithLocationManager:(AMapLocationManager *)manager {
    __weak typeof(self) weakSelf = self;
    [manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [weakSelf didSomeThingWithReGeocode:regeocode Error:error];
        MACircle *circle = [MACircle circleWithCenterCoordinate:location.coordinate radius:250];
        [weakSelf.mapView setVisibleMapRect:circle.boundingMapRect];
    }];
}

#pragma mark - 封装进入和离开监控区域(重构) 因为后台进入前台要进行判断当前点是不是在圈内
- (void)refreshLocationWithLocationManagerWhenAppActive:(AMapLocationManager *)manager {
    [MBProgressHUD showMessage:@"刷新中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf didSomeThingWithReGeocode:regeocode Error:error];
        [weakSelf setVisiableMapRect:location.coordinate];
    }];
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 5.0f;
        circleRenderer.strokeColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:0.6];
        circleRenderer.fillColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0 alpha:0.6];
        return circleRenderer;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        CGSize size = self.mapView.frame.size;
        CGPoint point = [self.mapView convertCoordinate:userLocation.coordinate toPointToView:self.mapView];
        if ((point.x <=0 || point.y <=0 || point.x >=size.width || point.y >=size.height) && _click) {
            MACircle *visiable = [MACircle circleWithCenterCoordinate:userLocation.coordinate radius:250];
            [self.mapView setVisibleMapRect:visiable.boundingMapRect];
        }
    }
}

#pragma mark - 初始化 locationManager
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    // 设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];

    // 设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // 设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
}

#pragma mark - 初始化 导航 tableView
- (void)setUp {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(returnAction)];
    self.navigationItem.leftBarButtonItem = left;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark - 初始化日期 时间
- (void)initDateAndTime {
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    long week = [comps weekday];
    long year=[comps year];
    long month = [comps month];
    long day = [comps day];
    long hour = [comps hour];
    long  minute = [comps minute];
    _date = [NSString stringWithFormat:@"%@: %ld.%02ld.%02ld",[arrWeek objectAtIndex:week - 1],year,month,day];
    _time = [NSString stringWithFormat:@"当前时间: %02ld:%02ld",hour,minute];
}

#pragma mark - 页面退回 释放资源
- (void)returnAction {
    [self.regions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.locationManager stopMonitoringForRegion:(AMapLocationRegion *)obj];
    }];
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width;
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        imgView.image = [UIImage imageNamed:@"zaixiankaoqino"];
        [cell.contentView addSubview:imgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, 100, 30)];
        nameLabel.text = [LoadViewController shareInstance].emp.ygxm;
        nameLabel.font = [UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 40, width - 110, 25)];
        descLabel.text = [NSString stringWithFormat:@"今日您已完成签到 %d 次", _count];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:0.8];
        [cell.contentView addSubview:descLabel];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 79, self.view.frame.size.width - 30, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8];
        [cell.contentView addSubview:view];
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *xqView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
        xqView.image = [UIImage imageNamed:@"rili"];
        [cell.contentView addSubview:xqView];
        
        UILabel *xqLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, width / 2 - 20, 20)];
        xqLabel.text = _date;
        xqLabel.font = [UIFont systemFontOfSize:14];
        xqLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        [cell.contentView addSubview:xqLabel];
        
        UIImageView *sjView = [[UIImageView alloc] initWithFrame:CGRectMake(width -145, 20, 20, 20)];
        sjView.image = [UIImage imageNamed:@"shijian"];
        [cell.contentView addSubview:sjView];
        
        UILabel *sjLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 125, 20, 110, 20)];
        sjLabel.text = _time;
        sjLabel.textAlignment = NSTextAlignmentRight;
        sjLabel.font = [UIFont systemFontOfSize:14];
        sjLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        [cell.contentView addSubview:sjLabel];
        return cell;
    }
    else if (indexPath.row == 2) {
        KqViewCell *cell = [KqViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBtnImg:_btnImg andClick:_click];
        cell.mapView = self.mapView;
        [cell.contentView addSubview:self.mapView];
        cell.wz = _wzStr;
        return cell;
    }
    else if (indexPath.row == 3) {
        KqBtnCell *cell = [KqBtnCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBtnImg:_imgName andClick:_kqClick];
        return cell;
    }
    return nil;
}

#pragma mark - kqViewCellDelegate
- (void)kqViewCellBtnClickToRefreshLocation:(KqViewCell *)kqViewCell {
    _btnImg = @"shuaxindinweiH";
    _click = NO;
    _wzStr = @"正在定位...";
    [kqViewCell setBtnImg:@"shuaxindinweiH" andClick:NO];
    kqViewCell.wz = @"正在定位...";
    if (self.regions.count > 0) {
        [self refreshLocationWithLocationManager:self.locationManager];
    }else{
        [self getCurrentLocation];
    }
}

/**
 *  屏幕截图
 */
- (void)jietu {
    [self.mapView takeSnapshotInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withCompletionBlock:^(UIImage *resultImage, NSInteger state){
        NSData *imageData = UIImagePNGRepresentation(resultImage);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *saveImagePath = [documentDirectory stringByAppendingPathComponent:@"saveFore1.png"];
        [imageData writeToFile:saveImagePath atomically:YES];
    }];
}

#pragma mark - UUID
- (NSString *)uuid {
    NSString *SERVICE_NAME = @"com.hongyan.HYWork";
    NSString *str = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];
    if ([str length] <= 0) {
        str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SFHFKeychainUtils storeUsername:@"UUID" andPassword:str forServiceName:SERVICE_NAME updateExisting:1 error:nil];
    }
    return str;
}

#pragma mark - kqBtnCellDelegate
- (void)kqBtnCellDelegateClickToKaoQin:(KqBtnCell *)kqBtnCell {
    [kqBtnCell setBtnImg:@"kqBtnN" andClick:NO];
    NSDictionary *uuid = @{@"device":self.uuid};
    if ((_kqResData.devices.count < 2) && ![_kqResData.devices containsObject:uuid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的手机第一次考勤需要绑定,确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alert = alert;
        [alert show];
    }
    if ((_kqResData.devices.count <= 2) && [_kqResData.devices containsObject:uuid]) {
        [self kqAction:@"false"];
    }
    if ((_kqResData.devices.count == 2) && ![_kqResData.devices containsObject:uuid]) {
        [MBProgressHUD showError:@"此手机未绑定,无法考勤"];
    }
    [kqBtnCell setBtnImg:@"kqBtnH" andClick:YES];
}


#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)return;
    [self kqAction:@"true"];
}

#pragma mark - 考勤功能
- (void)kqAction:(NSString *)sign {
    [MBProgressHUD showMessage:@"考勤中..." toView:self.view];
    [KqManager postJsonWithDid:self.uuid gh:[LoadViewController shareInstance].emp.ygbm sign:sign success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *error = [NSString stringWithFormat:@"%@ %@",[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]],[header objectForKey:@"errormsg"]];
            [MBProgressHUD showError:error];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [json objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                _count = [dict[@"checkInTimes"] intValue];
                _kqResData.devices = dict[@"devices"];
                NSDictionary *header = [json objectForKey:@"header"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"考勤时间:%@",header[@"trdate"]] toView:self.view];
            }
        }
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍后再试"];
    }];
}


#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80.0f;
    }else if (indexPath.row == 1) {
        return 60.0f;
    }else if (indexPath.row == 2) {
        return 230.0f;
    }else{
        return self.view.frame.size.height - 370.0f - 64.0f;
    }
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
