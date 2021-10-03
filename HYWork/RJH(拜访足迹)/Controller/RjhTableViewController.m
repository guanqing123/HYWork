//
//  RjhTableViewController.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//
#define headerViewHeight 44

#import "RjhTableViewController.h"
#import "RjhHeaderView.h"
#import "NSObject+Extension.h"
#import "MJRefresh.h"
#import "RjhTableCell.h"
#import "RjhPlan.h"
#import "Photo.h"
#import "RjhPlanFrame.h"
#import "AddButton.h"
#import "CustomActionSheet.h"
#import "RjhWritePlanViewController.h"
#import "RjhSignInTableViewController.h"
#import "RjhPhotoCollectionViewController.h"
#import "RjhCommentViewController.h"
#import "RjhTrailViewController.h"
#import "RjhManager.h"
#import "LoadViewController.h"
#import "MJExtension.h"
#import "ZjxsCheckView.h"
#import "Utils.h"
#import "NavigationController.h"
#import "ZJXS.h"
#import "RjhRemark.h"
#import "RjhTrail.h"
#import "WKBrowseViewController.h"
#import "LYConstans.h"

@interface RjhTableViewController () <UITableViewDataSource,UITableViewDelegate,RjhHeaderViewDelegate,CustomActionSheetDelagate,RjhTableCellDelegate,RjhPhotoCollectionViewControllerDelegate,UIAlertViewDelegate,RjhWritePlanViewControllerDelegate,ZjxsCheckViewDelegate,RjhCommentViewControllerDelegate>
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, strong)  NSMutableArray *planFrame;
@property (nonatomic, copy) NSString *deleteId;

@property (nonatomic, copy) NSString *ygbm;
@property (nonatomic, copy) NSString *current;
@property (nonatomic, strong) ZjxsCheckView  *zjxsView;
@property (assign, nonatomic) BOOL isAppeared;
@property (nonatomic, strong)  NSArray *zjxs;

@property (nonatomic, strong)  RjhRemark *deleteRemark;

/** 轨迹数组 */
@property (nonatomic, strong)  NSArray *trailArray;
/** 轨迹标题 */
@property (nonatomic, copy) NSString *trailTitle;
@end

@implementation RjhTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置导航栏的内容
    [self setupNavBar];
    
    // 2.初始化tableView
    [self setupTableView];
    
    // 3.初始化首行条件view
    [self setupTitleView];
    
    // 4.初始化右下角+号按钮
    [self setupAddButton];
    
    // 5.加载组织关系
    [self loadZjgx];
    
    // 6.其他参数初始化
    _isAppeared = NO;
    _current = self.ygbm;
}

/** 5.加载组织关系 */
#pragma mark - 加载组织关系
- (void)loadZjgx {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gh"] = self.ygbm;
    [RjhManager getZjgxWithParams:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            NSDictionary *data = [json objectForKey:@"data"];
            self.zjxs = [ZJXS mj_objectArrayWithKeyValuesArray:[data objectForKey:@"zjxs"]];
        }
    } failure:^{
        [MBProgressHUD showError:@"获取下属失败"];
    }];
}

- (NSString *)ygbm {
    if (_ygbm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygbm = loadVc.emp.ygbm;
    }
    return _ygbm;
}

- (NSString *)current {
    if (_current == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _current = loadVc.emp.ygbm;
    }
    return _current;
}

/** 初始化右下角+号按钮 */
#pragma mark - 初始化右下角+号按钮
- (void)setupAddButton {
    CGFloat  addButtonW = 60;
    CGFloat  addButtonH = 60;
    CGFloat  addButtonX = SCREEN_WIDTH - addButtonW - 15;
    CGFloat  addButtonY = SCREEN_HEIGHT - addButtonH - NAV_BAR_HEIGHT - 15;
    AddButton *addButton = [[AddButton alloc] initWithFrame:CGRectMake(addButtonX, addButtonY, addButtonW, addButtonH)]; //把按钮设置成正方形
    addButton.backgroundColor = GQColor(222, 222, 222);
    addButton.layer.cornerRadius = addButtonW / 2; //设置按钮的拐角为宽的一半
    addButton.layer.borderWidth = 0.5; // 边框的宽
    addButton.layer.borderColor = [UIColor whiteColor].CGColor; // 边框的颜色
    addButton.layer.masksToBounds = YES; // 这个属性很重要,把超出边框的部分去除
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchDown];
    [addButton setImage:[UIImage imageNamed:@"tianjia_128"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
}

/** 点击+号按钮 */
- (void)addButtonClick {
    /** 非本尊不能点加号 */
    if (![self.ygbm isEqualToString:self.current]) {
        return;
    }
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"请选择操作" otherButtonTitles:@[@"拜访轨迹",@"快速签到"]];
    sheet.delegate = self;
    [sheet show];
}

/** CustomActionSheetDelagate */
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self writePlan];
            break;
        }
        case 1: {
            [self signIn];
            break;
        }
        default:
            break;
    }
}

/** 写日计划 */
- (void)writePlan {
    RjhPlan *plan = [self getPlan];
    RjhWritePlanViewController *writePlan = [[RjhWritePlanViewController alloc] init];
    writePlan.delegate = self;
    writePlan.plan = plan;
    writePlan.zjxs = self.zjxs;
    [self.navigationController pushViewController:writePlan animated:YES];
}

/** 初始化plan */
- (RjhPlan *)getPlan{
    RjhPlan *plan = [[RjhPlan alloc] init];
    NSArray *dateAndTime = [RjhTableViewController getCurrentDateAndTime];
    //plan.logdate = [dateAndTime objectAtIndex:0];
    plan.logdate = self.currentDate;
    plan.logtime = [dateAndTime objectAtIndex:1];
    //plan.type = PlanTypeVisitBpc;
    plan.kh_lb = BpcTypePotential;
    plan.logid = @"0";
    plan.userid = [LoadViewController shareInstance].emp.ygbm;
    return plan;
}

/** 日志写完刷新日志列表 RjhWritePlanViewControllerDelegate */
- (void)rjhWritePlanViewControllerSavePlan:(RjhWritePlanViewController *)writePlanVc {
    [self.tableView.mj_header beginRefreshing];
}

/** 考勤 */
- (void)signIn {
    RjhSignInTableViewController *signIn = [[RjhSignInTableViewController alloc] initWithPlan:[self getPlan]];
    [self.navigationController pushViewController:signIn animated:YES];
}

/** 考勤完成之后刷新页面 */
#pragma mark RjhSignInTableViewControllerDelegate
- (void)signInTableViewDidClickSignInBtn:(RjhSignInTableViewController *)signInTableView {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,headerViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - headerViewHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.tableView.backgroundColor = GQColor(226, 226, 226);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + 15 + RjhPlanTableBorder, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (NSMutableArray *)planFrame {
    if (_planFrame == nil) {
        _planFrame = [NSMutableArray array];
    }
    return _planFrame;
}

- (void)setData {
    RjhPlanFrame *planFram = [[RjhPlanFrame alloc] init];
    RjhPlan *plan = [[RjhPlan alloc] init];
    plan.logid = @"000001";
    plan.userid = @"06407";
    plan.title = @"习近平一带一路论坛讲话十大高频词";
    plan.content = @"孟夏之日，万物并秀。“一带一路”国际合作高峰论坛成果丰硕，中国国家主席习近平在高峰论坛上的系列讲话传向世界各地。本文通过综合梳理习近平在开幕式上的演讲、欢迎宴会上的祝酒辞，以及论坛圆桌峰会上的开幕辞、闭幕辞，梳理出十大高频词，带您一一解读。";
    plan.logdate = @"2017-04-20";
    plan.logtime = @"09:26";
    plan.allday = 0;
    plan.type = PlanTypeVisitBpc;
    plan.logid = @"#FFFFFF";
    plan.khdm = @"00000000";
    plan.khmc = @"杭州鸿雁电器有限公司";
    plan.khdz = @"五常大道138号";
    plan.khdz_longitude = @"108.10";
    plan.khdz_latitude = @"99.08";
    plan.kh_lxr = @"官青";
    plan.kh_lxdh = @"15857125375";
    plan.signin = @"五常大道138号鸿雁电器产业园";
    plan.signin_longitude = @"105.1";
    plan.signin_latitude = @"102";
    plan.signin_time = @"17:42";
    plan.imageid = @"1,2,3";
    
    Photo *p1 = [[Photo alloc] init];
    p1.url = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    p1.surl = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    NSArray *imagesurl = [NSArray arrayWithObjects:p1,nil];
    plan.imagesurl = imagesurl;
    planFram.plan = plan;
    [self.planFrame addObject:planFram];
}

- (void)setData1 {
    RjhPlanFrame *planFram = [[RjhPlanFrame alloc] init];
    RjhPlan *plan = [[RjhPlan alloc] init];
    plan.logid = @"000001";
    plan.userid = @"06407";
    plan.title = @"习近平一带一路论坛讲话十大高频词";
    plan.content = @"孟夏之日，万物并秀。“一带一路”国际合作高峰论坛成果丰硕，中国国家主席习近平在高峰论坛上的系列讲话传向世界各地。本文通过综合梳理习近平在开幕式上的演讲、欢迎宴会上的祝酒辞，以及论坛圆桌峰会上的开幕辞、闭幕辞，梳理出十大高频词，带您一一解读。";
    plan.logdate = @"2017-04-20";
    plan.logtime = @"13:26";
    plan.allday = 0;
    plan.type = PlanTypeImportantWork;
    plan.khdm = @"00000000";
    plan.khmc = @"杭州鸿雁电器有限公司";
    plan.khdz = @"五常大道138号";
    plan.khdz_longitude = @"108.10";
    plan.khdz_latitude = @"99.08";
    plan.kh_lxr = @"官青";
    plan.kh_lxdh = @"15857125375";
    plan.signin = @"五常大道138号鸿雁电器产业园";
    plan.signin_longitude = @"105.1";
    plan.signin_latitude = @"102";
    plan.signin_time = @"17:42";
    plan.imageid = @"1,2,3";
    
    Photo *p1 = [[Photo alloc] init];
    p1.url = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    p1.surl = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    Photo *p2 = [[Photo alloc] init];
    p2.url = @"http://img2.91.com/uploads/allimg/130521/32-130521154S3.jpg";
    p2.surl = @"http://img2.91.com/uploads/allimg/130521/32-130521154S3.jpg";
    Photo *p3 = [[Photo alloc] init];
    p3.url = @"http://d.5857.com/6yfj_130601/010.jpg";
    p3.surl = @"http://d.5857.com/6yfj_130601/010.jpg";
    Photo *p4 = [[Photo alloc] init];
    p4.url = @"http://abc.2008php.com/2011_Website_appreciate/2011-09-12/20110912104833.jpg";
    p4.surl = @"http://abc.2008php.com/2011_Website_appreciate/2011-09-12/20110912104833.jpg";
    NSArray *imagesurl = [NSArray arrayWithObjects:p1,p2,p3,p4,nil];
    plan.imagesurl = imagesurl;
    planFram.plan = plan;
    [self.planFrame addObject:planFram];
}

- (void)setData2 {
    RjhPlanFrame *planFram = [[RjhPlanFrame alloc] init];
    RjhPlan *plan = [[RjhPlan alloc] init];
    plan.logid = @"000001";
    plan.userid = @"06407";
    plan.title = @"习近平一带一路论坛讲话十大高频词";
    plan.content = @"孟夏之日，万物并秀。“一带一路”国际合作高峰论坛成果丰硕，中国国家主席习近平在高峰论坛上的系列讲话传向世界各地。本文通过综合梳理习近平在开幕式上的演讲、欢迎宴会上的祝酒辞，以及论坛圆桌峰会上的开幕辞、闭幕辞，梳理出十大高频词，带您一一解读。";
    plan.logdate = @"2017-04-20";
    plan.logtime = @"09:26";
    plan.allday = 1;
    plan.type = PlanTypeNote;
    plan.khdm = @"00000000";
    plan.khmc = @"杭州鸿雁电器有限公司";
    plan.khdz = @"五常大道138号";
    plan.khdz_longitude = @"108.10";
    plan.khdz_latitude = @"99.08";
    plan.kh_lxr = @"官青";
    plan.kh_lxdh = @"15857125375";
    plan.signin = @"";
    //plan.signin = @"五常大道138号鸿雁电器产业园";
    plan.signin_longitude = @"105.1";
    plan.signin_latitude = @"102";
    plan.signin_time = @"17:42";
    plan.imageid = @"1,2,3";
    
    Photo *p1 = [[Photo alloc] init];
    p1.url = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    p1.surl = @"http://4493bz.1985t.com/uploads/allimg/150805/1-150P5115547.jpg";
    Photo *p2 = [[Photo alloc] init];
    p2.url = @"http://img2.91.com/uploads/allimg/130521/32-130521154S3.jpg";
    p2.surl = @"http://img2.91.com/uploads/allimg/130521/32-130521154S3.jpg";
    Photo *p3 = [[Photo alloc] init];
    p3.url = @"http://d.5857.com/6yfj_130601/010.jpg";
    p3.surl = @"http://d.5857.com/6yfj_130601/010.jpg";
    Photo *p4 = [[Photo alloc] init];
    p4.url = @"http://abc.2008php.com/2011_Website_appreciate/2011-09-12/20110912104833.jpg";
    p4.surl = @"http://abc.2008php.com/2011_Website_appreciate/2011-09-12/20110912104833.jpg";
    NSArray *imagesurl = [NSArray arrayWithObjects:p1,p2,p3,p4,p1,p2,p3,p4,p1,nil];
    plan.imagesurl = imagesurl;
    planFram.plan = plan;
    [self.planFrame addObject:planFram];
}

- (void)headerRefreshing {
    /*[self setData];
    [self setData1];
    [self setData2];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];*/
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[self.current,self.currentDate] forKeys:@[@"userid",@"ksrq"]];
    [RjhManager getRjhPlanListWithParameters:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            NSDictionary *data = [json objectForKey:@"data"];
            // 将字典数组转为模型数组(里面放的是RjhPlan模型)
            NSArray *rjhPlanArray = [RjhPlan mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            // 轨迹图
            self.trailArray = [RjhTrail mj_objectArrayWithKeyValuesArray:[data objectForKey:@"signinlist"]];
            // 创建frame模型对象
            NSMutableArray *rjhPlanFrameArray = [NSMutableArray array];
            for (RjhPlan *plan in rjhPlanArray) {
                RjhPlanFrame *planFrame = [[RjhPlanFrame alloc] init];
                // 传递rjhPlan模型数据
                planFrame.plan = plan;
                [rjhPlanFrameArray addObject:planFrame];
            }
            // 给模型数组赋值
            self.planFrame = rjhPlanFrameArray;
            
            // 刷新表格
            [self.tableView reloadData];
            
            // 让刷新控件停止显示刷新状态
            [self.tableView.mj_header endRefreshing];
            
        }
    } fail:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"获取日志列表失败"];
    }];
}

#pragma mark - RjhHeaderView 代理
- (void)headerViewChangeRefreshTableView:(RjhHeaderView *)headerView {
    self.currentDate = headerView.currentDate;
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerViewDidClickTrailBtn:(RjhHeaderView *)headerView {
    RjhTrailViewController *trailVc = [[RjhTrailViewController alloc] init];
    trailVc.trailArray = self.trailArray;
    trailVc.trailTitle = self.trailTitle;
    [self.navigationController pushViewController:trailVc animated:YES];
}

#pragma mark - 初始化首行条件view
- (void)setupTitleView {
    RjhHeaderView *headerView = [RjhHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight);
    headerView.delegate = self;
    [headerView setupDateCondition];
    [self.view addSubview:headerView];
}

#pragma mark - 设置导航栏的内容
- (void)setupNavBar {
    self.trailTitle = @"拜访轨迹";
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边按钮
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"caidan_64"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"caidan_64"] style:UIBarButtonItemStyleDone target:self action:@selector(browse)];
    self.navigationItem.rightBarButtonItem = right;
    
    // 设置view不要延伸
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInSuccess) name:signInSuccess object:nil];
    
    // 监听 browse cell click
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rjhBrowseCellClick:) name:rjhBrowseCellClick object:nil];
}

- (void)rjhBrowseCellClick:(NSNotification *)note {
    NSDictionary *dict = note.userInfo[rjhBrowseCellClick];
    _current = dict[@"ygbm"];
    if ([self.ygbm isEqualToString:_current]) {
        self.title = @"拜访轨迹";
        self.trailTitle = @"拜访轨迹";
    }else{
        self.title = [NSString stringWithFormat:@"%@的拜访轨迹",dict[@"ygxm"]];
        self.trailTitle = [NSString stringWithFormat:@"%@的拜访轨迹",dict[@"ygxm"]];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)signInSuccess {
    [self.tableView.mj_header beginRefreshing];
}

/** 移除通知 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)browse {
    WKBrowseViewController *browseVc = [[WKBrowseViewController alloc] init];
    [self.navigationController pushViewController:browseVc animated:YES];
}

- (void)pop {
    if (self.zjxs.count < 1) {
        [self loadZjgx];
        [MBProgressHUD showError:@"正在加载直接下属/或无直接下属"];
        return;
    }
    if (_zjxsView == nil) {
        _zjxsView = [[ZjxsCheckView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT) zjxs:self.zjxs ygbm:self.ygbm ygxm:@"我的拜访轨迹" current:self.current];
        _zjxsView.backgroundColor = [UIColor lightGrayColor];
        _zjxsView.delegate = self;
        [self.view addSubview:_zjxsView];
    }
    if (!_isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
            self->_zjxsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT);
            self->_zjxsView.current = self.current;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self->_zjxsView.frame = CGRectMake(0, NAV_BAR_HEIGHT - SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT - NAV_BAR_HEIGHT);
        }];
    }
    _isAppeared = !_isAppeared;
}

- (void)zjxsCheckView:(ZjxsCheckView *)zjxsCheckView didClickCell:(ZJXS *)zjxs {
    _current = zjxs.ygbm;
    if ([self.ygbm isEqualToString:_current]) {
        self.title = @"拜访轨迹";
        self.trailTitle = @"拜访轨迹";
    }else{
        self.title = [NSString stringWithFormat:@"%@的拜访轨迹",zjxs.ygxm];
        self.trailTitle = [NSString stringWithFormat:@"%@的拜访轨迹",zjxs.ygxm];
    }
    [self pop];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RjhPlanFrame *planFrame = self.planFrame[indexPath.row];
    return planFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 非本尊不能点开明细 */
    if (![self.ygbm isEqualToString:self.current]) {
        return;
    }
    RjhPlanFrame *planFrame = self.planFrame[indexPath.row];
    RjhPlan *plan = planFrame.plan;
    /** 承办人不能点开明细 */
    if (![plan.userid isEqualToString:plan.creater]) {
        return;
    }
    RjhWritePlanViewController *writePlan = [[RjhWritePlanViewController alloc] init];
    writePlan.delegate = self;
    writePlan.plan = plan;
    writePlan.zjxs = self.zjxs;
    [self.navigationController pushViewController:writePlan animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    RjhTableCell *cell = [RjhTableCell cellWithTableView:tableView];
    cell.delegate = self;
    
    // 2.传递数据
    cell.planFrame = self.planFrame[indexPath.row];
    
    // 2.传递frame模型
    return cell;
}

#pragma mark - comment PlanCommentViewDelegate
- (void)tableCell:(RjhTableCell *)tableCell replyRemark:(RjhRemark *)remark {
    /** 本人不能评价自己 */
    if ([self.ygbm isEqualToString:remark.operatorid]) {
        return;
    }
    NSString *logid = tableCell.planFrame.plan.logid;
    RjhCommentViewController *commentVc = [[RjhCommentViewController alloc] initWithLogid:logid rjhRemark:remark];
    commentVc.delegate = self;
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableCell:(RjhTableCell *)tableCell deleteRemark:(RjhRemark *)remark {
    /** 不能删除别人的评论 */
    if (![self.ygbm isEqualToString:remark.operatorid]) {
        return;
    }
    _deleteRemark = remark;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除本条评论" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}

#pragma mark - colorView attendanceBtn Click
- (void)tableCellTopColorViewDidClickAttendanceBtn:(RjhTableCell *)tableCell {
    /** 非本尊不能考勤 */
    if (![self.ygbm isEqualToString:self.current]) {
        return;
    }
    RjhSignInTableViewController *signIn = [[RjhSignInTableViewController alloc] initWithPlan:[self getPlan]];
    signIn.logid = [tableCell.planFrame.plan.logid intValue];
    [self.navigationController pushViewController:signIn animated:YES];
}

#pragma mark - toolBarButtonClick
- (void)tableCell:(RjhTableCell *)tableCell buttonType:(ToolBarButtonType)buttonType {
    switch (buttonType) {
        case ToolBarButtonTypeCamera:
            [self toolBarClickCamera:tableCell.planFrame.plan];
            break;
        case ToolBarButtonTypeComment:
            [self toolBarClickComment:tableCell.planFrame.plan];
            break;
        case ToolBarButtonTypeDelete:
            [self toolBarClickDelete:tableCell.planFrame.plan];
            break;
        default:
            break;
    }
}

/** 点击照相机按钮 */
- (void)toolBarClickCamera:(RjhPlan *)plan {
    /** 非本尊不能上传照片 */
    if (![self.ygbm isEqualToString:self.current]) {
        return;
    }
    RjhPhotoCollectionViewController *photoVc = [[RjhPhotoCollectionViewController alloc] init];
    photoVc.plan = plan;
    photoVc.delegate = self;
    [self.navigationController pushViewController:photoVc animated:YES];
}

/** 点击评论按钮 */
- (void)toolBarClickComment:(RjhPlan *)plan {
    RjhRemark *remark = [[RjhRemark alloc] init];
    RjhCommentViewController *commentVc = [[RjhCommentViewController alloc] initWithLogid:plan.logid rjhRemark:remark];
    commentVc.delegate = self;
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/** RjhCommentViewControllerDelegate */
- (void)rjhCommentViewControllerDidComment:(RjhCommentViewController *)commentVc {
    [self.tableView.mj_header beginRefreshing];
}

/** 点击删除按钮 */
- (void)toolBarClickDelete:(RjhPlan *)plan {
    /** 非本尊不能删除 */
    if (![self.ygbm isEqualToString:self.current]) {
        return;
    }
    /** 承办人不能删除 */
    if (![plan.userid isEqualToString:plan.creater]) {
        return;
    }
    _deleteId = plan.logid;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请仔细确认是否要删除该日志" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0 && buttonIndex == 1) {
        [MBProgressHUD showMessage:@"日志删除中..." toView:self.view];
        NSDictionary *params = [NSDictionary dictionaryWithObject:_deleteId forKey:@"logid"];
        [RjhManager deleteRjhPlanWithParameters:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            }else{
                [MBProgressHUD showSuccess:@"日志删除成功"];
                [self.tableView.mj_header beginRefreshing];
            }
        } fail:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常,日志删除失败"];
        }];
    }
    if (alertView.tag == 1 && buttonIndex == 1) {
        [MBProgressHUD showMessage:@"评论删除中..." toView:self.view];
        NSDictionary *params = [NSDictionary dictionaryWithObject:self.deleteRemark.rid forKey:@"rid"];
        [RjhManager deleteCommentWithParameters:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            }else{
                [MBProgressHUD showSuccess:@"评论删除成功"];
                [self.tableView.mj_header beginRefreshing];
            }
        } fail:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常,评论删除失败"];
        }];
    }
}

#pragma mark - RjhPhotoCollectionViewControllerDelegate
- (void)photoCollectionViewDidUploadPhotos:(RjhPhotoCollectionViewController *)photoCollectionVc {
    [self.tableView.mj_header beginRefreshing];
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
