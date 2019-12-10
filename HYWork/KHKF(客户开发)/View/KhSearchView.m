//
//  KhSearchView.m
//  HYWork
//
//  Created by information on 2017/7/21.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "KhSearchView.h"
#import "CustomerLabel.h"
#import "CustomButton.h"

#import "SelectPickerView.h"


#define labelFont [UIFont systemFontOfSize:13]
#define textFont [UIFont systemFontOfSize:14]

typedef enum {
    KhSearchViewButtonTypeReset,
    KhSearchViewButtonTypeSearch
}KhSearchViewButtonType;

@interface KhSearchView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,SelectPickerViewDelegate>
@property (nonatomic, weak) UITextField  *khmcTextField;
@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, weak) CustomButton  *khlxButton;

/** 类型选择器 */
@property (nonatomic, strong)  SelectPickerView *selectPickerView;
/** 背景父元素 */
@property (nonatomic, strong)  UIView *cover;
/** 客户类型  */
@property (nonatomic, strong)  NSMutableArray *khlxSource;
@property (nonatomic, strong)  NSArray *khlxArray;

@end

@implementation KhSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    CGFloat parentW = SCREEN_WIDTH;
    if (indexPath.row == 0) {
        // 客户名称label
        CustomerLabel *khmcLabel = [[CustomerLabel alloc] init];
        khmcLabel.textInsets = UIEdgeInsetsMake(12, 20, 12, 0);
        khmcLabel.text = @"客户名称:";
        khmcLabel.font = labelFont;
        khmcLabel.textColor = GQColor(150, 150, 150);
        CGFloat khmcLabelX = 0;
        CGFloat khmcLabelY = 0;
        CGFloat khmcLabelW = 100;
        CGFloat khmcLabelH = 43;
        khmcLabel.frame = CGRectMake(khmcLabelX, khmcLabelY, khmcLabelW, khmcLabelH);
        [cell.contentView addSubview:khmcLabel];
        
        // 客户名称field
        UITextField *khmcTextField = [[UITextField alloc] init];
        khmcTextField.frame = CGRectMake(100, 7, SCREEN_WIDTH - 150, 30);
        khmcTextField.backgroundColor = GQColor(238, 238, 238);
        khmcTextField.returnKeyType = UIReturnKeyDone;
        khmcTextField.borderStyle = UITextBorderStyleRoundedRect;
        khmcTextField.delegate = self;
        khmcTextField.font = textFont;
        CGFloat khmcTextFieldX = CGRectGetMaxX(khmcLabel.frame);
        CGFloat khmcTextFieldY = 7;
        CGFloat khmcTextFieldW = parentW - khmcTextFieldX - 50;
        CGFloat khmcTextFieldH = 30;
        khmcTextField.frame = CGRectMake(khmcTextFieldX, khmcTextFieldY, khmcTextFieldW, khmcTextFieldH);
        _khmcTextField = khmcTextField;
        [cell.contentView addSubview:khmcTextField];
        
        // 底线
        UIView *khmcLineView = [[UIView alloc] init];
        khmcLineView.backgroundColor = GQColor(238, 238, 238);
        CGFloat khmcLineViewX = 0;
        CGFloat khmcLineViewY = CGRectGetMaxY(khmcLabel.frame);
        CGFloat khmcLineViewW = parentW;
        CGFloat khmcLineViewH = 1;
        khmcLineView.frame = CGRectMake(khmcLineViewX, khmcLineViewY, khmcLineViewW, khmcLineViewH);
        [cell.contentView addSubview:khmcLineView];
    }else if (indexPath.row == 1){
        // 客户类型
        CustomerLabel *khlxLabel = [[CustomerLabel alloc] init];
        khlxLabel.textInsets = UIEdgeInsetsMake(12, 20, 12, 0);
        khlxLabel.text = @"客户类型:";
        khlxLabel.font = labelFont;
        khlxLabel.textColor = GQColor(150, 150, 150);
        CGFloat khlxLabelX = 0;
        CGFloat khlxLabelY = 0;
        CGFloat khlxLabelW = 100;
        CGFloat khlxLabelH = 43;
        khlxLabel.frame = CGRectMake(khlxLabelX, khlxLabelY, khlxLabelW, khlxLabelH);
        [cell.contentView addSubview:khlxLabel];
        
        // 客户类型btn
        CustomButton *khlxButton = [CustomButton customButton];
        [khlxButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [khlxButton addTarget:self action:@selector(khlxButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [khlxButton setTitle:@"经销客户" forState:UIControlStateNormal];
        self.khlxcx = @"01";
        khlxButton.frame = CGRectMake(100, 7, SCREEN_WIDTH - 150, 30);
        khlxButton.backgroundColor = GQColor(238, 238, 238);
        CGFloat khlxButtonX = CGRectGetMaxX(khlxLabel.frame);
        CGFloat khlxButtonY = 7;
        CGFloat khlxButtonW = parentW - khlxButtonX - 50;
        CGFloat khlxButtonH = 30;
        khlxButton.frame = CGRectMake(khlxButtonX, khlxButtonY, khlxButtonW, khlxButtonH);
        _khlxButton = khlxButton;
        [cell.contentView addSubview:khlxButton];
        
        // 底线
        UIView *khlxLineView = [[UIView alloc] init];
        khlxLineView.backgroundColor = GQColor(238, 238, 238);
        CGFloat khlxLineViewX = 0;
        CGFloat khlxLineViewY = CGRectGetMaxY(khlxLabel.frame);
        CGFloat khlxLineViewW = parentW;
        CGFloat khlxLineViewH = 1;
        khlxLineView.frame = CGRectMake(khlxLineViewX, khlxLineViewY, khlxLineViewW, khlxLineViewH);
        [cell.contentView addSubview:khlxLineView];
        
    }else if(indexPath.row == 2){
        // 重置
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        resetBtn.titleLabel.font = textFont;
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetBtn.backgroundColor = GQColor(0, 157, 133);
        resetBtn.tag = KhSearchViewButtonTypeReset;
        [resetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat resetBtnX = 0;
        CGFloat resetBtnY = 0;
        CGFloat resetBtnW = parentW/2;
        CGFloat resetBtnH = 35;
        resetBtn.frame = CGRectMake(resetBtnX, resetBtnY, resetBtnW, resetBtnH);
        [cell.contentView addSubview:resetBtn];
        // 查询
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setTitle:@"查询" forState:UIControlStateNormal];
        checkBtn.titleLabel.font = textFont;
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkBtn.backgroundColor = GQColor(0, 157, 133);
        checkBtn.tag = KhSearchViewButtonTypeSearch;
        [checkBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat checkBtnX = CGRectGetMaxX(resetBtn.frame);
        CGFloat checkBtnY = 0;
        CGFloat checkBtnW = resetBtnW;
        CGFloat checkBtnH = resetBtnH;
        checkBtn.frame = CGRectMake(checkBtnX, checkBtnY, checkBtnW, checkBtnH);
        [cell.contentView addSubview:checkBtn];
        
        // 底线
        UIView *historyLineView = [[UIView alloc] init];
        historyLineView.backgroundColor = GQColor(238, 238, 238);
        CGFloat historyLineViewX = 0;
        CGFloat historyLineViewY = CGRectGetMaxY(resetBtn.frame);
        CGFloat historyLineViewW = parentW;
        CGFloat historyLineViewH = 1;
        historyLineView.frame = CGRectMake(historyLineViewX, historyLineViewY, historyLineViewW, historyLineViewH);
        [cell.contentView addSubview:historyLineView];
    }
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row ==  1) {
        return 44.0f;
    }else if (indexPath.row == 2){
        return 36.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - button click
- (void)buttonClick:(UIButton *)button {
    [self endEditing:YES];
    switch (button.tag) {
        case KhSearchViewButtonTypeReset:{
            self.khmcTextField.text = @"";
            self.khmcStr = @"";
            [self.khlxButton setTitle:@"" forState:UIControlStateNormal];
            self.khlxcx = @"";
            break;
        }
        case KhSearchViewButtonTypeSearch:{
            if ([self.delegate respondsToSelector:@selector(khSearchViewDidSearchBpcByCondition:)]) {
                [self.delegate khSearchViewDidSearchBpcByCondition:self];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _khmcStr = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - khlxButtonClick
- (void)khlxButtonClick {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        
        _selectPickerView.delegate = self;
        _selectPickerView.dataArry = self.khlxSource;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - cover
- (UIView *)cover{
    if (_cover == nil) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _cover;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.cover.subviews[0].frame, point)) {
        return NO;
    }
    return YES;
}

- (void)tapCover {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.cover removeFromSuperview];
    }];
}

/** 客户类型 */
- (NSMutableArray *)khlxSource {
    if (_khlxSource == nil) {
        _khlxSource = [NSMutableArray arrayWithObjects:@"经销客户",@"分销商",@"战略客户" ,nil];
    }
    return _khlxSource;
}

- (NSArray *)khlxArray {
    if (_khlxArray == nil) {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"经销客户",@"01"] forKeys:@[@"khlxName",@"khlx"]];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"分销商",@"05"] forKeys:@[@"khlxName",@"khlx"]];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:@[@"战略客户",@"5"] forKeys:@[@"khlxName",@"khlx"]];
        _khlxArray = [NSArray arrayWithObjects:dict1, dict2, dict3,nil];
    }
    return _khlxArray;
}

#pragma mark - SelectPickerViewDelegate
- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case SelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case SelectPickerViewButtonTypeSure:{
            NSDictionary *dict = [self.khlxArray objectAtIndex:selectPickerView.index];
            [self.khlxButton setTitle:dict[@"khlxName"] forState:UIControlStateNormal];
            self.khlxcx = dict[@"khlx"];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

@end
