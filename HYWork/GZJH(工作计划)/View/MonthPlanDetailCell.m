//
//  MonthPlanDetailCell.m
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "MonthPlanDetailCell.h"
#import "InsetsLabel.h"
#import "CustomButton.h"
#import "HYButton.h"
#import "TxlViewController.h"
#import "DatePickerView.h"
#import "LoadViewController.h"
#import "SelectPickerView.h"
#import "SJLD.h"

#define TextFont [UIFont systemFontOfSize:14.0f]

@interface MonthPlanDetailCell() <UITextViewDelegate,datePickerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,SelectPickerViewDelegate>
/**
 *  1.指标类型
 */
@property (nonatomic, weak) InsetsLabel  *zblxLabel;
@property (nonatomic, weak) HYButton *zblxBtn;
@property (nonatomic, weak) UIView  *zblxView;
/**
 *  2.衡量指标
 */
@property (nonatomic, weak) InsetsLabel  *hlzbLabel;
@property (nonatomic, weak) UITextView  *hlzbTextView;
@property (nonatomic, weak) UIView  *hlzbView;
/**
 *  3.年度目标值
 */
@property (nonatomic, weak) InsetsLabel  *ndmbzLabel;
@property (nonatomic, weak) UITextView  *ndmbzTextView;
@property (nonatomic, weak) UIView  *ndmbzView;
/**
 *  4.月度目标值
 */
@property (nonatomic, weak) InsetsLabel  *ydmbzLabel;
@property (nonatomic, weak) UITextView  *ydmbzTextView;
@property (nonatomic, weak) UIView  *ydmbzView;
/**
 *  5.考核标准
 */
@property (nonatomic, weak) InsetsLabel  *khbzLabel;
@property (nonatomic, weak) UITextView  *khbzTextView;
@property (nonatomic, weak) UIView  *khbzView;
/**
 *  6.行动方案
 */
@property (nonatomic, weak) InsetsLabel  *xdfaLabel;
@property (nonatomic, weak) UITextView  *xdfaTextView;
@property (nonatomic, weak) UIView  *xdfaView;
/**
 *  7.权重(目标分值)
 */
@property (nonatomic, weak) InsetsLabel *qzLabel;
@property (nonatomic, weak) UITextField *qzTextField;
@property (nonatomic, weak) UIView *qzView;
/**
 *  8.预计完成时间
 */
@property (nonatomic, weak) InsetsLabel *yjwcsjLabel;
@property (nonatomic, weak) CustomButton *yjwcsjBtn;
@property (nonatomic, weak) UIView *yjwcsjView;
/**
 *  9.主办人
 */
@property (nonatomic, weak) InsetsLabel *zbrLabel;
@property (nonatomic, weak) CustomButton *zbrBtn;
@property (nonatomic, weak) UIView *zbrView;
/**
 *  10.交办人
 */
@property (nonatomic, weak) InsetsLabel *jbrLabel;
@property (nonatomic, weak) CustomButton *jbrBtn;
@property (nonatomic, weak) UIView *jbrView;
/**
 *  11.协办人
 */
@property (nonatomic, weak) InsetsLabel *xbrLabel;
@property (nonatomic, weak) HYButton *xbrBtn;
@property (nonatomic, weak) UIView *xbrView;
/**
 *  12.打分领导
 */
@property (nonatomic, weak) InsetsLabel *dfldLabel;
@property (nonatomic, weak) CustomButton *dfldBtn;
@property (nonatomic, weak) UIView *dfldView;

/**
 *  日期选择器
 */
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;

@property (nonatomic, strong)  SelectPickerView *selectPickerView;

@end

@implementation MonthPlanDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView rowIndex:(NSInteger)rowIndex {
    MonthPlanDetailCell *cell = [[MonthPlanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil rowIndex:rowIndex];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowIndex:(NSInteger)rowIndex {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _rowIndex = rowIndex;
        CGFloat padding = 10.0f;
        switch (rowIndex) {
            case 0 : {  // 0.指标类型
                CGFloat padding = 10;
                InsetsLabel *zblxLabel = [[InsetsLabel alloc] init];
                zblxLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                zblxLabel.text = @"指标类型:";
                zblxLabel.font = TextFont;
                zblxLabel.textColor = [UIColor grayColor];
                _zblxLabel = zblxLabel;
                [self.contentView addSubview:zblxLabel];
                
                HYButton *zblxBtn = [HYButton customButton];
                _zblxBtn = zblxBtn;
                [self.contentView addSubview:zblxBtn];
                
                UIView *zblxView = [[UIView alloc] init];
                zblxView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _zblxView = zblxView;
                [self.contentView addSubview:zblxView];
                
                break;
            }
            case 1 : { // 1.衡量指标
                InsetsLabel *hlzbLabel = [[InsetsLabel alloc] init];
                hlzbLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                hlzbLabel.text = @"衡量指标:";
                hlzbLabel.font = TextFont;
                hlzbLabel.textColor = [UIColor grayColor];
                _hlzbLabel = hlzbLabel;
                [self.contentView addSubview:hlzbLabel];
                
                UITextView *hlzbTextView = [[UITextView alloc] init];
                hlzbTextView.tag = 0;
                hlzbTextView.font = TextFont;
                hlzbTextView.layer.borderWidth  = 1.0f;
                hlzbTextView.layer.cornerRadius = 5.0;
                hlzbTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                hlzbTextView.delegate = self;
                hlzbTextView.returnKeyType = UIReturnKeyDone;
                _hlzbTextView = hlzbTextView;
                [self.contentView addSubview:hlzbTextView];
                
                UIView *hlzbView = [[UIView alloc] init];
                hlzbView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _hlzbView = hlzbView;
                [self.contentView addSubview:hlzbView];
                
                break;
            }
            case 2 : {  // 2.年度目标值
                InsetsLabel *ndmbzLabel = [[InsetsLabel alloc] init];
                ndmbzLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                ndmbzLabel.text = @"年度目标值:";
                ndmbzLabel.font = TextFont;
                ndmbzLabel.textColor = [UIColor grayColor];
                _ndmbzLabel = ndmbzLabel;
                [self.contentView addSubview:ndmbzLabel];
                
                UITextView *ndmbzTextView = [[UITextView alloc] init];
                ndmbzTextView.tag = 1;
                ndmbzTextView.font = TextFont;
                ndmbzTextView.layer.borderWidth  = 1.0f;
                ndmbzTextView.layer.cornerRadius = 5.0;
                ndmbzTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                ndmbzTextView.delegate = self;
                ndmbzTextView.returnKeyType = UIReturnKeyDone;
                _ndmbzTextView = ndmbzTextView;
                [self.contentView addSubview:ndmbzTextView];
                
                UIView *ndmbzView = [[UIView alloc] init];
                ndmbzView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _ndmbzView = ndmbzView;
                [self.contentView addSubview:ndmbzView];
                
                break;
            }
            case 3 : {  // 3.月度目标值
                InsetsLabel *ydmbzLabel = [[InsetsLabel alloc] init];
                ydmbzLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                ydmbzLabel.text = @"月度目标值:";
                ydmbzLabel.font = TextFont;
                ydmbzLabel.textColor = [UIColor grayColor];
                _ydmbzLabel = ydmbzLabel;
                [self.contentView addSubview:ydmbzLabel];
                
                UITextView *ydmbzTextView = [[UITextView alloc] init];
                ydmbzTextView.tag = 2;
                ydmbzTextView.font = TextFont;
                ydmbzTextView.layer.borderWidth  = 1.0f;
                ydmbzTextView.layer.cornerRadius = 5.0;
                ydmbzTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                ydmbzTextView.delegate = self;
                ydmbzTextView.returnKeyType = UIReturnKeyDone;
                _ydmbzTextView = ydmbzTextView;
                [self.contentView addSubview:ydmbzTextView];
                
                UIView *ydmbzView = [[UIView alloc] init];
                ydmbzView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _ydmbzView = ydmbzView;
                [self.contentView addSubview:ydmbzView];
                
                break;
            }
            case 4 : { // 4.考核标准
                InsetsLabel *khbzLabel = [[InsetsLabel alloc] init];
                khbzLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                khbzLabel.text = @"考核标准:";
                khbzLabel.font = TextFont;
                khbzLabel.textColor = [UIColor grayColor];
                _khbzLabel = khbzLabel;
                [self.contentView addSubview:khbzLabel];
                
                UITextView *khbzTextView = [[UITextView alloc] init];
                khbzTextView.tag = 3;
                khbzTextView.font = TextFont;
                khbzTextView.layer.borderWidth  = 1.0f;
                khbzTextView.layer.cornerRadius = 5.0;
                khbzTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                khbzTextView.delegate = self;
                khbzTextView.returnKeyType = UIReturnKeyDone;
                _khbzTextView = khbzTextView;
                [self.contentView addSubview:khbzTextView];
                
                UIView *khbzView = [[UIView alloc] init];
                khbzView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _khbzView = khbzView;
                [self.contentView addSubview:khbzView];
                
                break;
            }
            case 5 : {  // 5.行动方案
                InsetsLabel *xdfaLabel = [[InsetsLabel alloc] init];
                xdfaLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                xdfaLabel.text = @"行动方案:";
                xdfaLabel.font = TextFont;
                xdfaLabel.textColor = [UIColor grayColor];
                _xdfaLabel = xdfaLabel;
                [self.contentView addSubview:xdfaLabel];
                
                UITextView *xdfaTextView = [[UITextView alloc] init];
                xdfaTextView.tag = 4;
                xdfaTextView.font = TextFont;
                xdfaTextView.layer.borderWidth  = 1.0f;
                xdfaTextView.layer.cornerRadius = 5.0;
                xdfaTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                xdfaTextView.delegate = self;
                xdfaTextView.returnKeyType = UIReturnKeyDone;
                _xdfaTextView = xdfaTextView;
                [self.contentView addSubview:xdfaTextView];
                
                UIView *xdfaView = [[UIView alloc] init];
                xdfaView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _xdfaView = xdfaView;
                [self.contentView addSubview:xdfaView];
                
                break;
            }
            case 6 : {  // 6.权重
                InsetsLabel *qzLabel = [[InsetsLabel alloc] init];
                qzLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                qzLabel.text = @"权重(目标分值):";
                qzLabel.font = TextFont;
                qzLabel.textColor = [UIColor grayColor];
                _qzLabel = qzLabel;
                [self.contentView addSubview:qzLabel];
                
                UITextField *qzTextField = [[UITextField alloc] init];
                qzTextField.tag = 2;
                qzTextField.font = TextFont;
                qzTextField.layer.borderWidth  = 1.0f;
                qzTextField.layer.cornerRadius = 5.0;
                qzTextField.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                qzTextField.delegate = self;
                qzTextField.returnKeyType = UIReturnKeyDone;
                [qzTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
                _qzTextField = qzTextField;
                [self.contentView addSubview:qzTextField];
                
                UIView *qzView = [[UIView alloc] init];
                qzView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _qzView = qzView;
                [self.contentView addSubview:qzView];
                
                break;
            }
            case 7 : {  // 7.预计完成时间
                InsetsLabel *yjwcsjLabel = [[InsetsLabel alloc] init];
                yjwcsjLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                yjwcsjLabel.text = @"预计完成时间:";
                yjwcsjLabel.font = TextFont;
                yjwcsjLabel.textColor = [UIColor grayColor];
                _yjwcsjLabel = yjwcsjLabel;
                [self.contentView addSubview:yjwcsjLabel];
                
                CustomButton *yjwcsjBtn = [CustomButton customButton];
                [yjwcsjBtn addTarget:self action:@selector(yjwcsjBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [yjwcsjBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                _yjwcsjBtn = yjwcsjBtn;
                [self.contentView addSubview:yjwcsjBtn];
                
                UIView *yjwcsjView = [[UIView alloc] init];
                yjwcsjView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _yjwcsjView = yjwcsjView;
                [self.contentView addSubview:yjwcsjView];
                
                break;
            }
            case 8 : {  // 8.主办人
                InsetsLabel *zbrLabel = [[InsetsLabel alloc] init];
                zbrLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                zbrLabel.text = @"主办人:";
                zbrLabel.font = TextFont;
                zbrLabel.textColor = [UIColor grayColor];
                _zbrLabel = zbrLabel;
                [self.contentView addSubview:zbrLabel];
                
                CustomButton *zbrBtn = [CustomButton customButton];
                [zbrBtn addTarget:self action:@selector(zbrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [zbrBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                _zbrBtn = zbrBtn;
                [self.contentView addSubview:zbrBtn];
                
                UIView *zbrView = [[UIView alloc] init];
                zbrView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _zbrView = zbrView;
                [self.contentView addSubview:zbrView];
                
                break;
            }
            case 9 : {  // 9.交办人
                InsetsLabel *jbrLabel = [[InsetsLabel alloc] init];
                jbrLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                jbrLabel.text = @"交办人:";
                jbrLabel.font = TextFont;
                jbrLabel.textColor = [UIColor grayColor];
                _jbrLabel = jbrLabel;
                [self.contentView addSubview:jbrLabel];
                
                CustomButton *jbrBtn = [CustomButton customButton];
                [jbrBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                _jbrBtn = jbrBtn;
                [self.contentView addSubview:jbrBtn];
                
                UIView *jbrView = [[UIView alloc] init];
                jbrView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _jbrView = jbrView;
                [self.contentView addSubview:jbrView];
                
                break;
            }
            case 10 : { // 10.协办人
                InsetsLabel *xbrLabel = [[InsetsLabel alloc] init];
                xbrLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                xbrLabel.text = @"协办人:";
                xbrLabel.font = TextFont;
                xbrLabel.textColor = [UIColor grayColor];
                _xbrLabel = xbrLabel;
                [self.contentView addSubview:xbrLabel];
                
                HYButton *xbrBtn = [HYButton customButton];
                [xbrBtn addTarget:self action:@selector(xbrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                _xbrBtn = xbrBtn;
                [self.contentView addSubview:xbrBtn];
                
                UIView *xbrView = [[UIView alloc] init];
                xbrView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _xbrView = xbrView;
                [self.contentView addSubview:xbrView];
                
                break;
            }
            case 11 : { // 11.打分领导
                InsetsLabel *dfldLabel = [[InsetsLabel alloc] init];
                dfldLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                dfldLabel.text = @"打分领导:";
                dfldLabel.font = TextFont;
                dfldLabel.textColor = [UIColor grayColor];
                _dfldLabel = dfldLabel;
                [self.contentView addSubview:dfldLabel];
                
                CustomButton *dfldBtn = [CustomButton customButton];
                [dfldBtn addTarget:self action:@selector(dfldBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [dfldBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                _dfldBtn = dfldBtn;
                [self.contentView addSubview:dfldBtn];
                
                UIView *dfldView = [[UIView alloc] init];
                dfldView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _dfldView = dfldView;
                [self.contentView addSubview:dfldView];
                
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)setMonthPlan:(MonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    // 1.设置数据
    [self settingData];
    
    // 2.设置frame
    [self settingFrame];
    
    // 3.设置控件状态
    [self settingState];
    
    // 4.设置权重状态
    [self setQzState];
}

+ (CGFloat)cellHeight:(NSInteger)rowIndex {
    CGFloat cellHeight = 0;
    switch (rowIndex) {
        case 0 :    // 0.指标类型
            cellHeight = 45.0f;
            break;
        case 1 :    // 1.衡量指标
            cellHeight = 129.0f;
            break;
        case 2 :    // 2.年度目标值
            cellHeight = 107.0f;
            break;
        case 3 :    // 3.月度目标值
            cellHeight = 107.0f;
            break;
        case 4 :    // 4.考核标准
            cellHeight = 107.0f;
            break;
        case 5 :    // 5.行动方案
            cellHeight = 129.0f;
            break;
        case 6 :    // 6.权重
            cellHeight = 45.0f;
            break;
        case 7 :    // 7.预计完成时间
            cellHeight = 45.0f;
            break;
        case 8 :    // 8.主办人
            cellHeight = 45.0f;
            break;
        case 9 :    // 9.交办人
            cellHeight = 45.0f;
            break;
        case 10 :   // 10.协办人
            cellHeight = 45.0f;
            break;
        case 11 :   // 11.打分领导
            cellHeight = 45.0f;
            break;
        default:
            break;
    }
    return cellHeight;
}

/**
 *  设置数据
 */
- (void)settingData {
    switch (_rowIndex) {
        case 0 :    /** 0.指标类型 */
            [self setUpZblx];
            break;
        case 1 : {  /** 1.衡量指标 */
            if ([self.monthPlan.hlzb isKindOfClass:[NSNull class]]) {
                self.hlzbTextView.text = @"";
            }else{
                self.hlzbTextView.text = self.monthPlan.hlzb;
            }
            break;
        }
        case 2 : {  /** 2.年度目标值 */
            if ([self.monthPlan.gznr isKindOfClass:[NSNull class]]) {
                self.ndmbzTextView.text = @"";
            }else{
                self.ndmbzTextView.text = self.monthPlan.gznr;
            }
            break;
        }
        case 3 : {  /** 3.月度目标值 */
            if ([self.monthPlan.ygznr isKindOfClass:[NSNull class]]) {
                self.ydmbzTextView.text = @"";
            }else{
                self.ydmbzTextView.text = self.monthPlan.ygznr;
            }
            break;
        }
        case 4 : {  /** 4.考核标准 */
            if ([self.monthPlan.khbz isKindOfClass:[NSNull class]]) {
                self.khbzTextView.text = @"";
            }else{
                self.khbzTextView.text = self.monthPlan.khbz;
            }
            break;
        }
        case 5 : {  /** 5.行动方案 */
            if ([self.monthPlan.xdfa isKindOfClass:[NSNull class]]) {
                self.xdfaTextView.text = @"";
            }else{
                self.xdfaTextView.text = self.monthPlan.xdfa;
            }
            break;
        }
        case 6 : {  /** 6.权重(目标分值) */
            if ([self.monthPlan.fz isKindOfClass:[NSNull class]]) {
                self.qzTextField.text = @"";
            }else{
                self.qzTextField.text = [NSString stringWithFormat:@"%@",self.monthPlan.fz];
            }
            break;
        }
        case 7 : {  /** 7.预计完成时间 */
            if ([self.monthPlan.yjwc isKindOfClass:[NSNull class]]) {
                [self.yjwcsjBtn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.yjwcsjBtn setTitle:self.monthPlan.yjwc forState:UIControlStateNormal];
            }
            break;
        }
        case 8 : {  /** 8.主办人 */
            if ([self.monthPlan.cbr isKindOfClass:[NSNull class]]) {
                [self.zbrBtn setVal:@"" andDis:@""];
            }else{
                [self.zbrBtn setVal:self.monthPlan.cbr andDis:self.monthPlan.n_cbr];
            }
            break;
        }
        case 9 : {  /** 9.交办人 */
            if ([self.monthPlan.fbr isKindOfClass:[NSNull class]]) {
                [self.jbrBtn setVal:@"" andDis:@""];
            }else{
                [self.jbrBtn setVal:self.monthPlan.fbr andDis:self.monthPlan.n_fbr];
            }
            break;
        }
        case 10 : { /** 10.协办人 */
            if ([self.monthPlan.xbr isKindOfClass:[NSNull class]]) {
                [self.xbrBtn setVal:@"" andDis:@""];
            }else{
                [self.xbrBtn setVal:self.monthPlan.xbr andDis:self.monthPlan.n_xbr];
            }
            break;
        }
        case 11 : {
            /** 11.打分领导 */
            if ([self.monthPlan.dfld isKindOfClass:[NSNull class]]) {
                [self.dfldBtn setVal:@"" andDis:@""];
            }else{
                [self.dfldBtn setVal:self.monthPlan.dfld andDis:self.monthPlan.n_dfld];
            }
            break;
        }
        default:
            break;
    }
}

/** 指标类型 */
- (void)setUpZblx {
    switch ([_monthPlan.zblx intValue]) {
        case 1:
            [self.zblxBtn setVal:self.monthPlan.zblx andDis:@"客户"];
            break;
        case 2:
            [self.zblxBtn setVal:self.monthPlan.zblx andDis:@"财务"];
            break;
        case 3:
            [self.zblxBtn setVal:self.monthPlan.zblx andDis:@"内部运营"];
            break;
        case 4:
            [self.zblxBtn setVal:self.monthPlan.zblx andDis:@"学习成长"];
            break;
        case 5:
            [self.zblxBtn setVal:self.monthPlan.zblx andDis:@"其它"];
            break;
        default:
            break;
    }
}


/**
 *  设置frame
 */
- (void)settingFrame {
    CGFloat padding = 10;
    switch (_rowIndex) {
        case 0 : {  // 0.指标类型
            CGFloat zblxLabelX = 0;
            CGFloat zblxLabelY = 0;
            CGFloat zblxLabelW = SCREEN_WIDTH * 0.4;
            CGFloat zblxLabelH = 44.0f;
            _zblxLabel.frame = CGRectMake(zblxLabelX, zblxLabelY, zblxLabelW, zblxLabelH);
            
            CGFloat zblxBtnX = CGRectGetMaxX(_zblxLabel.frame);
            CGFloat zblxBtnH = 30.0f;
            CGFloat zblxBtnY = (zblxLabelH - zblxBtnH)/2;
            CGFloat zblxBtnW = SCREEN_WIDTH * 0.5;
            _zblxBtn.frame = CGRectMake(zblxBtnX, zblxBtnY, zblxBtnW, zblxBtnH);
            
            CGFloat zblxViewX = 0;
            CGFloat zblxViewY = CGRectGetMaxY(_zblxLabel.frame);
            CGFloat zblxViewW = SCREEN_WIDTH;
            CGFloat zblxViewH = 1.0f;
            _zblxView.frame = CGRectMake(zblxViewX, zblxViewY, zblxViewW, zblxViewH);
            
            break;
        }
        case 1 : {  // 1.衡量指标
            CGFloat hlzbLabelX = 0;
            CGFloat hlzbLabelY = 0;
            CGFloat hlzbLabelW = SCREEN_WIDTH;
            CGFloat hlzbLabelH = 30.0f;
            _hlzbLabel.frame = CGRectMake(hlzbLabelX, hlzbLabelY, hlzbLabelW, hlzbLabelH);
            
            CGFloat hlzbTextViewX = padding;
            CGFloat hlzbTextViewY = CGRectGetMaxY(_hlzbLabel.frame);
            CGFloat hlzbTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat hlzbTextViewH = 88.0f;
            _hlzbTextView.frame = CGRectMake(hlzbTextViewX, hlzbTextViewY, hlzbTextViewW, hlzbTextViewH);
            
            CGFloat hlzbViewX = 0;
            CGFloat hlzbViewY = CGRectGetMaxY(_hlzbTextView.frame) + padding;
            CGFloat hlzbViewW = SCREEN_WIDTH;
            CGFloat hlzbViewH = 1.0f;
            _hlzbView.frame = CGRectMake(hlzbViewX, hlzbViewY, hlzbViewW, hlzbViewH);
            
            break;
        }
        case 2 : {  // 2.年度目标值
            CGFloat ndmbzLabelX = 0;
            CGFloat ndmbzLabelY = 0;
            CGFloat ndmbzLabelW = SCREEN_WIDTH;
            CGFloat ndmbzLabelH = 30.0f;
            _ndmbzLabel.frame = CGRectMake(ndmbzLabelX, ndmbzLabelY, ndmbzLabelW, ndmbzLabelH);
            
            CGFloat ndmbzTextViewX = padding;
            CGFloat ndmbzTextViewY = CGRectGetMaxY(_ndmbzLabel.frame);
            CGFloat ndmbzTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat ndmbzTextViewH = 66.0f;
            _ndmbzTextView.frame = CGRectMake(ndmbzTextViewX, ndmbzTextViewY, ndmbzTextViewW, ndmbzTextViewH);
            
            CGFloat ndmbzViewX = 0;
            CGFloat ndmbzViewY = CGRectGetMaxY(_ndmbzTextView.frame) + padding;
            CGFloat ndmbzViewW = SCREEN_WIDTH;
            CGFloat ndmbzViewH = 1.0f;
            _ndmbzView.frame = CGRectMake(ndmbzViewX, ndmbzViewY, ndmbzViewW, ndmbzViewH);
            
            break;
        }
        case 3 : {  // 3.月度目标值
            CGFloat ydmbzLabelX = 0;
            CGFloat ydmbzLabelY = 0;
            CGFloat ydmbzLabelW = SCREEN_WIDTH;
            CGFloat ydmbzLabelH = 30.0f;
            _ydmbzLabel.frame = CGRectMake(ydmbzLabelX, ydmbzLabelY, ydmbzLabelW, ydmbzLabelH);
            
            CGFloat ydmbzTextViewX = padding;
            CGFloat ydmbzTextViewY = CGRectGetMaxY(_ydmbzLabel.frame);
            CGFloat ydmbzTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat ydmbzTextViewH = 66.0f;
            _ydmbzTextView.frame = CGRectMake(ydmbzTextViewX, ydmbzTextViewY, ydmbzTextViewW, ydmbzTextViewH);
            
            CGFloat ydmbzViewX = 0;
            CGFloat ydmbzViewY = CGRectGetMaxY(_ydmbzTextView.frame) + padding;
            CGFloat ydmbzViewW = SCREEN_WIDTH;
            CGFloat ydmbzViewH = 1.0f;
            _ydmbzView.frame = CGRectMake(ydmbzViewX, ydmbzViewY, ydmbzViewW, ydmbzViewH);
            
            break;
        }
        case 4 : {  // 4.考核标准
            CGFloat khbzLabelX = 0;
            CGFloat khbzLabelY = 0;
            CGFloat khbzLabelW = SCREEN_WIDTH;
            CGFloat khbzLabelH = 30.0f;
            _khbzLabel.frame = CGRectMake(khbzLabelX, khbzLabelY, khbzLabelW, khbzLabelH);
            
            CGFloat khbzTextViewX = padding;
            CGFloat khbzTextViewY = CGRectGetMaxY(_khbzLabel.frame);
            CGFloat khbzTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat khbzTextViewH = 66.0f;
            _khbzTextView.frame = CGRectMake(khbzTextViewX, khbzTextViewY, khbzTextViewW, khbzTextViewH);
            
            CGFloat khbzViewX = 0;
            CGFloat khbzViewY = CGRectGetMaxY(_khbzTextView.frame) + padding;
            CGFloat khbzViewW = SCREEN_WIDTH;
            CGFloat khbzViewH = 1.0f;
            _khbzView.frame = CGRectMake(khbzViewX, khbzViewY, khbzViewW, khbzViewH);
            
            break;
        }
        case 5 : {  // 5.行动方案
            CGFloat xdfaLabelX = 0;
            CGFloat xdfaLabelY = 0;
            CGFloat xdfaLabelW = SCREEN_WIDTH;
            CGFloat xdfaLabelH = 30.0f;
            _xdfaLabel.frame = CGRectMake(xdfaLabelX, xdfaLabelY, xdfaLabelW, xdfaLabelH);
            
            CGFloat xdfaTextViewX = padding;
            CGFloat xdfaTextViewY = CGRectGetMaxY(_xdfaLabel.frame);
            CGFloat xdfaTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat xdfaTextViewH = 88.0f;
            _xdfaTextView.frame = CGRectMake(xdfaTextViewX, xdfaTextViewY, xdfaTextViewW, xdfaTextViewH);
            
            CGFloat xdfaViewX = 0;
            CGFloat xdfaViewY = CGRectGetMaxY(_xdfaTextView.frame) + padding;
            CGFloat xdfaViewW = SCREEN_WIDTH;
            CGFloat xdfaViewH = 1.0f;
            _xdfaView.frame = CGRectMake(xdfaViewX, xdfaViewY, xdfaViewW, xdfaViewH);
            
            break;
        }
        case 6 : {  // 6.权重
            CGFloat qzLabelX = 0;
            CGFloat qzLabelY = 0;
            CGFloat qzLabelW = SCREEN_WIDTH * 0.4;
            CGFloat qzLabelH = 44.0f;
            _qzLabel.frame = CGRectMake(qzLabelX, qzLabelY, qzLabelW, qzLabelH);
            
            CGFloat qzTextFieldX = CGRectGetMaxX(_qzLabel.frame);
            CGFloat qzTextFieldH = 30.0f;
            CGFloat qzTextFieldY = qzLabelY + (qzLabelH - qzTextFieldH) / 2;
            CGFloat qzTextFieldW = SCREEN_WIDTH * 0.5;
            _qzTextField.frame = CGRectMake(qzTextFieldX, qzTextFieldY, qzTextFieldW, qzTextFieldH);
            
            CGFloat qzViewX = 0;
            CGFloat qzViewY = CGRectGetMaxY(_qzLabel.frame);
            CGFloat qzViewW = SCREEN_WIDTH;
            CGFloat qzViewH = 1.0f;
            _qzView.frame = CGRectMake(qzViewX, qzViewY, qzViewW, qzViewH);
            
            break;
        }
        case 7 : {  // 7.预计完成时间
            CGFloat yjwcsjLabelX = 0;
            CGFloat yjwcsjLabelY = 0;
            CGFloat yjwcsjLabelW = SCREEN_WIDTH * 0.4;
            CGFloat yjwcsjLabelH = 44.0f;
            _yjwcsjLabel.frame = CGRectMake(yjwcsjLabelX, yjwcsjLabelY, yjwcsjLabelW, yjwcsjLabelH);
            
            CGFloat yjwcsjBtnX = CGRectGetMaxX(_yjwcsjLabel.frame);
            CGFloat yjwcsjBtnH = 30.0f;
            CGFloat yjwcsjBtnY = yjwcsjLabelY + (yjwcsjLabelH - yjwcsjBtnH)/2;
            CGFloat yjwcsjBtnW = SCREEN_WIDTH * 0.5;
            _yjwcsjBtn.frame = CGRectMake(yjwcsjBtnX, yjwcsjBtnY, yjwcsjBtnW, yjwcsjBtnH);
            
            CGFloat yjwcsjViewX = 0;
            CGFloat yjwcsjViewY = CGRectGetMaxY(_yjwcsjLabel.frame);
            CGFloat yjwcsjViewW = SCREEN_WIDTH;
            CGFloat yjwcsjViewH = 1.0f;
            _yjwcsjView.frame = CGRectMake(yjwcsjViewX, yjwcsjViewY, yjwcsjViewW, yjwcsjViewH);
            
            break;
        }
        case 8 : {  // 8.主办人
            CGFloat zbrLabelX = 0;
            CGFloat zbrLabelY = 0;
            CGFloat zbrLabelW = SCREEN_WIDTH * 0.4;
            CGFloat zbrLabelH = 44.0f;
            _zbrLabel.frame = CGRectMake(zbrLabelX, zbrLabelY, zbrLabelW, zbrLabelH);
            
            CGFloat zbrBtnX = CGRectGetMaxX(_zbrLabel.frame);
            CGFloat zbrBtnH = 30.0f;
            CGFloat zbrBtnY = zbrLabelY + (zbrLabelH - zbrBtnH)/2;
            CGFloat zbrBtnW = SCREEN_WIDTH * 0.5;
            _zbrBtn.frame = CGRectMake(zbrBtnX, zbrBtnY, zbrBtnW, zbrBtnH);
            
            CGFloat zbrViewX = 0;
            CGFloat zbrViewY = CGRectGetMaxY(_zbrLabel.frame);
            CGFloat zbrViewW = SCREEN_WIDTH;
            CGFloat zbrViewH = 1.0f;
            _zbrView.frame = CGRectMake(zbrViewX, zbrViewY, zbrViewW, zbrViewH);
            
            break;
        }
        case 9 : {  // 9.交办人
            CGFloat jbrLabelX = 0;
            CGFloat jbrLabelY = 0;
            CGFloat jbrLabelW = SCREEN_WIDTH * 0.4;
            CGFloat jbrLabelH = 44.0f;
            _jbrLabel.frame = CGRectMake(jbrLabelX, jbrLabelY, jbrLabelW, jbrLabelH);
            
            CGFloat jbrBtnX = CGRectGetMaxX(_jbrLabel.frame);
            CGFloat jbrBtnH = 30.0f;
            CGFloat jbrBtnY = jbrLabelY + (jbrLabelH - jbrBtnH)/2;
            CGFloat jbrBtnW = SCREEN_WIDTH * 0.5;
            _jbrBtn.frame = CGRectMake(jbrBtnX, jbrBtnY, jbrBtnW, jbrBtnH);
            
            CGFloat jbrViewX = 0;
            CGFloat jbrViewY = CGRectGetMaxY(_jbrLabel.frame);
            CGFloat jbrViewW = SCREEN_WIDTH;
            CGFloat jbrViewH = 1.0f;
            _jbrView.frame = CGRectMake(jbrViewX, jbrViewY, jbrViewW, jbrViewH);
            
            break;
        }
        case 10 : { // 10.协办人
            CGFloat xbrLabelX = 0;
            CGFloat xbrLabelY = 0;
            CGFloat xbrLabelW = SCREEN_WIDTH * 0.4;
            CGFloat xbrLabelH = 44.0f;
            _xbrLabel.frame = CGRectMake(xbrLabelX, xbrLabelY, xbrLabelW, xbrLabelH);
            
            CGFloat xbrBtnX = CGRectGetMaxX(_xbrLabel.frame);
            CGFloat xbrBtnH = 30.0f;
            CGFloat xbrBtnY = xbrLabelY + (xbrLabelH - xbrBtnH)/2;
            CGFloat xbrBtnW = SCREEN_WIDTH * 0.5;
            _xbrBtn.frame = CGRectMake(xbrBtnX, xbrBtnY, xbrBtnW, xbrBtnH);
            
            CGFloat xbrViewX = 0;
            CGFloat xbrViewY = CGRectGetMaxY(_xbrLabel.frame);
            CGFloat xbrViewW = SCREEN_WIDTH;
            CGFloat xbrViewH = 1.0f;
            _xbrView.frame = CGRectMake(xbrViewX, xbrViewY, xbrViewW, xbrViewH);
            
            break;
        }
        case 11 : { // 11.打分领导
            CGFloat dfldLabelX = 0;
            CGFloat dfldLabelY = 0;
            CGFloat dfldLabelW = SCREEN_WIDTH * 0.4;
            CGFloat dfldLabelH = 44.0f;
            _dfldLabel.frame = CGRectMake(dfldLabelX, dfldLabelY, dfldLabelW, dfldLabelH);
            
            CGFloat dfldBtnX = CGRectGetMaxX(_dfldLabel.frame);
            CGFloat dfldBtnH = 30.0f;
            CGFloat dfldBtnY = dfldLabelY + (dfldLabelH - dfldBtnH)/2;
            CGFloat dfldBtnW = SCREEN_WIDTH * 0.5;
            _dfldBtn.frame = CGRectMake(dfldBtnX, dfldBtnY, dfldBtnW, dfldBtnH);
            
            CGFloat dfldViewX = 0;
            CGFloat dfldViewY = CGRectGetMaxY(_dfldLabel.frame);
            CGFloat dfldViewW = SCREEN_WIDTH;
            CGFloat dfldViewH = 1.0f;
            _dfldView.frame = CGRectMake(dfldViewX, dfldViewY, dfldViewW, dfldViewH);
            
            break;
        }
        default:
            break;
    }
}

/**
 *  设置 控件状态
 */
- (void)settingState {
    if (![self.monthPlan.state intValue]) {
        self.contentView.userInteractionEnabled = YES;
    }else{
        self.contentView.userInteractionEnabled = NO;
    }
}

/**
 *  设置 权重分状态
 */
- (void)setQzState {
    LoadViewController *loadVc = [LoadViewController shareInstance];
    if ([loadVc.emp.xzzj intValue] > 2) {
        self.qzTextField.userInteractionEnabled = NO;
    }else{
        self.qzTextField.userInteractionEnabled = YES;
    }
}

#pragma mark - 预计完成时间
- (void)yjwcsjBtnClick:(UIButton *)yjwcsjBtn {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - cover
- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _cover;
}

- (void)tapCover{
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.cover removeFromSuperview];
    }];
}

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            _monthPlan.yjwc = datePickerView.selectedDate;
            [self.yjwcsjBtn setTitle:datePickerView.selectedDate forState:UIControlStateNormal];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 点击 主办人 按钮
- (void)zbrBtnClick:(UIButton *)zbrBtn {
    if ([self.delegate respondsToSelector:@selector(monthPlanDetailCellDidClickZbrBtn:)]) {
        [self.delegate monthPlanDetailCellDidClickZbrBtn:self];
    }
}

#pragma mark - 点击 协办人 按钮
- (void)xbrBtnClick:(UIButton *)xbrBtn {
    if ([self.delegate respondsToSelector:@selector(monthPlanDetailCellDidClickXbrBtn:)]) {
        [self.delegate monthPlanDetailCellDidClickXbrBtn:self];
    }
}

#pragma mark - 点击 打分领导 按钮
- (void)dfldBtnClick:(UIButton *)dfldBtn {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        NSMutableArray *sjld_name = [NSMutableArray array];
        for (SJLD *sjld in self.sjld) {
            [sjld_name addObject:sjld.ygxm];
        }
        _selectPickerView.dataArry = sjld_name;
        _selectPickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - SelectPickerViewDelegate
- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case SelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case SelectPickerViewButtonTypeSure:{
            SJLD *sjld = [self.sjld objectAtIndex:selectPickerView.index];
            self.monthPlan.dfld = sjld.ygbm;
            self.monthPlan.n_dfld = sjld.ygxm;
            [self.dfldBtn setTitle:sjld.ygxm forState:UIControlStateNormal];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    switch (textView.tag) {
            /** 0.衡量指标 */
        case 0:
            self.monthPlan.hlzb = textView.text;
            break;
            /** 1.年度目标值 */
        case 1:
            self.monthPlan.gznr = textView.text;
            break;
            /** 2.月度目标值 */
        case 2:
            self.monthPlan.ygznr = textView.text;
            break;
            /** 3.考核标准 */
        case 3:
            self.monthPlan.khbz = textView.text;
            break;
            /** 4.行动方案 */
        case 4:
            self.monthPlan.xdfa = textView.text;
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }else{
        NSString *numbers = @"0123456789";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
}

- (void)valueChange:(UITextField *)textField {
    NSString *tempStr = [self getTheCorrectNum:textField.text];
    if ([tempStr length] > 0) {
        self.monthPlan.fz = tempStr;
    }else{
        self.monthPlan.fz = @"0";
    }
}

- (NSString *)getTheCorrectNum:(NSString *)tempString {
    while ([tempString hasPrefix:@"0"]) {
        tempString = [tempString substringFromIndex:1];
    }
    return tempString;
}

@end
