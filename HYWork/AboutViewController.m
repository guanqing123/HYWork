//
//  AboutViewController.m
//  HYWork
//
//  Created by information on 16/6/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutHeaderView.h"

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景色/返回按钮
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [AboutHeaderView headerView];
    self.tableView.rowHeight = 30.0f;
    
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - 114.0f, SCREEN_WIDTH, 20.0f)];
    footerView.text = @"©杭州鸿雁电器有限公司    版权所有";
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.font = [UIFont systemFontOfSize:14.0f];
    [self.tableView addSubview:footerView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0 : {
            NSString *text = @"网址：http://www.hongyan.com.cn";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [str addAttribute:NSForegroundColorAttributeName value:themeColor range:NSMakeRange(3, 25)];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, SCREEN_WIDTH, 20.0f)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.attributedText = str;
            [cell.contentView addSubview:textLabel];
            break;
        }
        case 1 : {
            NSString *text = @"邮箱：hongyan@hongyan.com.cn";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [str addAttribute:NSForegroundColorAttributeName value:themeColor range:NSMakeRange(3, 22)];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, SCREEN_WIDTH, 20.0f)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.attributedText = str;
            [cell.contentView addSubview:textLabel];
            break;
        }
        case 2 : {
            NSString *text = @"电话：400-826-7818";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [str addAttribute:NSForegroundColorAttributeName value:themeColor range:NSMakeRange(3, 12)];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, SCREEN_WIDTH, 20.0f)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.attributedText = str;
            [cell.contentView addSubview:textLabel];
            break;
        }
        case 3 : {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, SCREEN_WIDTH, 20.0f)];
            textLabel.text = @"(周一至周五 9:00 - 18:00)";
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:textLabel];
            break;
        }
        default:
            break;
    }
    return cell;
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
