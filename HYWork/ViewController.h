//
//  ViewController.h
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollView.h"
#import "AddItemController.h"
#import "DtDetailController.h"
#import "DtsController.h"
#import "ImageDetailController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  ScrollView *scrollView;

@property (strong, nonatomic)  AddItemController *addItemController;
@property (strong, nonatomic)  DtDetailController *dtDetailController;
@property (strong, nonatomic)  DtsController *dtsController;

@property (nonatomic, strong)  ImageDetailController *imgDetailController;

@end

