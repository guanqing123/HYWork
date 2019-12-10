//
//  AddItemController.m
//  HYWork
//
//  Created by information on 16/3/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "AddItemController.h"
#import "Group.h"
#import "Item.h"
#import "CusFunCell.h"

@interface AddItemController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  NSArray *gns;

@property (nonatomic, strong)  NSMutableDictionary *dict;
@end

@implementation AddItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItem];
    
    [self initTableView];
}

/**
 *  初始化导航栏
 */
- (void)initNavItem {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - gns 懒加载
- (NSArray *)gns {
    if (_gns == nil) {
        // 加载JSON的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gns" ofType:@"json"];
        
        // 加载JSON文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 将JSON数据转为NSArray或者NSDictionary
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        // 将字典转成模型
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Group *group = [Group groupWithDict:dict];
            [itemArray addObject:group];
        }
        _gns = itemArray;
    }
    return _gns;
}

- (NSMutableDictionary *)dict {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"dict"];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    _dict = [dict mutableCopy];
    return _dict;
}

#pragma mark - tableView delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Group *group = self.gns[section];
    return group.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Group *group = [self.gns objectAtIndex:indexPath.section];
    Item *item = [group.items objectAtIndex:indexPath.row];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *old_data = [userDefault objectForKey:@"dict"];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:old_data];
    
    if ([[dict allKeys] count] < 1) {
        dict = [NSMutableDictionary dictionary];
    }
    
    if ([[dict allKeys] containsObject:item.title]) {
        [dict removeObjectForKey:item.title];
    }else{
        [dict setObject:item forKey:item.title];
    }
    
    NSData *new_data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [userDefault setObject:new_data forKey:@"dict"];
    [userDefault synchronize];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.delegate respondsToSelector:@selector(addItemControllerDidFinishChoose:)]) {
        [self.delegate addItemControllerDidFinishChoose:self];
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.gns.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group *group = [self.gns objectAtIndex:section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CusFunCell *cell = [CusFunCell cellWithTableView:tableView];
    
    Group *group = [self.gns objectAtIndex:indexPath.section];
    Item *item = [group.items objectAtIndex:indexPath.row];
    
    cell.item = item;
    cell.choose = [[self.dict allKeys] containsObject:item.title];
    
    return cell;
}


#pragma mark - 导航栏处理事件
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
