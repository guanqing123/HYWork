//
//  WeekPlanDetailCell.m
//  HYWork
//
//  Created by information on 16/5/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanDetailCell.h"
#import "InsetsLabel.h"
#import "CustomButton.h"
#import "HYButton.h"
#import "TxlViewController.h"
#import "DatePickerView.h"
#import "SelectPickerView.h"
#import "SJLD.h"


#define TextFont [UIFont systemFontOfSize:14.0f]

@interface WeekPlanDetailCell() <UITextViewDelegate,datePickerDelegate,UIGestureRecognizerDelegate,SelectPickerViewDelegate>
/**
 *  工作类型
 */
@property (nonatomic, weak) UILabel  *gzlbLabel;
@property (nonatomic, weak) CustomButton *gzlbBtn;
@property (nonatomic, weak) UIView  *gzlbView;
/**
 *  工作任务
 */
@property (nonatomic, weak) UILabel  *gzrwLabel;
@property (nonatomic, weak) UITextView  *gzrwTextView;
@property (nonatomic, weak) UIView  *gzrwView;
/**
 *  行动计划
 */
@property (nonatomic, weak) UILabel  *xdjhLabel;
@property (nonatomic, weak) UITextView  *xdjhTextView;
@property (nonatomic, weak) UIView  *xdjhView;
/**
 *  达成目标
 */
@property (nonatomic, weak) UILabel  *dcmbLabel;
@property (nonatomic, weak) UITextView  *dcmbTextView;
@property (nonatomic, weak) UIView  *dcmbView;
/**
 *  预计完成时间
 */
@property (nonatomic, weak) UILabel  *yjwcsjLabel;
@property (nonatomic, weak) CustomButton  *yjwcsjBtn;
@property (nonatomic, weak) UIView  *yjwcsjView;
/**
 *  主办人
 */
@property (nonatomic, weak) UILabel  *zbrLabel;
@property (nonatomic, weak) CustomButton  *zbrBtn;
@property (nonatomic, weak) UIView  *zbrView;
/**
 *  交办人
 */
@property (nonatomic, weak) UILabel  *jbrLabel;
@property (nonatomic, weak) CustomButton  *jbrBtn;
@property (nonatomic, weak) UIView  *jbrView;
/**
 *  协办人
 */
@property (nonatomic, weak) UILabel  *xbrLabel;
@property (nonatomic, weak) HYButton  *xbrBtn;
@property (nonatomic, weak) UIView  *xbrView;
/**
 *  打分领导
 */
@property (nonatomic, weak) UILabel  *dfldLabel;
@property (nonatomic, weak) CustomButton  *dfldBtn;
@property (nonatomic, weak) UIView  *dfldView;

/**
 *  日期选择器
 */
@property (nonatomic, strong) DatePickerView  *datePickerView;
@property (nonatomic, strong)  UIView *cover;
@property (nonatomic, strong) SelectPickerView *selectPickerView;

@end

@implementation WeekPlanDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView rowIndex:(NSInteger)rowIndex {
    WeekPlanDetailCell *cell = [[WeekPlanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil rowIndex:rowIndex];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowIndex:(NSInteger)rowIndex{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _rowIndex = rowIndex;
        CGFloat padding = 10;
        switch (rowIndex) {
            case 0 : {  // 0.工作类别
                InsetsLabel *gzlbLabel = [[InsetsLabel alloc] init];
                gzlbLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                gzlbLabel.text = @"工作类别:";
                gzlbLabel.font = TextFont;
                gzlbLabel.textColor = [UIColor grayColor];
                _gzlbLabel = gzlbLabel;
                [self.contentView addSubview:gzlbLabel];
                
                CustomButton *gzlbBtn = [CustomButton customButton];
                [gzlbBtn addTarget:self action:@selector(gzlbBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [gzlbBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                _gzlbBtn = gzlbBtn;
                [self.contentView addSubview:gzlbBtn];
                
                UIView *gzlbView = [[UIView alloc] init];
                gzlbView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _gzlbView = gzlbView;
                [self.contentView addSubview:gzlbView];

                break;
            }
            case 1 : {  // 1.工作任务
                InsetsLabel *gzrwLabel = [[InsetsLabel alloc] init];
                gzrwLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                gzrwLabel.text = @"工作任务(目标):";
                gzrwLabel.font = TextFont;
                gzrwLabel.textColor = [UIColor grayColor];
                _gzrwLabel = gzrwLabel;
                [self.contentView addSubview:gzrwLabel];
                
                UITextView *gzrwTextView = [[UITextView alloc] init];
                gzrwTextView.tag = 0;
                gzrwTextView.font = TextFont;
                gzrwTextView.layer.borderWidth  = 1.0f;
                gzrwTextView.layer.cornerRadius = 5.0;
                gzrwTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                gzrwTextView.delegate = self;
                gzrwTextView.returnKeyType = UIReturnKeyDone;
                _gzrwTextView = gzrwTextView;
                [self.contentView addSubview:gzrwTextView];
                
                UIView *gzrwView = [[UIView alloc] init];
                gzrwView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _gzrwView = gzrwView;
                [self.contentView addSubview:gzrwView];
                
                break;
            }
            case 2 : {  // 2.行动计划
                InsetsLabel *xdjhLabel = [[InsetsLabel alloc] init];
                xdjhLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                xdjhLabel.text = @"行动计划:";
                xdjhLabel.font = TextFont;
                xdjhLabel.textColor = [UIColor grayColor];
                _xdjhLabel = xdjhLabel;
                [self.contentView addSubview:xdjhLabel];
                
                UITextView *xdjhTextView = [[UITextView alloc] init];
                xdjhTextView.tag = 1;
                xdjhTextView.font = TextFont;
                xdjhTextView.layer.borderWidth  = 1.0f;
                xdjhTextView.layer.cornerRadius = 5.0;
                xdjhTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                xdjhTextView.delegate = self;
                xdjhTextView.returnKeyType = UIReturnKeyDone;
                _xdjhTextView = xdjhTextView;
                [self.contentView addSubview:xdjhTextView];
                
                UIView *xdjhView = [[UIView alloc] init];
                xdjhView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _xdjhView = xdjhView;
                [self.contentView addSubview:xdjhView];
                
                break;
            }
            case 3 : {  // 3.达成目标
                InsetsLabel *dcmbLabel = [[InsetsLabel alloc] init];
                dcmbLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
                dcmbLabel.text = @"达成目标:";
                dcmbLabel.font = TextFont;
                dcmbLabel.textColor = [UIColor grayColor];
                _dcmbLabel = dcmbLabel;
                [self.contentView addSubview:dcmbLabel];
                
                UITextView *dcmbTextView = [[UITextView alloc] init];
                dcmbTextView.tag = 2;
                dcmbTextView.font = TextFont;
                dcmbTextView.layer.borderWidth  = 1.0f;
                dcmbTextView.layer.cornerRadius = 5.0;
                dcmbTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                dcmbTextView.delegate = self;
                dcmbTextView.returnKeyType = UIReturnKeyDone;
                _dcmbTextView = dcmbTextView;
                [self.contentView addSubview:dcmbTextView];
                
                UIView *dcmbView = [[UIView alloc] init];
                dcmbView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                _dcmbView = dcmbView;
                [self.contentView addSubview:dcmbView];
                
                break;
            }
            case 4 : {  // 4.预计完成时间
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
            case 5 : {  // 5.主办人
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
            case 6 : {  // 6.交办人
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
            case 7 : {  // 7.协办人
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
            case 8 : {  // 8.打分领导
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

- (void)setWeekPlan:(WeekPlan *)weekPlan {
    _weekPlan = weekPlan;
    
    // 1.设置数据
    [self settingData];
    
    // 2.设置frame
    [self settingFrame];
    
    // 3.设置控件状态
    [self settingState];
}

+ (CGFloat)cellHeight:(NSInteger)rowIndex {
    CGFloat cellHeight = 0;
    switch (rowIndex) {
        case 0 : // 0.工作类别
            cellHeight = 45.0f;
            break;
        case 1 : // 1.工作任务
            cellHeight = 129.0f;
            break;
        case 2 : // 2.行动计划
            cellHeight = 129.0f;
            break;
        case 3 : // 3.达成目标
            cellHeight = 129.0f;
            break;
        case 4 : // 4.预计完成时间
            cellHeight = 45.0f;
            break;
        case 5 : // 5.主办人
            cellHeight = 45.0f;
            break;
        case 6 : // 6.交办人
            cellHeight = 45.0f;
            break;
        case 7 : // 7.协办人
            cellHeight = 45.0f;
            break;
        case 8 : // 8.打分领导
            cellHeight = 50.0f;
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
        case 0 : {  // 0.工作类别
            if ([self.weekPlan.jhlb isEqualToString:@"1"]) {
                [self.gzlbBtn setVal:@"1" andDis:@"日常工作"];
            }else{
                [self.gzlbBtn setVal:@"2" andDis:@"出差"];
            }
            break;
        }
        case 1 :  {  // 1.工作任务
            if ([self.weekPlan.mbz isKindOfClass:[NSNull class]]) {
                self.gzrwTextView.text = @"";
            }else{
                self.gzrwTextView.text = self.weekPlan.mbz;
            }
            break;
        }
        case 2 : {    // 2.行动计划
            if ([self.weekPlan.gkmb isKindOfClass:[NSNull class]]) {
                self.xdjhTextView.text = @"";
            }else{
                self.xdjhTextView.text = self.weekPlan.gkmb;
            }
            break;
        }
        case 3 :  {  // 3.达成目标
            if ([self.weekPlan.gznr isKindOfClass:[NSNull class]]) {
                self.dcmbTextView.text = @"";
            }else{
                self.dcmbTextView.text = self.weekPlan.gznr;
            }
            break;
        }
        case 4 : {    // 4.预计完成时间
            if ([self.weekPlan.yjwc isKindOfClass:[NSNull class]]) {
                [self.yjwcsjBtn setVal:@"" andDis:@""];
            }else{
                [self.yjwcsjBtn setVal:self.weekPlan.yjwc andDis:self.weekPlan.yjwc];
            }
            break;
        }
        case 5 : {   // 5.主办人
            if ([self.weekPlan.cbr isKindOfClass:[NSNull class]]) {
                [self.zbrBtn setVal:@"" andDis:@""];
            }else{
                [self.zbrBtn setVal:self.weekPlan.cbr andDis:self.weekPlan.n_cbr];
            }
            break;
        }
        case 6 : {   // 6.交办人
            if ([self.weekPlan.fbr isKindOfClass:[NSNull class]]) {
                [self.jbrBtn setVal:@"" andDis:@""];
            }else{
                [self.jbrBtn setVal:self.weekPlan.fbr andDis:self.weekPlan.n_fbr];
            }
            break;
        }
        case 7 : {   // 7.协办人
            if ([self.weekPlan.xbr isKindOfClass:[NSNull class]]) {
                [self.xbrBtn setVal:@"" andDis:@""];
            }else{
                [self.xbrBtn setVal:self.weekPlan.xbr andDis:self.weekPlan.n_xbr];
            }
            break;
        }
        case 8 :  {  // 8.打分领导
            if ([self.weekPlan.dfld isKindOfClass:[NSNull class]]) {
                [self.dfldBtn setVal:@"" andDis:@""];
            }else{
                [self.dfldBtn setVal:self.weekPlan.dfld andDis:self.weekPlan.n_dfld];
            }
            break;
        }
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
        case 0 : {  // 0.工作类别
            CGFloat gzlbLabelX = 0;
            CGFloat gzlbLabelY = 0;
            CGFloat gzlbLabelW = SCREEN_WIDTH * 0.4;
            CGFloat gzlbLabelH = 44.0f;
            _gzlbLabel.frame = CGRectMake(gzlbLabelX, gzlbLabelY, gzlbLabelW, gzlbLabelH);
            
            CGFloat gzlbBtnX = CGRectGetMaxX(_gzlbLabel.frame);
            CGFloat gzlbBtnH = 30.0f;
            CGFloat gzlbBtnY = (gzlbLabelH - gzlbBtnH)/2;
            CGFloat gzlbBtnW = SCREEN_WIDTH * 0.5;
            _gzlbBtn.frame = CGRectMake(gzlbBtnX, gzlbBtnY, gzlbBtnW, gzlbBtnH);
            
            CGFloat gzlbViewX = 0;
            CGFloat gzlbViewY = CGRectGetMaxY(_gzlbLabel.frame);
            CGFloat gzlbViewW = SCREEN_WIDTH;
            CGFloat gzlbViewH = 1.0f;
            _gzlbView.frame = CGRectMake(gzlbViewX, gzlbViewY, gzlbViewW, gzlbViewH);
            break;
        }
        case 1 : {  // 1.工作任务
            CGFloat gzrwLabelX = 0;
            CGFloat gzrwLabelY = 0;
            CGFloat gzrwLabelW = SCREEN_WIDTH;
            CGFloat gzrwLabelH = 30.0f;
            _gzrwLabel.frame = CGRectMake(gzrwLabelX, gzrwLabelY, gzrwLabelW, gzrwLabelH);
            
            CGFloat gzrwTextViewX = padding;
            CGFloat gzrwTextViewY = CGRectGetMaxY(_gzrwLabel.frame);
            CGFloat gzrwTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat gzrwTextViewH = 88.0f;
            _gzrwTextView.frame = CGRectMake(gzrwTextViewX, gzrwTextViewY, gzrwTextViewW, gzrwTextViewH);
            
            CGFloat gzrwViewX = 0;
            CGFloat gzrwViewY = CGRectGetMaxY(_gzrwTextView.frame) + padding;
            CGFloat gzrwViewW = SCREEN_WIDTH;
            CGFloat gzrwViewH = 1.0f;
            _gzrwView.frame = CGRectMake(gzrwViewX, gzrwViewY, gzrwViewW, gzrwViewH);
            break;
        }
        case 2 : {  // 2.行动计划
            CGFloat xdjhLabelX = 0;
            CGFloat xdjhLabelY = 0;
            CGFloat xdjhLabelW = SCREEN_WIDTH;
            CGFloat xdjhLabelH = 30.0f;
            _xdjhLabel.frame = CGRectMake(xdjhLabelX, xdjhLabelY, xdjhLabelW, xdjhLabelH);
            
            CGFloat xdjhTextViewX = padding;
            CGFloat xdjhTextViewY = CGRectGetMaxY(_xdjhLabel.frame);
            CGFloat xdjhTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat xdjhTextViewH = 88.0f;
            _xdjhTextView.frame = CGRectMake(xdjhTextViewX, xdjhTextViewY, xdjhTextViewW, xdjhTextViewH);
            
            CGFloat xdjhViewX = 0;
            CGFloat xdjhViewY = CGRectGetMaxY(_xdjhTextView.frame) + padding;
            CGFloat xdjhViewW = SCREEN_WIDTH;
            CGFloat xdjhViewH = 1.0f;
            _xdjhView.frame = CGRectMake(xdjhViewX, xdjhViewY, xdjhViewW, xdjhViewH);
            break;
        }
        case 3 : {  // 3.达成目标
            CGFloat dcmbLabelX = 0;
            CGFloat dcmbLabelY = 0;
            CGFloat dcmbLabelW = SCREEN_WIDTH;
            CGFloat dcmbLabelH = 30.0f;
            _dcmbLabel.frame = CGRectMake(dcmbLabelX, dcmbLabelY, dcmbLabelW, dcmbLabelH);
            
            CGFloat dcmbTextViewX = padding;
            CGFloat dcmbTextViewY = CGRectGetMaxY(_dcmbLabel.frame);
            CGFloat dcmbTextViewW = SCREEN_WIDTH - padding * 2;
            CGFloat dcmbTextViewH = 88.0f;
            _dcmbTextView.frame = CGRectMake(dcmbTextViewX, dcmbTextViewY, dcmbTextViewW, dcmbTextViewH);
            
            CGFloat dcmbViewX = 0;
            CGFloat dcmbViewY = CGRectGetMaxY(_dcmbTextView.frame) + padding;
            CGFloat dcmbViewW = SCREEN_WIDTH;
            CGFloat dcmbViewH = 1.0f;
            _dcmbView.frame = CGRectMake(dcmbViewX, dcmbViewY, dcmbViewW, dcmbViewH);
            break;
        }
        case 4 : {  // 4.预计完成时间
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
        case 5 : {  // 5.主办人
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
        case 6 : {  // 6.交办人
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
        case 7 : {  // 7.协办人
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
        case 8 : {  // 8.打分领导
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
    if (![self.weekPlan.state intValue]) {
        self.contentView.userInteractionEnabled = YES;
    }else{
        self.contentView.userInteractionEnabled = NO;
    }
}

/** 点击 工作类别 按钮 */
- (void)gzlbBtnClick:(UIButton *)gzlbBtn {
    if ([self.delegate respondsToSelector:@selector(weekPlanDetailCellDidClickGzlbBtn:)]) {
        [self.delegate weekPlanDetailCellDidClickGzlbBtn:self];
    }
}

#pragma mark - cover懒加载
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.cover.subviews count]>0 && CGRectContainsPoint(self.cover.subviews[0].frame, point)) {
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

#pragma mark - 预计完成时间
/** 点击 预计完成时间 按钮 */
- (void)yjwcsjBtnClick:(UIButton *)yjwcsjBtn {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - datePickerDelegate
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            self.weekPlan.yjwc = datePickerView.selectedDate;
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
    if ([self.delegate respondsToSelector:@selector(weekPlanDetailCellDidClickZbrBtn:)]) {
        [self.delegate weekPlanDetailCellDidClickZbrBtn:self];
    }
}

#pragma mark - 点击 协办人 按钮
- (void)xbrBtnClick:(UIButton *)xbrBtn {
    if ([self.delegate respondsToSelector:@selector(weekPlanDetailCellDidClickXbrBtn:)]) {
        [self.delegate weekPlanDetailCellDidClickXbrBtn:self];
    }
}

#pragma mark - 打分领导
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
            _weekPlan.dfld = sjld.ygbm;
            _weekPlan.n_dfld = sjld.ygxm;
            [_dfldBtn setTitle:sjld.ygxm forState:UIControlStateNormal];
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    switch (textView.tag) {
        case 0:
            self.weekPlan.mbz = textView.text;
            break;
        case 1:
            self.weekPlan.gkmb = textView.text;
            break;
        case 2:
            self.weekPlan.gznr = textView.text;
            break;
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    switch (textView.tag) {
        case 0:
            self.weekPlan.mbz = textView.text;
            break;
        case 1:
            self.weekPlan.gkmb = textView.text;
            break;
        case 2:
            self.weekPlan.gznr = textView.text;
            break;
        default:
            break;
    }
}

@end
