//
//  DkConditionView.h
//  HYWork
//
//  Created by information on 16/3/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerView.h"

@interface DkConditionView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,datePickerDelegate>

@property (nonatomic,weak) UITableView  *tableView;

@property (nonatomic,weak) UITextField  *mixTextField;
@property (nonatomic,copy) NSString *mixText;

@property (nonatomic,weak) UITextField  *maxTextField;
@property (nonatomic,copy) NSString *maxText;

@property (nonatomic,weak) UITextField  *khdmTextField;
@property (nonatomic,copy) NSString *khdm;


@property (nonatomic, strong)  DatePickerView *datePickerView;


@property (nonatomic,weak) UIAlertView  *alertView;


@property (nonatomic, copy) NSString *daokuanChoosed;

@property (nonatomic, copy) NSString *huakuanChoosed;

@property (nonatomic, copy) NSString *ywyChoosed;

@property (nonatomic, copy) NSString *bmChoosed;

@property (nonatomic,copy) NSString *bmbm;

@end
