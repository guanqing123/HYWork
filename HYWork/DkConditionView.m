//
//  DkConditionView.m
//  HYWork
//
//  Created by information on 16/3/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DkConditionView.h"

@implementation DkConditionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
        [formatter0 setDateFormat:@"yyyy-MM"];
        NSString *trdate0 = [formatter0 stringFromDate:[NSDate date]];
        NSString *mix = [NSString stringWithFormat:@"%@-01",trdate0];
        _mixText = mix;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *trdate1 = [formatter1 stringFromDate:[NSDate date]];
        _maxText = trdate1;
        
        _khdm = @"";
        _bmbm = @"";
        
        self.daokuanChoosed = @"全部";
        self.huakuanChoosed = @"全部";
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height - 44.0f)];
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的查询条件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        _alertView = alertView;
        [self addSubview:alertView];
        
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat margin = 44.0f;
        UIColor *color = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(width / 2, height - margin, width / 2, margin);
        [checkButton setTitle:@"查询" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.backgroundColor = color;
        [checkButton addTarget:self action:@selector(checkItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0.0f, height - margin, width / 2, margin);
        [cancelButton setTitle:@"重置" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = color;
        [cancelButton addTarget:self action:@selector(cancelItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    }
    return self;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    CGFloat  width = self.frame.size.width;
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, width / 5 + 5, 20)];
        label.text = @"日期区间:";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UIButton *daimaBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, width / 4, 30)];
        daimaBtn1.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaBtn1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaBtn1.tag = 0;
        [daimaBtn1 setTitle:_mixText forState:UIControlStateNormal];
        [daimaBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaBtn1 addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.contentView addSubview:daimaBtn1];
        
        [daimaBtn1.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaBtn1.layer setBorderWidth:1.0f];
        [daimaBtn1.layer setCornerRadius:5.0f];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(daimaBtn1.frame) + 10, 21.5, 30, 1)];
        view1.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:view1];
        
        UIButton *daimaBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame) + 10, 7, width / 4, 30)];
        daimaBtn2.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaBtn2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaBtn2.tag = 1;
        [daimaBtn2 setTitle:_maxText forState:UIControlStateNormal];
        [daimaBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaBtn2 addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [daimaBtn2.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaBtn2.layer setBorderWidth:1.0f];
        [daimaBtn2.layer setCornerRadius:5.0f];
        [cell.contentView addSubview:daimaBtn2];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view2.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view2];
    }else if(indexPath.row == 1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, width / 5 + 5, 20)];
        label.text = @"到款地点:";
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
        
        UIButton *daimaBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, self.frame.size.width / 2, 30)];
        daimaBtn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaBtn.tag = 2;
        [daimaBtn setTitle:_daokuanChoosed forState:UIControlStateNormal];
        [daimaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaBtn addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.contentView addSubview:daimaBtn];
        
        [daimaBtn.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaBtn.layer setBorderWidth:1.0f];
        [daimaBtn.layer setCornerRadius:5.0f];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.row == 2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, width / 5 + 5, 20)];
        label.text = @"划至地点:";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UIButton *daimaBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, width / 2, 30)];
        daimaBtn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaBtn.tag = 3;
        [daimaBtn setTitle:_huakuanChoosed forState:UIControlStateNormal];
        [daimaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaBtn addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.contentView addSubview:daimaBtn];
        
        [daimaBtn.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaBtn.layer setBorderWidth:1.0f];
        [daimaBtn.layer setCornerRadius:5.0f];
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }else if(indexPath.row == 3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, self.frame.size.width / 5 + 5, 20)];
        label.text = @"部门：";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UIButton *daimaButton = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, self.frame.size.width / 2, 30)];
        daimaButton.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaButton.tag = 5;
        [daimaButton setTitle:_bmChoosed forState:UIControlStateNormal];
        [daimaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaButton addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.contentView addSubview:daimaButton];
        
        [daimaButton.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaButton.layer setBorderWidth:1.0f];
        [daimaButton.layer setCornerRadius:5.0f];
        
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if(indexPath.row == 4){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, self.frame.size.width / 5 + 5, 20)];
        label.text = @"业务员:";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UIButton *daimaBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, width / 2, 30)];
        daimaBtn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        daimaBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        daimaBtn.tag = 4;
        [daimaBtn setTitle:_ywyChoosed forState:UIControlStateNormal];
        [daimaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [daimaBtn addTarget:self action:@selector(buttonItem:) forControlEvents:UIControlEventTouchUpInside];
        daimaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.contentView addSubview:daimaBtn];
        
        [daimaBtn.layer setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]];
        [daimaBtn.layer setBorderWidth:1.0f];
        [daimaBtn.layer setCornerRadius:5.0f];
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }else if(indexPath.row == 5){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, width / 5 + 5, 20)];
        label.text = @"客户代码：";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UITextField *khdmTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.size.width + 20, 7, width / 2, 30)];
        khdmTextField.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        khdmTextField.returnKeyType = UIReturnKeyDone;
        khdmTextField.text = _khdm;
        khdmTextField.borderStyle = UITextBorderStyleRoundedRect;
        khdmTextField.delegate = self;
        khdmTextField.tag = 5;
        khdmTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _khdmTextField = khdmTextField;
        [cell.contentView addSubview:khdmTextField];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [cell.contentView addSubview:view];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

#pragma mark - condition btn click
- (void)buttonItem:(UIButton *)btn {
    [self.khdmTextField resignFirstResponder];
    if (btn.tag == 0 || btn.tag == 1) {
        if (_datePickerView == nil) {
            _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.superview.frame.size.height + 64 - 316, self.frame.size.width, 330)];
        }
        _datePickerView.delegate = self;
        _datePickerView.tag = btn.tag;
        [self.superview addSubview:_datePickerView];
    }
}

- (void)checkItem {

}

- (void)cancelItem {

}

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            break;
        case DatePickerViewButtonTypeSure:{
            if (datePickerView.tag == 0) {
                _mixText = datePickerView.selectedDate;
            }else{
                _maxText = datePickerView.selectedDate;
            }
            //局部刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
            break;
    }
}

@end
