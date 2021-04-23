//
//  WKKQViewController.m
//  HYWork
//
//  Created by information on 2020/6/18.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKKQViewController.h"

#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

// controller
#import "LoadViewController.h"

// view
#import "WKFirstTableViewCell.h"
#import "WKSecondTableViewCell.h"
#import "WKThirdTableViewCell.h"
#import "WKFouthTableViewCell.h"

// tool
#import "WKKQTool.h"
#import "KqManager.h"

// model
#import "WKKQBean.h"
#import "SFHFKeychainUtils.h"
#import "Utils.h"
#import "KqResData.h"
#import "Region.h"


@interface WKKQViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,AMapGeoFenceManagerDelegate,UIAlertViewDelegate>
// 地图
@property (nonatomic, strong) MAMapView *mapView;

// 定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

// 考勤点
@property (nonatomic, strong)  NSMutableArray *regions;

// 围栏点
@property (nonatomic, strong)  NSMutableArray *fences;

// tableView
@property (nonatomic, weak) UITableView  *tableView;

// model
@property (nonatomic, strong)  WKKQBean *kqBean;

// 手机设备
@property (nonatomic, copy) NSString *uuid;

// 考勤返回值
@property (nonatomic, strong)  KqResData *kqResData;

// 围栏管理
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@end

static NSString *const WKFirstTableViewCellID = @"WKFirstTableViewCell";
static NSString *const WKSecondTableViewCellID = @"WKSecondTableViewCell";
static NSString *const WKThirdTableViewCellID = @"WKThirdTableViewCell";
static NSString *const WKFouthTableViewCellID = @"WKFouthTableViewCell";

@implementation WKKQViewController

#pragma mark -loadView
- (void)loadView {
    [super loadView];
    // 1.初始化APIKey
    [self configureAPIKey];
    //2.初始化 mapView
    [self initMapView];
}

- (void)configureAPIKey {
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)initMapView {
    self.mapView.delegate = self;
}

- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] init];
    }
    return _mapView;
}

- (WKKQBean *)kqBean {
    if (_kqBean == nil) {
        WKKQBean *kqBean = [[WKKQBean alloc] init];
        kqBean.wzStr = @"正在定位...";
        kqBean.kqBtnStr = @"kqBtnN";
        kqBean.kqBtnClick = NO;
        kqBean.refreshBtnStr = @"shuaxindinweiH";
        kqBean.refreshBtnClick = NO;
        kqBean.loginName = [LoadViewController shareInstance].emp.ygxm;
        kqBean.signInTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"signInTime"];
        _kqBean = kqBean;
    }
    return _kqBean;
}

#pragma mark - 注册当app从后台进入前台的时候触发的事件
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoc) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 当view消失的时候 注销通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化定位
    [self configLocationManager];
    
    // 2.初始化围栏
    [self configGeoFenceManager];
    
    // 存放考勤点
    self.regions = [[NSMutableArray alloc] init];
    
    // 显示当前点
    self.mapView.showsUserLocation = YES;
    
    // 3.Nav & tableView
    [self setUp];
    
    // 4.date & time
    [self initDateAndTime];
}

// 1.初始化定位
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:YES];
    
    //设置精确定位
    if (@available(iOS 14.0, *)) {
        [self.locationManager setLocationAccuracyMode:AMapLocationFullAccuracy];
    }
}

//2.初始化地理围栏manager
- (void)configGeoFenceManager {
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    //self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //进入，离开，停留都要进行通知
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside;
    self.geoFenceManager.allowsBackgroundLocationUpdates = NO;  //允许后台定位
}

// 3.Nav & TableView
- (void)setUp {
    // Nav
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(returnAction)];
    
    // TableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKFirstTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKFirstTableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKSecondTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKSecondTableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKThirdTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKThirdTableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKFouthTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKFouthTableViewCellID];
}

- (void)returnAction {
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cusCell = [UITableViewCell new];
    if (indexPath.row == 0) {
        WKFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKFirstTableViewCellID forIndexPath:indexPath];
        cell.kqBean = self.kqBean;
        cusCell = cell;
    }else if (indexPath.row == 1) {
        WKSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKSecondTableViewCellID forIndexPath:indexPath];
        cell.kqBean = self.kqBean;
        cusCell = cell;
    }else if (indexPath.row == 2) {
        WKThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKThirdTableViewCellID forIndexPath:indexPath];
        [cell.contentView addSubview:self.mapView];
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(40, 15, 30, 15));
        }];
        cell.kqBean = self.kqBean;
        WEAKSELF
        cell.updateLocBlock = ^{
            [weakSelf updateLoc];
        };
        cusCell = cell;
    }else if (indexPath.row == 3) {
        WKFouthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKFouthTableViewCellID forIndexPath:indexPath];
        cell.kqBean = self.kqBean;
        WEAKSELF
        cell.signInBlock = ^{
            [weakSelf signIn];
        };
        cusCell = cell;
    }
    return cusCell;
}

- (void)signIn {
    NSDictionary *uuid = @{@"device":self.uuid};
    if ((_kqResData.devices.count < 2) && ![_kqResData.devices containsObject:uuid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的手机第一次考勤需要绑定,确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    if ((_kqResData.devices.count <= 2) && [_kqResData.devices containsObject:uuid]) {
        [self kqAction:@"false"];
    }
    if ((_kqResData.devices.count == 2) && ![_kqResData.devices containsObject:uuid]) {
        [SVProgressHUD showErrorWithStatus:@"此手机未绑定,无法考勤"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)return;
    [self kqAction:@"true"];
}

#pragma mark - 考勤功能
- (void)kqAction:(NSString *)sign {
    [SVProgressHUD showInfoWithStatus:@"考勤中..."];
    WEAKSELF
    [KqManager postJsonWithDid:self.uuid gh:[LoadViewController shareInstance].emp.ygbm sign:sign success:^(id json) {
        [SVProgressHUD dismiss];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            NSString *error = [NSString stringWithFormat:@"%@ %@",[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]],[header objectForKey:@"errormsg"]];
            [SVProgressHUD showErrorWithStatus:error];
        }else{
            [SVProgressHUD dismiss];
            NSDictionary *dict = [json objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                weakSelf.kqBean.count = [dict[@"checkInTimes"] intValue];
                weakSelf.kqResData.devices = dict[@"devices"];
                NSDictionary *header = [json objectForKey:@"header"];
                
                // 方便下次读取
                [[NSUserDefaults standardUserDefaults] setObject:header[@"trdate"] forKey:@"signInTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 打开时间
                weakSelf.kqBean.signInTime = header[@"trdate"];
                [self.tableView reloadData];
            }
        }
    } fail:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"考勤异常,稍后再试"];
    }];
}

- (void)updateLoc {
    self.kqBean.refreshBtnStr = @"shuaxindinweiH";
    self.kqBean.refreshBtnClick = NO;
    self.kqBean.wzStr = @"正在定位...";
    self.kqBean.kqBtnStr = @"kqBtnN";
    self.kqBean.kqBtnClick = NO;
    [self.tableView reloadData];
    if (self.regions.count > 0) {
        [self refreshLocation];
    }else{
        [self getCurrentLocation];
    }
}

- (void)refreshLocation {
    [SVProgressHUD show];
    WEAKSELF
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
//                NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            [SVProgressHUD dismiss];
            weakSelf.kqBean.wzStr = error.localizedDescription;
            weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
            weakSelf.kqBean.refreshBtnClick = YES;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
            [SVProgressHUD dismiss];
            weakSelf.kqBean.wzStr = error.localizedDescription;
            weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
            weakSelf.kqBean.refreshBtnClick = YES;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.mapView setVisibleMapRect:[MACircle circleWithCenterCoordinate:location.coordinate radius:250].boundingMapRect];
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            //NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
            
            //存在虚拟定位的风险的定位结果
            //__unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
            //存在外接的辅助定位设备
            //__unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
            [SVProgressHUD dismiss];
            weakSelf.kqBean.wzStr = error.localizedDescription;
            weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
            weakSelf.kqBean.refreshBtnClick = YES;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            //上报虚拟定位
            NSDictionary *vlDict = @{
                @"ygbm": [LoadViewController shareInstance].emp.ygbm,
                @"deviceId": self.uuid,
                @"message": [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:error.userInfo options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding]
            };
            [WKKQTool postVirtualLocation:vlDict success:^(id  _Nonnull json) {} failure:^(NSError * _Nonnull error) {}];
            
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
            weakSelf.kqBean.wzStr = regeocode.formattedAddress;
            weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
            weakSelf.kqBean.refreshBtnClick = YES;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            // 可视区
            [weakSelf.mapView setVisibleMapRect:[MACircle circleWithCenterCoordinate:location.coordinate radius:250].boundingMapRect];
            
            for (Region *region in self.regions) {
                if (MACircleContainsCoordinate(location.coordinate, CLLocationCoordinate2DMake(region.latitude, region.longitude), region.radius)) {
                    weakSelf.kqBean.kqBtnStr = @"kqBtnH";
                    weakSelf.kqBean.kqBtnClick = YES;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                }
            }
            
            [SVProgressHUD dismiss];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80.0f;
    }else if (indexPath.row == 1){
        return 60.0f;
    }else if (indexPath.row == 2){
        return 270.0f;
    }else{
        return MAX(self.view.dc_height - 80 - 60 - 270 - HWTopNavH, 120);
    }
}

// 3.初始化日期 时间
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
    self.kqBean.date = [NSString stringWithFormat:@"%@: %ld.%02ld.%02ld",[arrWeek objectAtIndex:week - 1],year,month,day];
    self.kqBean.time = [NSString stringWithFormat:@"当前时间: %02ld:%02ld",hour,minute];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 获取定位
    [self getCurrentLocation];
}

- (void)getCurrentLocation {
    [SVProgressHUD show];
    WEAKSELF
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error != nil && error.code == AMapLocationErrorLocateFailed)
            {
                //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
//                NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
                [SVProgressHUD dismiss];
                weakSelf.kqBean.wzStr = error.localizedDescription;
                weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
                weakSelf.kqBean.refreshBtnClick = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                return;
            }
            else if (error != nil
                     && (error.code == AMapLocationErrorReGeocodeFailed
                         || error.code == AMapLocationErrorTimeOut
                         || error.code == AMapLocationErrorCannotFindHost
                         || error.code == AMapLocationErrorBadURL
                         || error.code == AMapLocationErrorNotConnectedToInternet
                         || error.code == AMapLocationErrorCannotConnectToHost))
            {
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
                [SVProgressHUD dismiss];
                weakSelf.kqBean.wzStr = error.localizedDescription;
                weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
                weakSelf.kqBean.refreshBtnClick = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.mapView setVisibleMapRect:[MACircle circleWithCenterCoordinate:location.coordinate radius:250].boundingMapRect];
            }
            else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
            {
                //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
                //NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
                
                //存在虚拟定位的风险的定位结果
                //__unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
                //存在外接的辅助定位设备
                //__unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
                [SVProgressHUD dismiss];
                weakSelf.kqBean.wzStr = error.localizedDescription;
                weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
                weakSelf.kqBean.refreshBtnClick = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
                //上报虚拟定位
                NSDictionary *vlDict = @{
                    @"ygbm": [LoadViewController shareInstance].emp.ygbm,
                    @"deviceId": self.uuid,
                    @"message": [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:error.userInfo options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding]
                };
                [WKKQTool postVirtualLocation:vlDict success:^(id  _Nonnull json) {} failure:^(NSError * _Nonnull error) {}];
                
                return;
            }
            else
            {
                //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                weakSelf.kqBean.wzStr = regeocode.formattedAddress;
                weakSelf.kqBean.refreshBtnStr = @"shuaxindinweiN";
                weakSelf.kqBean.refreshBtnClick = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
                //加载围栏
                [weakSelf loadFences:location regeocode:regeocode];
            }
    }];
}

- (NSString *)uuid {
    if (_uuid == nil) {
        NSString *SERVICE_NAME = @"com.hongyan.HYWork";
        NSString *str = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];
        if ([str length] <= 0) {
            str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [SFHFKeychainUtils storeUsername:@"UUID" andPassword:str forServiceName:SERVICE_NAME updateExisting:1 error:nil];
        }
        _uuid = str;
    }
    return _uuid;
}

- (void)loadFences:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode {
    WEAKSELF
    [KqManager postJsonWithCityCode:regeocode.citycode gh:[LoadViewController shareInstance].emp.ygbm success:^(id json) {
        [SVProgressHUD dismiss];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [SVProgressHUD showErrorWithStatus:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            NSDictionary *dict = [json objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                KqResData *kqResData = [KqResData kqResDataWithDict:dict];
                weakSelf.kqResData = kqResData;
                [weakSelf addGeoFenceCircleRegion:location];
                self.kqBean.count = kqResData.checkInTimes;
                //局部刷新
                [self.tableView reloadData];
            }
            
            // 可视区
            [weakSelf.mapView setVisibleMapRect:[MACircle circleWithCenterCoordinate:location.coordinate radius:250].boundingMapRect];
        }
    } fail:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求异常,请刷新再试"];
    }];
}

// 添加围栏
- (void)addGeoFenceCircleRegion:(CLLocation *)location {
    [self doClear];
    for (Region *region in self.kqResData.regions) {
        // 圆心
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(region.latitude, region.longitude);
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:region.radius customID:[NSString stringWithFormat:@"%d",region.fenceid]];
        
        // 考勤点
        [self.regions addObject:region];
        
        //判断当前定位是否在圆内,因为第一次进来无法调用delegate判断定位是否在圆内
        if (MACircleContainsCoordinate(location.coordinate, coordinate, region.radius)){
            self.kqBean.kqBtnStr = @"kqBtnH";
            self.kqBean.kqBtnClick = YES;
            // 局部刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)doClear{
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
}

// 围栏代理
#pragma mark - AMapGeoFenceManagerDelegate Delegate
// 申请临时精确定位回调
- (void)amapLocationManager:(AMapGeoFenceManager *)manager doRequireTemporaryFullAccuracyAuth:(CLLocationManager *)locationManager completion:(void (^)(NSError *))completion {
    if (@available(iOS 14.0, *)) {
        [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"AMapLocationScene" completion:^(NSError * _Nullable error) {
            if (completion) {
                completion(error);
            }
        }];
    }
}

// 围栏创建成功,再添加图形
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        AMapGeoFenceCircleRegion *circleRegion = (AMapGeoFenceCircleRegion *)regions.firstObject;
        MACircle *circleOverlay = [MACircle circleWithCenterCoordinate:circleRegion.center radius:circleRegion.radius];
        [self.mapView addOverlay:circleOverlay];
    }
}

//地理围栏状态改变时回调，当围栏状态的值发生改变，定位失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed %@",[region description]);
        NSString *status = @"unknown";
        switch (region.fenceStatus) {
            case AMapGeoFenceRegionStatusInside: {
                status = @"Inside";
                if ([self.fences count] >= [self.regions count]) {
                    self.kqBean.kqBtnStr = @"kqBtnH";
                    self.kqBean.kqBtnClick = YES;
                    // 局部刷新
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            }
            case AMapGeoFenceRegionStatusOutside: {
                status = @"Outside";
                if ([self.fences count] >= [self.regions count]) {
                    self.kqBean.kqBtnStr = @"kqBtnN";
                    self.kqBean.kqBtnClick = NO;
                    // 局部刷新
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            }
            default:
                break;
        }
        [self.fences addObject:customID];
    }
}

- (NSMutableArray *)fences {
    if (!_fences) {
        _fences = [NSMutableArray array];
    }
    return _fences;
}

// mapView 代理
#pragma mark - MAMapViewDelegate
// 图形样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:(MAPolygon *)overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];
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
        if ((point.x <=0 || point.y <=0 || point.x >=size.width || point.y >=size.height) && self.kqBean.refreshBtnClick) {
            MACircle *visiable = [MACircle circleWithCenterCoordinate:userLocation.coordinate radius:250];
            [self.mapView setVisibleMapRect:visiable.boundingMapRect];
        }
    }
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
