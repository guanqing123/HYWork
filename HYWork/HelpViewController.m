//
//  HelpViewController.m
//  HYWork
//
//  Created by information on 16/6/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "HelpViewController.h"
#import "SettingArrowItem.h"
#import "SettingGroup.h"
#import "HtmlViewController.h"
#import "NavigationController.h"
#import "Html.h"

@interface HelpViewController ()
@property (nonatomic, strong)  NSArray *htmls;
@end

@implementation HelpViewController

- (NSArray *)htmls {
    if (_htmls == nil) {
        
        // JSON文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"json"];
        
        // 加载JSON文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 将JSON数据转为NSArray或者NSDictionary
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //将字典转成模型
        NSMutableArray *htmlArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Html *html = [Html htmlWithDict:dict];
            [htmlArray addObject:html];
        }
        _htmls = htmlArray;
    }
    return _htmls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 1.创建所有的item
    NSMutableArray *items = [NSMutableArray array];
    for (Html *html in self.htmls) {
        SettingItem *item = [SettingArrowItem itemWithTitle:html.title destVcClass:nil];
        [items addObject:item];
    }
    
    // 2.创建组
    SettingGroup *group = [[SettingGroup alloc] init];
    group.items = items;
    [self.data addObject:group];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HtmlViewController *htmlVc = [[HtmlViewController alloc] init];
    htmlVc.html = self.htmls[indexPath.row];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:htmlVc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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
