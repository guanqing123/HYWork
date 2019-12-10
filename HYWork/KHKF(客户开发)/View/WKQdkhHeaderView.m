//
//  WKQdkhHeaderView.m
//  HYWork
//
//  Created by information on 2018/11/20.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKQdkhHeaderView.h"
#import "MBProgressHUD+MJ.h"
#import "WKQdkh.h"
#import "WKMultiXLSelectPickerView.h"
#import "DatePickerView.h"
#import "SelectPickerView.h"
#import "WKChooseAddressView.h"

@interface WKQdkhHeaderView () <UIGestureRecognizerDelegate,WKMultiXLSelectPickerViewDelegate,datePickerDelegate,SelectPickerViewDelegate>

@property (nonatomic, strong)  WKMultiXLSelectPickerView *multiXLSelectPickerView;
@property (nonatomic, strong)  DatePickerView *datePickerView;
@property (nonatomic, strong)  SelectPickerView *selectPickerView;
@property (nonatomic, strong)  UIView *cover;

@property (nonatomic, strong)  WKChooseAddressView *chooseAddressView;
@property (nonatomic, strong)  UIView *addressSuperview;

/**
 销售点类型
 */
@property (nonatomic, strong)  NSArray *xsdType;
@property (nonatomic, strong)  NSArray *xsdTypeArray;

@property (weak, nonatomic) IBOutlet UITextField *khdmTF;
@property (weak, nonatomic) IBOutlet UITextField *khmcTF;
@property (weak, nonatomic) IBOutlet UITextField *jcTF;
@property (weak, nonatomic) IBOutlet UITextField *mcTF;
@property (weak, nonatomic) IBOutlet UITextField *jygmTF;
@property (weak, nonatomic) IBOutlet UITextField *xlTF;
@property (weak, nonatomic) IBOutlet UITextField *scbhsjTF;
@property (weak, nonatomic) IBOutlet UITextField *spjheTF;
@property (weak, nonatomic) IBOutlet UITextField *xsdTF;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *lxrTF;
@property (weak, nonatomic) IBOutlet UITextField *dqmcTF;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bzTF;

- (IBAction)khdmBtnClick;
- (IBAction)textFieldDidChanged:(UITextField *)sender;
- (IBAction)xlBtnClick;
- (IBAction)dateBtnClick;
- (IBAction)xsdBtnClick;
- (IBAction)visitedAddressList;
- (IBAction)dzBtnClick;

@end

@implementation WKQdkhHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setQdkh:(WKQdkh *)qdkh {
    _qdkh = qdkh;
    
    //1.上级经销商代码/名称
    self.khdmTF.text = qdkh.ty17;
    self.khmcTF.text = qdkh.khmc;
    
    //2.客户简称
    self.jcTF.text = qdkh.gjz;
    
    //3.客户名称
    self.mcTF.text = qdkh.mc;
    
    //4.经营规模
    self.jygmTF.text = qdkh.yjspjh;
    
    //5.合作产品系列
    NSMutableString *sb = [NSMutableString string];
    for (WKTjz5* tjz5 in qdkh.xl) {
        [sb appendString:tjz5.tjz5mc];
        [sb appendString:@","];
    }
    if ([sb length] > 1) {
        NSRange range = {[sb length] - 1, 1};
        [sb deleteCharactersInRange:range];
    }
    if ([sb length] > 0) {
        self.xlTF.text = sb;
    }else{
        self.xlTF.text = @"";
    }
    
    //6.首次合作时间
    self.scbhsjTF.text = qdkh.schzsj;
    
    //7.首批进货额
    self.spjheTF.text = qdkh.jymsw;
    
    //8.销售点类型
    for (NSDictionary *dict in self.xsdTypeArray) {
        if ([dict[@"xsd"] isEqualToString:qdkh.xsdlx]) {
            self.xsdTF.text = dict[@"xsdType"];
            break;
        }
    }
    
    //9.电话
    self.telTF.text = qdkh.lxfs;
    
    //10.联系人
    self.lxrTF.text = qdkh.lxr;
    
    //11.地址
    self.dqmcTF.text = qdkh.dqmc;
    self.detailAddressTF.text = qdkh.ty2;
    
    //12.备注
    self.bzTF.text = qdkh.bz;
}

#pragma mark - 客户代码按钮点击
- (IBAction)khdmBtnClick {
    if ([self.delegate respondsToSelector:@selector(qdkhHeaderViewkhdmBtnDidClick:)]) {
        [self.delegate qdkhHeaderViewkhdmBtnDidClick:self];
    }
}

#pragma mark - 编辑文本
- (IBAction)textFieldDidChanged:(UITextField *)sender {
    switch (sender.tag) {
        case 1: // 客户简称
            self.qdkh.gjz = sender.text;
            break;
        case 2: // 客户名称
            self.qdkh.mc = sender.text;
            break;
        case 3: // 经营规模(万元)
            self.qdkh.yjspjh = sender.text;
            break;
        case 4: // 首批进货额(万元)
            self.qdkh.jymsw = sender.text;
            break;
        case 5: // 电话
            self.qdkh.lxfs = sender.text;
            break;
        case 6: // 联系人
            self.qdkh.lxr = sender.text;
            break;
        case 7: // 详细地址
            self.qdkh.ty2 = sender.text;
            break;
        case 8: // 备注
            self.qdkh.bz = sender.text;
            break;
        default:
            break;
    }
}

#pragma mark - 系列按钮点击
- (IBAction)xlBtnClick {
    [self endEditing:YES];
    if ([self.khdmTF.text length] < 1) {
        [MBProgressHUD showError:@"上级经销商客户不能为空" toView:self.superview.superview];
        return;
    }
    if (_multiXLSelectPickerView != nil) {
        _multiXLSelectPickerView = nil;
    }
    if (_multiXLSelectPickerView == nil) {
        _multiXLSelectPickerView = [[WKMultiXLSelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _multiXLSelectPickerView.delegate = self;
        _multiXLSelectPickerView.khdm = self.khdmTF.text;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_multiXLSelectPickerView];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:self.qdkh.xl];
    _multiXLSelectPickerView.chooseArray = tempArray;
    
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - 首次合作时间
- (IBAction)dateBtnClick {
    [self endEditing:YES];
    if (_datePickerView != nil) {
        _datePickerView = nil;
    }
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - 销售点类型
- (IBAction)xsdBtnClick {
    [self endEditing:YES];
    if (_selectPickerView != nil) {
        _selectPickerView = nil;
    }
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:self.xsdType];
        _selectPickerView.dataArry = tempArray;
        _selectPickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case SelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case SelectPickerViewButtonTypeSure:{
            NSDictionary *dict = self.xsdTypeArray[selectPickerView.index];
            self.qdkh.xsdlx = [dict objectForKey:@"xsd"];
            self.xsdTF.text = [dict objectForKey:@"xsdType"];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)xsdType {
    if (_xsdType == nil) {
        _xsdType = [NSArray arrayWithObjects:@"五金店",@"灯具店",@"专业市场", nil];
    }
    return _xsdType;
}

- (NSArray *)xsdTypeArray {
    if (!_xsdTypeArray) {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"五金店",@"1"] forKeys:@[@"xsdType",@"xsd"]];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"灯具店",@"2"] forKeys:@[@"xsdType",@"xsd"]];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:@[@"专业市场",@"3"] forKeys:@[@"xsdType",@"xsd"]];
        _xsdTypeArray = [NSArray arrayWithObjects:dict1, dict2, dict3, nil];
    }
    return _xsdTypeArray;
}

#pragma mark - cover
- (UIView *)cover {
    if (_cover == nil) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _cover.tag = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        tap.delegate = self;
        [_cover addGestureRecognizer:tap];
    }
    return _cover;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    switch (gestureRecognizer.view.tag) {
        case 1 : {
            if ([self.cover.subviews count] > 0) {
                if (CGRectContainsPoint(self.cover.subviews[0].frame, point)) {
                    return NO;
                }
                return YES;
            }
            return YES;
            break;
        }
        case 2 : {
            if ([self.addressSuperview.subviews count] > 0) {
                if (CGRectContainsPoint(self.addressSuperview.subviews[0].frame, point)) {
                    return NO;
                }
                return YES;
            }
            return YES;
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)tapCover {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.cover removeFromSuperview];
    }];
}

#pragma mark - WKMultiXLSelectPickerViewDelegate
- (void)multiXlSelectPickerView:(WKMultiXLSelectPickerView *)selectPickerView buttonType:(WKMultiXLSelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case WKMultiXLSelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case WKMultiXLSelectPickerViewButtonTypeSure:{
            self.qdkh.xl = [selectPickerView.chooseArray copy];
            NSMutableString *sb = [NSMutableString string];
            for (WKTjz5* tjz5 in self.qdkh.xl) {
                [sb appendString:tjz5.tjz5mc];
                [sb appendString:@","];
            }
            if([sb length] > 1){
                NSRange deleteRange = {[sb length] - 1, 1};
                [sb deleteCharactersInRange:deleteRange];
            }
            if ([sb length] > 0) {
                self.xlTF.text = sb;
            }else{
                self.xlTF.text = @"";
            }
            
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            self.qdkh.schzsj = datePickerView.selectedDate;
            self.scbhsjTF.text = datePickerView.selectedDate;
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 访问通讯录
- (IBAction)visitedAddressList {
    if ([self.delegate respondsToSelector:@selector(qdkhHeaderViewVisitedAddressList:)]) {
        [self.delegate qdkhHeaderViewVisitedAddressList:self];
    }
}

#pragma mark - 地址访问
- (IBAction)dzBtnClick {
    if (_chooseAddressView == nil) {
        _chooseAddressView = [[WKChooseAddressView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 350, SCREEN_WIDTH, 350)];
        [self.addressSuperview addSubview:_chooseAddressView];
        WEAKSELF
        _chooseAddressView.chooseFinish = ^{
            weakSelf.qdkh.ty20 = weakSelf.chooseAddressView.code;
            weakSelf.qdkh.dqmc = weakSelf.chooseAddressView.address;
            weakSelf.dqmcTF.text = weakSelf.chooseAddressView.address;
            [weakSelf addressTapCover];
        };
    }
    self.chooseAddressView.hidden = NO;
    self.addressSuperview.hidden = NO;
}

- (UIView *)addressSuperview {
    if (!_addressSuperview) {
        _addressSuperview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _addressSuperview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _addressSuperview.tag = 2;
        [self.superview.superview addSubview:self.addressSuperview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapCover)];
        tap.delegate = self;
        [_addressSuperview addGestureRecognizer:tap];
    }
    return _addressSuperview;
}

- (void)addressTapCover {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.chooseAddressView.hidden = YES;
        weakSelf.addressSuperview.hidden = YES;
    }];
}

@end
