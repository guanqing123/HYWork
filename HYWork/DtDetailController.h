//
//  DtDetailController.h
//  HYWork
//
//  Created by information on 16/3/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface DtDetailController : UIViewController

@property (nonatomic,copy) NSString *newsTitle;
@property (nonatomic,copy) NSString *newsTime;
@property (nonatomic,copy) NSString  *content;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *idStr;

- (instancetype)initWithTitle:(NSString *)newsTitle time:(NSString *)newsTime content:(NSString *)newsContent imgeUrl:(NSString *)imageUrl idStr:(NSString *)idStr;

@end
