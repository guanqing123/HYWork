//
//  PlanWriteTableCell.m
//  HYWork
//
//  Created by information on 2017/5/22.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#define paddingX 10
#define paddingY 5
#define lineHeight 1

#import "PlanWriteTableCell.h"
#import "CustomerLabel.h"
#import "CustomButton.h"
#import "UITextView+Placeholder.h"
#import "DatePickerView.h"
#import "TimePickerView.h"
#import "SelectPickerView.h"
#import "MultiSelectPickerView.h"
#import "WKWorkTypeResult.h"
#import "WKProjectResult.h"

@interface PlanWriteTableCell()<UITextFieldDelegate,datePickerDelegate,timePickerDelegate,SelectPickerViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,MultiSelectPickerViewDelegate>
/** 标题topLineView */
@property (nonatomic, weak) UIView  *titleTopLineView;
/** 标题field */
@property (nonatomic, weak) UITextField  *titleField;
/** 标题bottomLineView */
@property (nonatomic, weak) UIView  *titleBottomLineView;


/** 全天topLineView */
@property (nonatomic, weak) UIView  *allDayTopLineView;
/** 全天lable */
@property (nonatomic, weak) CustomerLabel  *allDayLabel;
/** 全天Switch */
@property (nonatomic, strong) UISwitch  *switchView;
/** 全天bottomLineView */
@property (nonatomic, weak) UIView  *allDayBottomLineView;

/** 日期lable */
@property (nonatomic, weak) CustomerLabel  *dateLabel;
/** 日期button */
@property (nonatomic, strong) CustomButton  *dateBtn;
/** 日期bottomLineView */
@property (nonatomic, weak) UIView  *dateBottomLineView;

/** 时间lable */
@property (nonatomic, weak) CustomerLabel  *timeLabel;
/** 时间button */
@property (nonatomic, strong) CustomButton  *timeBtn;
/** 时间bottomLineView */
@property (nonatomic, weak) UIView  *timeBottomLineView;


/** 类型topLineView */
@property (nonatomic, weak) UIView  *planTypeTopLineView;
/** 类型lable */
@property (nonatomic, weak) CustomerLabel  *planTypeLabel;
/** 类型btn */
@property (nonatomic, weak) CustomButton  *planTypeBtn;
/** 类型bottomLineView */
@property (nonatomic, weak) UIView  *planTypeBottomLineView;

/** 标签lable */
@property (nonatomic, weak) CustomerLabel  *markLabel;

/** 拜访客户btn */
@property (nonatomic, weak) UIButton  *visitBpcBtn;
/** 重要工作btn */
@property (nonatomic, weak) UIButton  *importantWorkBtn;
/** 随笔btn */
@property (nonatomic, weak) UIButton  *noteBtn;
/** 绿色btn */
@property (nonatomic, weak) UIButton  *greenBtn;

/** 类型bottomLineView */
@property (nonatomic, weak) UIView  *markBottomLineView;

/** 承办人label */
@property (nonatomic, weak) CustomerLabel  *operatorLabel;
/** 承办人textfield */
@property (nonatomic, weak) UITextField  *operatorTextField;
/** 承办人btn */
@property (nonatomic, weak) UIButton  *operatorSearchBtn;
/** 承办人bottomLineView */
@property (nonatomic, weak) UIView  *operatorBottomLineView;

/** 客户类型topLineView */
@property (nonatomic, weak) UIView  *bpcTypeTopLineView;
/** 客户类型lable */
@property (nonatomic, weak) CustomerLabel  *bpcTypeLabel;
/** 客户类型btn */
@property (nonatomic, weak) CustomButton  *bpcTypeBtn;
/** 客户类型bottomLineView */
@property (nonatomic, weak) UIView  *bpcTypeBottomLineView;

/** 客户lable */
@property (nonatomic, weak) CustomerLabel  *bpcLabel;
/** 客户textfield */
@property (nonatomic, weak) UITextField  *bpcTextField;
/** 客户检索btn */
@property (nonatomic, weak) UIButton  *bpcSearchBtn;
/** 客户bottomLineView */
@property (nonatomic, weak) UIView  *bpcBottomLineView;

/** tel lable */
@property (nonatomic, weak) CustomerLabel  *telLabel;
/** tel textfield */
@property (nonatomic, weak) UITextField  *telTextField;
/** tel btn */
@property (nonatomic, weak) UIButton  *telSearchBtn;
/** tel bottomLineView */
@property (nonatomic, weak) UIView  *telBottomLineView;

/** contact lable */
@property (nonatomic, weak) CustomerLabel  *contactLabel;
/** contact textfield */
@property (nonatomic, weak) UITextField  *contactTextField;
/** contact bottomLineView */
@property (nonatomic, weak) UIView  *contactBottomLineView;

/** 客户工作类别 */
@property (nonatomic, weak) CustomerLabel  *workTypeLabel;
@property (nonatomic, weak) CustomButton  *workTypeBtn;
@property (nonatomic, weak) UIView  *workTypeBottomLineView;

/** 客户具体工作项 */
@property (nonatomic, weak) CustomerLabel  *workLabel;
@property (nonatomic, weak) CustomButton  *workBtn;
@property (nonatomic, weak) UIView  *workBottomLineView;

/** 工程项目 */
@property (nonatomic, weak) CustomerLabel  *projectLabel;
@property (nonatomic, weak) CustomButton  *projectBtn;
@property (nonatomic, weak) UIView  *projectBottomLineView;

/** 备注 */
@property (nonatomic, weak) CustomerLabel  *bzLabel;
@property (nonatomic, weak) UITextField  *bzTextField;
@property (nonatomic, weak) UIView  *bzBottomLineView;

/** 足迹lable */
@property (nonatomic, weak) CustomerLabel  *trackLabel;
/** 足迹textfield */
@property (nonatomic, weak) UILabel  *trackTextLabel;
/** 足迹btn */
@property (nonatomic, weak) UIButton  *trackBtn;
/** 足迹bottomLineView */
@property (nonatomic, weak) UIView  *trackBottomLineView;

/** content textView */
@property (nonatomic, weak) UITextView  *contentTextView;
/** content bottomLineView */
@property (nonatomic, weak) UIView  *contentBottomLineView;

/** 背景父元素 */
@property (nonatomic, strong)  UIView *cover;
/** 日期选择器 */
@property (nonatomic, strong)  DatePickerView *datePickerView;
/** 时间选择器 */
@property (nonatomic, strong)  TimePickerView *timePickerView;

/** 类型选择器 */
@property (nonatomic, strong)  SelectPickerView *selectPickerView;

@property (nonatomic, strong)  MultiSelectPickerView *multiSelectPickerView;

/** 类型选择器数据来源 */
@property (nonatomic, strong)  NSMutableArray *planTypeSource;
@property (nonatomic, strong)  NSMutableDictionary *planTypeDict;

/** 客户类型选择器数据来源 */
@property (nonatomic, strong)  NSMutableArray *bpcTypeSource;
@property (nonatomic, strong)  NSMutableDictionary *bpcTypeDict;
@property (nonatomic, strong)  NSArray *bpcTypeArray;
@end

@implementation PlanWriteTableCell

+ (instancetype)cellWithTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    PlanWriteTableCell *cell = [[PlanWriteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil indexPath:indexPath];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _indexPath = indexPath;
        switch (_indexPath.section) {
            case 0:{
                UIView *titleTopLineView = [[UIView alloc] init];
                titleTopLineView.backgroundColor = GQColor(204, 204, 204);
                self.titleTopLineView = titleTopLineView;
                [self.contentView addSubview:titleTopLineView];
                
                UITextField *titleField = [[UITextField alloc] init];
                titleField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
                titleField.leftViewMode = UITextFieldViewModeAlways;
                titleField.placeholder = @"标题";
                titleField.delegate = self;
                titleField.tag = 1;
                titleField.returnKeyType = UIReturnKeyDone;
                titleField.textAlignment = NSTextAlignmentCenter;
                titleField.font = [UIFont systemFontOfSize:15.0f];
                titleField.clearButtonMode = UITextFieldViewModeAlways;
                [self.contentView addSubview:titleField];
                self.titleField = titleField;
                
                UIView *titleBottomLineView = [[UIView alloc] init];
                titleBottomLineView.backgroundColor = GQColor(204, 204, 204);
                self.titleBottomLineView = titleBottomLineView;
                [self.contentView addSubview:titleBottomLineView];
                break;
            }
            case 1:{
                switch (_indexPath.row) {
                    case 0:{
                        UIView *allDayTopLineView = [[UIView alloc] init];
                        allDayTopLineView.backgroundColor = GQColor(204, 204, 204);
                        self.allDayTopLineView = allDayTopLineView;
                        [self.contentView addSubview:allDayTopLineView];
                        
                        CustomerLabel *allDayLabel = [[CustomerLabel alloc] init];
                        allDayLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        allDayLabel.text = @"全天";
                        self.allDayLabel = allDayLabel;
                        [self.contentView addSubview:allDayLabel];
                        
                        self.accessoryView = self.switchView;
                        
                        UIView *allDayBottomLineView = [[UIView alloc] init];
                        allDayBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.allDayBottomLineView = allDayBottomLineView;
                        [self.contentView addSubview:allDayBottomLineView];
                        break;
                    }
                    case 1:{
                        CustomerLabel *dateLabel = [[CustomerLabel alloc] init];
                        dateLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        dateLabel.text = @"日期";
                        self.dateLabel = dateLabel;
                        [self.contentView addSubview:dateLabel];
                        
                        CustomButton *dateBtn = [[CustomButton alloc] init];
                        [dateBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [dateBtn addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.dateBtn = dateBtn;
                        [self.contentView addSubview:dateBtn];
                        
                        UIView *dateBottomLineView = [[UIView alloc] init];
                        dateBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.dateBottomLineView = dateBottomLineView;
                        [self.contentView addSubview:dateBottomLineView];
                        break;
                    }
                    case 2:{
                        CustomerLabel *timeLabel = [[CustomerLabel alloc] init];
                        timeLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        timeLabel.text = @"时间";
                        self.timeLabel = timeLabel;
                        [self.contentView addSubview:timeLabel];
                        
                        CustomButton *timeBtn = [[CustomButton alloc] init];
                        [timeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.timeBtn = timeBtn;
                        [self.contentView addSubview:timeBtn];
                        
                        UIView *timeBottomLineView = [[UIView alloc] init];
                        timeBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.timeBottomLineView = timeBottomLineView;
                        [self.contentView addSubview:timeBottomLineView];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 2:{
                switch (_indexPath.row) {
                    case 0:{
                        UIView *planTypeTopLineView = [[UIView alloc] init];
                        planTypeTopLineView.backgroundColor = GQColor(204, 204, 204);
                        self.planTypeTopLineView = planTypeTopLineView;
                        [self.contentView addSubview:planTypeTopLineView];
                        
                        CustomerLabel *planTypeLabel = [[CustomerLabel alloc] init];
                        planTypeLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        planTypeLabel.text = @"工作项";
                        self.planTypeLabel = planTypeLabel;
                        [self.contentView addSubview:planTypeLabel];
                        
                        CustomButton *planTypeBtn = [[CustomButton alloc] init];
                        [planTypeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [planTypeBtn addTarget:self action:@selector(planTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.planTypeBtn = planTypeBtn;
                        [self.contentView addSubview:planTypeBtn];
                        
                        UIView *planTypeBottomLineView = [[UIView alloc] init];
                        planTypeBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.planTypeBottomLineView = planTypeBottomLineView;
                        [self.contentView addSubview:planTypeBottomLineView];
                        break;
                    }
                    case 1:{
                        CustomerLabel  *markLabel = [[CustomerLabel alloc] init];
                        markLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        markLabel.text = @"标签";
                        self.markLabel = markLabel;
                        [self.contentView addSubview:markLabel];
                        
                        UIButton *visitBpcBtn = [[UIButton alloc] init];
                        [visitBpcBtn setImage:[UIImage imageNamed:@"tab_1_54_0"] forState:UIControlStateNormal];
                        [visitBpcBtn setImage:[UIImage imageNamed:@"tab_1_54_1"] forState:UIControlStateSelected];
                        self.visitBpcBtn = visitBpcBtn;
                        [self.contentView addSubview:visitBpcBtn];
                        
                        UIButton *importantWorkBtn = [[UIButton alloc] init];
                        [importantWorkBtn setImage:[UIImage imageNamed:@"tab_3_54_0"] forState:UIControlStateNormal];
                        [importantWorkBtn setImage:[UIImage imageNamed:@"tab_3_54_1"] forState:UIControlStateSelected];
                        self.importantWorkBtn = importantWorkBtn;
                        [self.contentView addSubview:importantWorkBtn];
                        
                        UIButton *noteBtn = [[UIButton alloc] init];
                        [noteBtn setImage:[UIImage imageNamed:@"tab_2_54_0"] forState:UIControlStateNormal];
                        [noteBtn setImage:[UIImage imageNamed:@"tab_2_54_1"] forState:UIControlStateSelected];
                        self.noteBtn = noteBtn;
                        [self.contentView addSubview:noteBtn];
                        
                        UIButton *greenBtn = [[UIButton alloc] init];
                        [greenBtn setImage:[UIImage imageNamed:@"tab_4_54_0"] forState:UIControlStateNormal];
                        [greenBtn setImage:[UIImage imageNamed:@"tab_4_54_1"] forState:UIControlStateSelected];
                        self.greenBtn = greenBtn;
                        [self.contentView addSubview:greenBtn];
      
                        UIView *markBottomLineView = [[UIView alloc] init];
                        markBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.markBottomLineView = markBottomLineView;
                        [self.contentView addSubview:markBottomLineView];
                        break;
                    }
                    case 2:{
                        CustomerLabel *operatorLabel = [[CustomerLabel alloc] init];
                        operatorLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        operatorLabel.text = @"承办人";
                        self.operatorLabel = operatorLabel;
                        [self.contentView addSubview:operatorLabel];
                        
                        UITextField  *operatorTextField = [[UITextField alloc] init];
                        operatorTextField.clearButtonMode = UITextFieldViewModeAlways;
                        operatorTextField.borderStyle = UITextBorderStyleRoundedRect;
                        operatorTextField.returnKeyType = UIReturnKeyDone;
                        operatorTextField.tag = 5;
                        operatorTextField.delegate = self;
                        operatorTextField.textAlignment = NSTextAlignmentRight;
                        operatorTextField.font = [UIFont systemFontOfSize:14];
                        self.operatorTextField = operatorTextField;
                        [operatorTextField addTarget:self action:@selector(operatorTextFieldChanged:)
                               forControlEvents:UIControlEventEditingChanged];
                        [self.contentView addSubview:operatorTextField];
                        
                        UIButton  *operatorSearchBtn = [[UIButton alloc] init];
                        [operatorSearchBtn setImage:[UIImage imageNamed:@"searchXb"]
                                      forState:UIControlStateNormal];
                        [operatorSearchBtn addTarget:self action:@selector(operatorSearchBtnClick)
                               forControlEvents:UIControlEventTouchUpInside];
                        self.operatorSearchBtn = operatorSearchBtn;
                        [self.contentView addSubview:operatorSearchBtn];
                        
                        UIView  *operatorBottomLineView = [[UIView alloc] init];
                        operatorBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.operatorBottomLineView = operatorBottomLineView;
                        [self.contentView addSubview:operatorBottomLineView];
                        break;
                    }
                    case 3:{
                        UIView *bpcTypeTopLineView = [[UIView alloc] init];
                        bpcTypeTopLineView.backgroundColor = GQColor(204, 204, 204);
                        self.bpcTypeTopLineView = bpcTypeTopLineView;
                        [self.contentView addSubview:bpcTypeTopLineView];
                        
                        CustomerLabel *bpcTypeLabel = [[CustomerLabel alloc] init];
                        bpcTypeLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        bpcTypeLabel.text = @"客户建档";
                        self.bpcTypeLabel = bpcTypeLabel;
                        [self.contentView addSubview:bpcTypeLabel];
                        
                        CustomButton *bpcTypeBtn = [[CustomButton alloc] init];
                        [bpcTypeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [bpcTypeBtn addTarget:self action:@selector(bpcTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.bpcTypeBtn = bpcTypeBtn;
                        [self.contentView addSubview:bpcTypeBtn];
                        
                        UIView *bpcTypeBottomLineView = [[UIView alloc] init];
                        bpcTypeBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.bpcTypeBottomLineView = bpcTypeBottomLineView;
                        [self.contentView addSubview:bpcTypeBottomLineView];
                        break;
                    }
                    case 4:{
                        CustomerLabel  *bpcLabel = [[CustomerLabel alloc] init];
                        bpcLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        bpcLabel.text = @"客户";
                        self.bpcLabel = bpcLabel;
                        [self.contentView addSubview:bpcLabel];
                        
                        UITextField  *bpcTextField = [[UITextField alloc] init];
                        bpcTextField.clearButtonMode = UITextFieldViewModeAlways;
                        bpcTextField.borderStyle = UITextBorderStyleRoundedRect;
                        bpcTextField.returnKeyType = UIReturnKeyDone;
                        bpcTextField.tag = 2;
                        bpcTextField.delegate = self;
                        bpcTextField.textAlignment = NSTextAlignmentRight;
                        bpcTextField.font = [UIFont systemFontOfSize:14];
                        self.bpcTextField = bpcTextField;
                        [bpcTextField addTarget:self action:@selector(bpcTextFieldChanged:)
                                   forControlEvents:UIControlEventEditingChanged];
                        [self.contentView addSubview:bpcTextField];
                        
                        UIButton  *bpcSearchBtn = [[UIButton alloc] init];
                        [bpcSearchBtn setImage:[UIImage imageNamed:@"searchBp"]
                                      forState:UIControlStateNormal];
                        [bpcSearchBtn addTarget:self action:@selector(bpcSearchBtnClick)
                                   forControlEvents:UIControlEventTouchUpInside];
                        self.bpcSearchBtn = bpcSearchBtn;
                        [self.contentView addSubview:bpcSearchBtn];
                        
                        UIView  *bpcBottomLineView = [[UIView alloc] init];
                        bpcBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.bpcBottomLineView = bpcBottomLineView;
                        [self.contentView addSubview:bpcBottomLineView];
                        break;
                    }
                    case 5:{
                        CustomerLabel  *telLabel = [[CustomerLabel alloc] init];
                        telLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        telLabel.text = @"联系人电话";
                        self.telLabel = telLabel;
                        [self.contentView addSubview:telLabel];
                        
                        UITextField  *telTextField = [[UITextField alloc] init];
                        telTextField.clearButtonMode = UITextFieldViewModeAlways;
                        telTextField.borderStyle = UITextBorderStyleRoundedRect;
                        telTextField.returnKeyType = UIReturnKeyDone;
                        telTextField.tag = 3;
                        telTextField.delegate = self;
                        telTextField.textAlignment = NSTextAlignmentRight;
                        telTextField.font = [UIFont systemFontOfSize:14];
                        self.telTextField = telTextField;
                        [self.contentView addSubview:telTextField];
                        
                        UIButton  *telSearchBtn = [[UIButton alloc] init];
                        [telSearchBtn setImage:[UIImage imageNamed:@"searchTel"] forState:UIControlStateNormal];
                        [telSearchBtn addTarget:self action:@selector(telSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.telSearchBtn = telSearchBtn;
                        [self.contentView addSubview:telSearchBtn];
                        
                        UIView  *telBottomLineView = [[UIView alloc] init];
                        telBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.telBottomLineView = telBottomLineView;
                        [self.contentView addSubview:telBottomLineView];
                        break;
                    }
                    case 6:{
                        CustomerLabel  *contactLabel = [[CustomerLabel alloc] init];
                        contactLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        contactLabel.text = @"客户联系人";
                        self.contactLabel = contactLabel;
                        [self.contentView addSubview:contactLabel];
                        
                        UITextField  *contactTextField = [[UITextField alloc] init];
                        contactTextField.clearButtonMode = UITextFieldViewModeAlways;
                        contactTextField.borderStyle = UITextBorderStyleRoundedRect;
                        contactTextField.returnKeyType = UIReturnKeyDone;
                        contactTextField.tag = 4;
                        contactTextField.delegate = self;
                        contactTextField.textAlignment = NSTextAlignmentRight;
                        contactTextField.font = [UIFont systemFontOfSize:14];
                        self.contactTextField = contactTextField;
                        [self.contentView addSubview:contactTextField];
                        
                        UIView  *contactBottomLineView = [[UIView alloc] init];
                        contactBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.contactBottomLineView = contactBottomLineView;
                        [self.contentView addSubview:contactBottomLineView];
                        break;
                    }
                    case 7:{
                        CustomerLabel *workTypeLabel = [[CustomerLabel alloc] init];
                        workTypeLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        workTypeLabel.text = @"客户工作类别";
                        self.workTypeLabel = workTypeLabel;
                        [self.contentView addSubview:workTypeLabel];
                        
                        CustomButton *workTypeBtn = [[CustomButton alloc] init];
                        [workTypeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [workTypeBtn addTarget:self action:@selector(workTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.workTypeBtn = workTypeBtn;
                        [self.contentView addSubview:workTypeBtn];
                        
                        UIView *workTypeBottomLineView = [[UIView alloc] init];
                        workTypeBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.workTypeBottomLineView = workTypeBottomLineView;
                        [self.contentView addSubview:workTypeBottomLineView];
                        break;
                    }
                    case 8:{
                        CustomerLabel *workLabel = [[CustomerLabel alloc] init];
                        workLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        workLabel.text = @"客户具体工作项";
                        self.workLabel = workLabel;
                        [self.contentView addSubview:workLabel];
                        
                        CustomButton *workBtn = [[CustomButton alloc] init];
                        [workBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [workBtn addTarget:self action:@selector(workBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.workBtn = workBtn;
                        [self.contentView addSubview:workBtn];
                        
                        UIView *workBottomLineView = [[UIView alloc] init];
                        workBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.workBottomLineView = workBottomLineView;
                        [self.contentView addSubview:workBottomLineView];
                        break;
                    }
                    case 9:{
                        CustomerLabel *projectLabel = [[CustomerLabel alloc] init];
                        projectLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        projectLabel.text = @"工程项目";
                        self.projectLabel = projectLabel;
                        [self.contentView addSubview:projectLabel];
                        
                        CustomButton *projectBtn = [[CustomButton alloc] init];
                        [projectBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                        [projectBtn addTarget:self action:@selector(projectBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        self.projectBtn = projectBtn;
                        [self.contentView addSubview:projectBtn];
                        
                        UIView *projectBottomLineView = [[UIView alloc] init];
                        projectBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.projectBottomLineView = projectBottomLineView;
                        [self.contentView addSubview:projectBottomLineView];
                        break;
                    }
                    case 10:{
                        CustomerLabel  *bzLabel = [[CustomerLabel alloc] init];
                        bzLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        bzLabel.text = @"备注";
                        self.bzLabel = bzLabel;
                        [self.contentView addSubview:bzLabel];
                        
                        UITextField *bzTextField = [[UITextField alloc] init];
                        bzTextField.clearButtonMode = UITextFieldViewModeAlways;
                        bzTextField.borderStyle = UITextBorderStyleRoundedRect;
                        bzTextField.returnKeyType = UIReturnKeyDone;
                        bzTextField.tag = 6;
                        bzTextField.delegate = self;
                        bzTextField.textAlignment = NSTextAlignmentRight;
                        bzTextField.font = [UIFont systemFontOfSize:14];
                        self.bzTextField = bzTextField;
                        [self.contentView addSubview:bzTextField];
                        
                        UIView  *bzBottomLineView = [[UIView alloc] init];
                        bzBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.bzBottomLineView = bzBottomLineView;
                        [self.contentView addSubview:bzBottomLineView];
                        
                        break;
                    }
                    case 11:{
                        CustomerLabel  *trackLabel = [[CustomerLabel alloc] init];
                        trackLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                        trackLabel.text = @"足迹";
                        self.trackLabel = trackLabel;
                        [self.contentView addSubview:trackLabel];
                        
                        UILabel  *trackTextLabel = [[UILabel alloc] init];
                        trackTextLabel.font = [UIFont systemFontOfSize:14];
                        trackTextLabel.layer.cornerRadius = 5;
                        trackTextLabel.layer.borderWidth = 1;
                        trackTextLabel.layer.borderColor = GQColor(229, 229, 229).CGColor;
                        trackTextLabel.numberOfLines = 0;
                        self.trackTextLabel = trackTextLabel;
                        [self.contentView addSubview:trackTextLabel];
                        
                        UIButton  *trackBtn = [[UIButton alloc] init];
                        [trackBtn setImage:[UIImage imageNamed:@"trackBtn"]
                                      forState:UIControlStateNormal];
                        [trackBtn addTarget:self action:@selector(trackBtnClick)
                               forControlEvents:UIControlEventTouchUpInside];
                        self.trackBtn = trackBtn;
                        [self.contentView addSubview:trackBtn];
                        
                        UIView  *trackBottomLineView = [[UIView alloc] init];
                        trackBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.trackBottomLineView = trackBottomLineView;
                        [self.contentView addSubview:trackBottomLineView];
                        break;
                    }
                    case 12:{
                        UITextView *contentTextView = [[UITextView alloc] init];
                        contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                        contentTextView.font = [UIFont systemFontOfSize:14.0f];
                        contentTextView.layer.borderWidth  = 1.0f;
                        contentTextView.layer.cornerRadius = 5.0;
                        contentTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
                        contentTextView.delegate = self;
                        contentTextView.returnKeyType = UIReturnKeyDone;
                        contentTextView.placeholder = @"内容";
                        self.contentTextView = contentTextView;
                        [self.contentView addSubview:contentTextView];
                        
                        UIView  *contentBottomLineView = [[UIView alloc] init];
                        contentBottomLineView.backgroundColor = GQColor(204, 204, 204);
                        self.contentBottomLineView = contentBottomLineView;
                        [self.contentView addSubview:contentBottomLineView];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)setSelectData:(NSArray *)selectData {
    _selectData = selectData;
    
    NSMutableArray *array = [NSMutableArray array];
    for (WKWorkTypeResult* wk in selectData) {
        if (wk.disabled == 0) {
            [array addObject:wk];
        }
    }
    _workTypeResultArray = array;
}

/** 传递模型,并赋值 */
- (void)setPlan:(RjhPlan *)plan {
    _plan = plan;
    
    switch (_indexPath.section) {
        case 0:{
            /** 标题 */
            if (![_plan.title isEqual:[NSNull null]]) {
                [self.titleField setText:_plan.title];
            }
            break;
        }
        case 1:{
            switch (_indexPath.row) {
                case 0: {
                    /** 全天 */
                    [self.switchView setOn:_plan.allday];
                    break;
                }
                case 1: {
                    /** 日期 */
                    [self.dateBtn setVal:_plan.logdate andDis:_plan.logdate];
                    break;
                }
                case 2: {
                    /** 时间 */
                    self.timeBtn.enabled = !_plan.allday;
                    [self.timeBtn setVal:_plan.logtime andDis:_plan.logtime];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (_indexPath.row) {
                case 0:{
                    /** 工作项 */
                    for (WKWorkTypeResult* wk in self.selectData) {
                        if (_plan.type == 0) {
                            if (wk.disabled == 0) {
                                _plan.type = wk.type;
                                [_planTypeBtn setTitle:wk.typeName forState:UIControlStateNormal];
                                _workTypeArray = wk.level2;
                                if ([self.delegate respondsToSelector:@selector(didFinishPlanType:)]) {
                                    [self.delegate didFinishPlanType:self];
                                }
                                break;
                            }
                        }else if(wk.type == _plan.type){
                            [_planTypeBtn setVal:[NSString stringWithFormat:@"%d",wk.type] andDis:wk.typeName];
                            _workTypeArray = wk.level2;
                            if ([self.delegate respondsToSelector:@selector(didFinishPlanType:)]) {
                                [self.delegate didFinishPlanType:self];
                            }
                            break;
                        }
                    }
                    break;
                }
                case 1:{
                    // 标签
                    switch (_plan.type) {
                        case 1: case 4:
                            self.visitBpcBtn.selected = YES;
                            self.importantWorkBtn.selected = NO;
                            self.noteBtn.selected = NO;
                            self.greenBtn.selected = NO;
                            break;
                        case 2: case 5:
                            self.visitBpcBtn.selected = NO;
                            self.importantWorkBtn.selected = YES;
                            self.noteBtn.selected = NO;
                            self.greenBtn.selected = NO;
                            break;
                        case 3: case 6:
                            self.visitBpcBtn.selected = NO;
                            self.importantWorkBtn.selected = NO;
                            self.noteBtn.selected = YES;
                            self.greenBtn.selected = NO;
                            break;
                        case 7:
                            self.visitBpcBtn.selected = NO;
                            self.importantWorkBtn.selected = NO;
                            self.noteBtn.selected = NO;
                            self.greenBtn.selected = YES;
                            break;
                        default:
                            break;
                    }
                    break;
                }
                case 2:{
                    // 承办人
                    if (![_plan.operatorname isEqual:[NSNull null]]) {
                        self.operatorTextField.text = _plan.operatorname;
                    }
                    break;
                }
                case 3:{
                    // 客户建档
                    [self.bpcTypeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([obj isEqual:@(_plan.kh_lb)]) {
                            [_bpcTypeBtn setVal:key andDis:key];
                        }
                    }];
                    break;
                }
                case 4:{
                    // 客户
                    if (![_plan.khmc isEqual:[NSNull null]]) {
                        self.bpcTextField.text = _plan.khmc;
                    }
                    break;
                }
                case 5:{
                    // 客户联系电话
                    if (![_plan.kh_lxdh isEqual:[NSNull null]]) {
                        self.telTextField.text = _plan.kh_lxdh;
                    }
                    break;
                }
                case 6:{
                    // 客户联系人
                    if (![_plan.kh_lxr isEqual:[NSNull null]]) {
                        self.contactTextField.text = _plan.kh_lxr;
                    }
                    break;
                }
                case 7:{
                    // 客户工作类别
                    for (WKWorkType* tp in self.workTypeArray) {
                        if (_plan.leveltype == 0) {
                            [_workTypeBtn setTitle:tp.levelName forState:UIControlStateNormal];
                            _plan.leveltype = tp.levelType;
                            _workArray = tp.jobs;
                            if ([self.delegate respondsToSelector:@selector(didFinishWorkType:)]) {
                                [self.delegate didFinishWorkType:self];
                            }
                            break;
                        }else if (_plan.leveltype == tp.levelType){
                            [_workTypeBtn setTitle:tp.levelName forState:UIControlStateNormal];
                             _workArray = tp.jobs;
                            if ([self.delegate respondsToSelector:@selector(didFinishWorkType:)]) {
                                [self.delegate didFinishWorkType:self];
                            }
                            break;
                        }
                    }
                    break;
                }
                case 8:{ // 客户具体工作项
                    switch (_plan.type) {
                        case 4: case 6:{
                            for (WKWork* wk in self.workArray) {
                                if ([_plan.jobtype isEqualToString:[NSString stringWithFormat:@"%d",wk.jobType]]) {
                                    [_workBtn setTitle:wk.jobName forState:UIControlStateNormal];
                                    _plan.jobremark_placeholder = wk.jobRemark;
                                    break;
                                }
                            }
                            break;
                        }
                        case 5: case 7:{
                            //客户具体工作项
                            NSArray *jobArray = [_plan.jobtype componentsSeparatedByString:@","];
                            NSMutableString *sb = [[NSMutableString alloc] init];
                            for (NSString *job in jobArray) {
                                for (WKWork* wk in self.workArray) {
                                    if ([job isEqualToString:[NSString stringWithFormat:@"%d",wk.jobType]]){
                                        [sb appendString:wk.jobName];
                                        [sb appendString:@","];
                                        break;
                                    }
                                }
                            }
                            if ([sb length] > 0) {
                                NSRange deleteRange = {[sb length] - 1, 1};
                                [sb deleteCharactersInRange:deleteRange];
                                [_workBtn setTitle:sb forState:UIControlStateNormal];
                            }
                            _plan.jobremark_placeholder = @"";
                            break;
                        }
                        default:
                            break;
                    }
                }
                case 9:{
                    // 工程项目
                    for (WKProjectResult* pr in self.projectList) {
                        if ([_plan.projectid isEqualToString:pr.projectid]) {
                            [_projectBtn setTitle:pr.projectname forState:UIControlStateNormal];
                            break;
                        }
                    }
                    break;
                }
                case 10:{
                    if (![_plan.jobremark isEqual:[NSNull null]]) {
                        self.bzTextField.text = _plan.jobremark;
                    }
                    // 备注
                    break;
                }
                case 11:{
                    // 足迹
                    if (![_plan.signin isEqual:[NSNull null]]) {
                        self.trackTextLabel.text = _plan.signin;
                    }
                    break;
                }
                case 12:{
                    // 正文
                    if (![_plan.content isEqual:[NSNull null]]) {
                        self.contentTextView.text = _plan.content;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/** 懒加载创建全天开关 */
- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (void)switchStateChange:(UISwitch *)uiswitch {
    _plan.allday = uiswitch.isOn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    switch (_indexPath.section) {
        case 0:{
            CGFloat titleTopLineViewX = 0;
            CGFloat titleTopLineViewY = 0;
            CGFloat titleTopLineViewW = parentW;
            CGFloat titleTopLineViewH = lineHeight;
            self.titleTopLineView.frame = CGRectMake(titleTopLineViewX, titleTopLineViewY, titleTopLineViewW, titleTopLineViewH);
            
            CGFloat titleFieldX = 0;
            CGFloat titleFieldY = CGRectGetMaxY(_titleTopLineView.frame);
            CGFloat titleFieldW = parentW;
            CGFloat titleFieldH = parentH - 2 * titleTopLineViewH;
            self.titleField.frame = CGRectMake(titleFieldX, titleFieldY, titleFieldW, titleFieldH);
            
            CGFloat titleBottomLineViewX = 0;
            CGFloat titleBottomLineViewY = CGRectGetMaxY(_titleField.frame);
            CGFloat titleBottomLineViewW = parentW;
            CGFloat titleBottomLineViewH = titleTopLineViewH;
            self.titleBottomLineView.frame = CGRectMake(titleBottomLineViewX, titleBottomLineViewY, titleBottomLineViewW, titleBottomLineViewH);
            break;
        }
        case 1:{
            switch (_indexPath.row) {
                case 0:{
                    CGFloat allDayTopLineViewX = 0;
                    CGFloat allDayTopLineViewY = 0;
                    CGFloat allDayTopLineViewW = parentW;
                    CGFloat allDayTopLineViewH = lineHeight;
                    self.allDayTopLineView.frame = CGRectMake(allDayTopLineViewX, allDayTopLineViewY, allDayTopLineViewW, allDayTopLineViewH);
                    
                    CGFloat allDayLabelX = 0;
                    CGFloat allDayLabelY = CGRectGetMaxY(_allDayTopLineView.frame);
                    CGFloat allDayLabelW = 120.0f;
                    CGFloat allDayLabelH = parentH - 2 * allDayTopLineViewH;
                    self.allDayLabel.frame = CGRectMake(allDayLabelX, allDayLabelY, allDayLabelW, allDayLabelH);
                    
                    CGFloat allDayBottomLineViewX = paddingX;
                    CGFloat allDayBottomLineViewY = CGRectGetMaxY(_allDayLabel.frame);
                    CGFloat allDayBottomLineViewW = parentW - 2 * paddingX;
                    CGFloat allDayBottomLineViewH = allDayTopLineViewH;
                    self.allDayBottomLineView.frame = CGRectMake(allDayBottomLineViewX, allDayBottomLineViewY, allDayBottomLineViewW, allDayBottomLineViewH);
                    break;
                }
                case 1:{
                    CGFloat dateLabelX = 0;
                    CGFloat dateLabelY = 0;
                    CGFloat dateLabelW = parentW * 0.4;
                    CGFloat dateLabelH = parentH - 1;
                    self.dateLabel.frame = CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
                    
                    CGFloat dateBtnX = CGRectGetMaxX(_dateLabel.frame);
                    CGFloat dateBtnY = paddingY;
                    CGFloat dateBtnW = parentW * 0.6 - paddingX;
                    CGFloat dateBtnH = parentH - 2 * dateBtnY;
                    self.dateBtn.frame = CGRectMake(dateBtnX, dateBtnY, dateBtnW, dateBtnH);
                    
                    CGFloat dateBottomLineViewX= paddingY;
                    CGFloat dateBottomLineViewY = parentH - 1;
                    CGFloat dateBottomLineViewW = parentW - 2 * dateBottomLineViewX;
                    CGFloat dateBottomLineViewH = lineHeight;
                    self.dateBottomLineView.frame = CGRectMake(dateBottomLineViewX, dateBottomLineViewY, dateBottomLineViewW, dateBottomLineViewH);
                    break;
                }
                case 2:{
                    CGFloat timeLabelX = 0;
                    CGFloat timeLabelY = 0;
                    CGFloat timeLabelW = parentW * 0.4;
                    CGFloat timeLabelH = parentH - 1;
                    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
                    
                    CGFloat timeBtnX = CGRectGetMaxX(_timeLabel.frame);
                    CGFloat timeBtnY = 5;
                    CGFloat timeBtnW = parentW * 0.6 - paddingX;
                    CGFloat timeBtnH = parentH - 2 * timeBtnY;
                    self.timeBtn.frame = CGRectMake(timeBtnX, timeBtnY, timeBtnW, timeBtnH);
                    
                    CGFloat timeBottomLineViewX= 0;
                    CGFloat timeBottomLineViewY = parentH - 1;
                    CGFloat timeBottomLineViewW = parentW;
                    CGFloat timeBottomLineViewH = 1;
                    self.timeBottomLineView.frame = CGRectMake(timeBottomLineViewX, timeBottomLineViewY, timeBottomLineViewW, timeBottomLineViewH);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (_indexPath.row) {
                case 0:{
                    CGFloat planTypeTopLineViewX = 0;
                    CGFloat planTypeTopLineViewY = 0;
                    CGFloat planTypeTopLineViewW = parentW;
                    CGFloat planTypeTopLineViewH = 1;
                    self.planTypeTopLineView.frame = CGRectMake(planTypeTopLineViewX, planTypeTopLineViewY, planTypeTopLineViewW, planTypeTopLineViewH);
                    
                    CGFloat planTypeLabelX = 0;
                    CGFloat planTypeLabelY = CGRectGetMaxY(_planTypeTopLineView.frame);
                    CGFloat planTypeLabelW = parentW * 0.4;
                    CGFloat planTypeLabelH = parentH;
                    self.planTypeLabel.frame = CGRectMake(planTypeLabelX, planTypeLabelY, planTypeLabelW, planTypeLabelH);
                    
                    CGFloat planTypeBtnX = CGRectGetMaxX(_planTypeLabel.frame);
                    CGFloat planTypeBtnY = 5;
                    CGFloat planTypeBtnW = parentW * 0.6 - paddingX;
                    CGFloat planTypeBtnH = parentH - 2 * planTypeBtnY;
                    self.planTypeBtn.frame = CGRectMake(planTypeBtnX, planTypeBtnY, planTypeBtnW, planTypeBtnH);
                    
                    CGFloat planTypeBottomLineViewX = paddingY;
                    CGFloat planTypeBottomLineViewY = parentH - 1;
                    CGFloat planTypeBottomLineViewW = parentW - 2 * planTypeBottomLineViewX;
                    CGFloat planTypeBottomLineViewH = 1;
                    self.planTypeBottomLineView.frame = CGRectMake(planTypeBottomLineViewX, planTypeBottomLineViewY, planTypeBottomLineViewW, planTypeBottomLineViewH);
                    break;
                }
                case 1:{
                    CGFloat markLabelX = 0;
                    CGFloat markLabelY = 0;
                    CGFloat markLabelW = 60.0f;
                    CGFloat markLabelH = parentH;
                    self.markLabel.frame = CGRectMake(markLabelX, markLabelY, markLabelW, markLabelH);
                    
                    CGFloat greenBtnY = paddingY;
                    CGFloat greenBtnH = parentH - 2 * paddingY;
                    CGFloat greenBtnW = greenBtnH;
                    CGFloat greenBtnX = parentW - (paddingX + greenBtnW);
                    self.greenBtn.frame = CGRectMake(greenBtnX, greenBtnY, greenBtnW, greenBtnH);
                    
                    CGFloat noteBtnY = paddingY;
                    CGFloat noteBtnH = greenBtnH;
                    CGFloat noteBtnW = greenBtnH;
                    CGFloat noteBtnX = greenBtnX - (paddingX + noteBtnW);
                    self.noteBtn.frame = CGRectMake(noteBtnX, noteBtnY, noteBtnW, noteBtnH);
                    
                    CGFloat importantWorkBtnY = paddingY;
                    CGFloat importantWorkBtnH = greenBtnH;
                    CGFloat importantWorkBtnW = greenBtnH;
                    CGFloat importantWorkBtnX = noteBtnX - (paddingY + importantWorkBtnW);
                    self.importantWorkBtn.frame = CGRectMake(importantWorkBtnX, importantWorkBtnY, importantWorkBtnW, importantWorkBtnH);
                    
                    CGFloat visitBpcBtnY = paddingY;
                    CGFloat visitBpcBtnH = greenBtnH;
                    CGFloat visitBpcBtnW = greenBtnH;
                    CGFloat visitBpcBtnX = importantWorkBtnX - (paddingY + visitBpcBtnW);
                    self.visitBpcBtn.frame = CGRectMake(visitBpcBtnX, visitBpcBtnY, visitBpcBtnW, visitBpcBtnH);

                    CGFloat markBottomLineViewX = paddingY;
                    CGFloat markBottomLineViewY = parentH - 1;
                    CGFloat markBottomLineViewW = parentW - 2 * markBottomLineViewX;
                    CGFloat markBottomLineViewH = 1;
                    self.markBottomLineView.frame = CGRectMake(markBottomLineViewX, markBottomLineViewY, markBottomLineViewW, markBottomLineViewH);
                    break;
                }
                case 2:{
                    if (_zjxs.count > 0) {
                        CGFloat operatorLabelX = 0;
                        CGFloat operatorLabelY = 0;
                        CGFloat operatorLabelW = 80.0f;
                        CGFloat operatorLabelH = parentH;
                        self.operatorLabel.frame = CGRectMake(operatorLabelX, operatorLabelY, operatorLabelW, operatorLabelH);
                        
                        CGFloat operatorSearchBtnY = paddingY;
                        CGFloat operatorSearchBtnH = (parentH == 0 ? 0 : parentH - 2 * operatorSearchBtnY);
                        CGFloat operatorSearchBtnW = operatorSearchBtnH;
                        CGFloat operatorSearchBtnX = parentW - paddingX - operatorSearchBtnW;
                        self.operatorSearchBtn.frame = CGRectMake(operatorSearchBtnX, operatorSearchBtnY, operatorSearchBtnW, operatorSearchBtnH);
                        
                        CGFloat operatorTextFieldX = CGRectGetMaxX(_operatorLabel.frame);
                        CGFloat operatorTextFieldY = paddingY;
                        CGFloat operatorTextFieldW = operatorSearchBtnX - operatorTextFieldX;
                        CGFloat operatorTextFieldH = (parentH == 0 ? 0 : parentH - 2 * operatorSearchBtnY);
                        self.operatorTextField.frame = CGRectMake(operatorTextFieldX, operatorTextFieldY, operatorTextFieldW, operatorTextFieldH);
                        
                        CGFloat operatorBottomLineViewX = paddingY;
                        CGFloat operatorBottomLineViewY = (parentH == 0 ? 0 : parentH - 1);
                        CGFloat operatorBottomLineViewW = parentW - 2 * operatorBottomLineViewX;
                        CGFloat operatorBottomLineViewH = parentH == 0 ? 0 : 1;
                        self.operatorBottomLineView.frame = CGRectMake(operatorBottomLineViewX, operatorBottomLineViewY, operatorBottomLineViewW, operatorBottomLineViewH);
                    }
                    break;
                }
                case 3:{
                    CGFloat bpcTypeTopLineViewX = paddingY;
                    CGFloat bpcTypeTopLineViewY = 0;
                    CGFloat bpcTypeTopLineViewW = parentW - 2 * bpcTypeTopLineViewX;
                    CGFloat bpcTypeTopLineViewH = 1;
                    self.bpcTypeTopLineView.frame = CGRectMake(bpcTypeTopLineViewX, bpcTypeTopLineViewY, bpcTypeTopLineViewW, bpcTypeTopLineViewH);
                    
                    CGFloat bpcTypeLabelX = 0;
                    CGFloat bpcTypeLabelY = CGRectGetMaxY(_bpcTypeTopLineView.frame);
                    CGFloat bpcTypeLabelW = parentW * 0.4;
                    CGFloat bpcTypeLabelH = parentH;
                    self.bpcTypeLabel.frame = CGRectMake(bpcTypeLabelX, bpcTypeLabelY, bpcTypeLabelW, bpcTypeLabelH);
                    
                    CGFloat bpcTypeBtnX = CGRectGetMaxX(_bpcTypeLabel.frame);
                    CGFloat bpcTypeBtnY = 5;
                    CGFloat bpcTypeBtnW = parentW * 0.6 - paddingX;
                    CGFloat bpcTypeBtnH = parentH - 2 * bpcTypeBtnY;
                    self.bpcTypeBtn.frame = CGRectMake(bpcTypeBtnX, bpcTypeBtnY, bpcTypeBtnW, bpcTypeBtnH);
                    
                    CGFloat bpcTypeBottomLineViewX = 10;
                    CGFloat bpcTypeBottomLineViewY = parentH - 1;
                    CGFloat bpcTypeBottomLineViewW = parentW - 2 * bpcTypeBottomLineViewX;
                    CGFloat bpcTypeBottomLineViewH = 1;
                    self.bpcTypeBottomLineView.frame = CGRectMake(bpcTypeBottomLineViewX, bpcTypeBottomLineViewY, bpcTypeBottomLineViewW, bpcTypeBottomLineViewH);
                    break;
                }
                case 4:{
                    CGFloat bpcLabelX = 0;
                    CGFloat bpcLabelY = 0;
                    CGFloat bpcLabelW = 80.0f;
                    CGFloat bpcLabelH = parentH;
                    self.bpcLabel.frame = CGRectMake(bpcLabelX, bpcLabelY, bpcLabelW, bpcLabelH);
                    
                    CGFloat bpcSearchBtnY = paddingY;
                    CGFloat bpcSearchBtnH = parentH - 2 * bpcSearchBtnY;
                    CGFloat bpcSearchBtnW = bpcSearchBtnH;
                    CGFloat bpcSearchBtnX = parentW - paddingX - bpcSearchBtnW;
                    self.bpcSearchBtn.frame = CGRectMake(bpcSearchBtnX, bpcSearchBtnY, bpcSearchBtnW, bpcSearchBtnH);
                    
                    CGFloat bpcTextFieldX = CGRectGetMaxX(_bpcLabel.frame);
                    CGFloat bpcTextFieldY = paddingY;
                    CGFloat bpcTextFieldW = bpcSearchBtnX - bpcLabelW;
                    CGFloat bpcTextFieldH = parentH - 2 * bpcSearchBtnY;
                    self.bpcTextField.frame = CGRectMake(bpcTextFieldX, bpcTextFieldY, bpcTextFieldW, bpcTextFieldH);
                    
                    CGFloat bpcBottomLineViewX = paddingY;
                    CGFloat bpcBottomLineViewY = parentH - 1;
                    CGFloat bpcBottomLineViewW = parentW - 2 * bpcBottomLineViewX;
                    CGFloat bpcBottomLineViewH = 1;
                    self.bpcBottomLineView.frame = CGRectMake(bpcBottomLineViewX, bpcBottomLineViewY, bpcBottomLineViewW, bpcBottomLineViewH);
                    break;
                }
                case 5:{
                    CGFloat telLabelX = 0;
                    CGFloat telLabelY = 0;
                    CGFloat telLabelW = 120.0f;
                    CGFloat telLabelH = parentH;
                    self.telLabel.frame = CGRectMake(telLabelX, telLabelY, telLabelW, telLabelH);
                    
                    CGFloat telSearchBtnY = paddingY;
                    CGFloat telSearchBtnH = parentH - 2 * telSearchBtnY;
                    CGFloat telSearchBtnW = telSearchBtnH;
                    CGFloat telSearchBtnX = parentW - paddingX - telSearchBtnW;
                    self.telSearchBtn.frame = CGRectMake(telSearchBtnX, telSearchBtnY, telSearchBtnW, telSearchBtnH);
                    
                    CGFloat telTextFieldX = CGRectGetMaxX(_telLabel.frame);
                    CGFloat telTextFieldY = paddingY;
                    CGFloat telTextFieldW = telSearchBtnX - telLabelW;
                    CGFloat telTextFieldH = parentH - 2 * telTextFieldY;
                    self.telTextField.frame = CGRectMake(telTextFieldX, telTextFieldY, telTextFieldW, telTextFieldH);
                    
                    CGFloat telBottomLineViewX = paddingY;
                    CGFloat telBottomLineViewY = parentH - 1;
                    CGFloat telBottomLineViewW = parentW - 2 * telBottomLineViewX;
                    CGFloat telBottomLineViewH = lineHeight;
                    self.telBottomLineView.frame = CGRectMake(telBottomLineViewX, telBottomLineViewY, telBottomLineViewW, telBottomLineViewH);
                    break;
                }
                case 6:{
                    CGFloat contactLabelX = 0;
                    CGFloat contactLabelY = 0;
                    CGFloat contactLabelW = 120.0f;
                    CGFloat contactLabelH = parentH;
                    self.contactLabel.frame = CGRectMake(contactLabelX, contactLabelY, contactLabelW, contactLabelH);
                    
                    CGFloat contactTextFieldX = CGRectGetMaxX(_contactLabel.frame);
                    CGFloat contactTextFieldY = paddingY;
                    CGFloat contactTextFieldW = parentW - contactLabelW - paddingX;
                    CGFloat contactTextFieldH = parentH - 2 * contactTextFieldY;
                    self.contactTextField.frame = CGRectMake(contactTextFieldX, contactTextFieldY, contactTextFieldW, contactTextFieldH);
                    
                    CGFloat contactBottomLineViewX = paddingY;
                    CGFloat contactBottomLineViewY = parentH - 1;
                    CGFloat contactBottomLineViewW = parentW - 2 * contactBottomLineViewX;
                    CGFloat contactBottomLineViewH = lineHeight;
                    self.contactBottomLineView.frame = CGRectMake(contactBottomLineViewX, contactBottomLineViewY, contactBottomLineViewW, contactBottomLineViewH);
                    break;
                }
                case 7:{
                    CGFloat workTypeLabelX = 0;
                    CGFloat workTypeLabelY = 0;
                    CGFloat workTypeLabelW = parentW * 0.4;
                    CGFloat workTypeLabelH = parentH - 1;
                    self.workTypeLabel.frame = CGRectMake(workTypeLabelX, workTypeLabelY, workTypeLabelW, workTypeLabelH);
                    
                    CGFloat workTypeBtnX = CGRectGetMaxX(_workTypeLabel.frame);
                    CGFloat workTypeBtnY = paddingY;
                    CGFloat workTypeBtnW = parentW * 0.6 - paddingX;
                    CGFloat workTypeBtnH = parentH - 2 * workTypeBtnY;
                    self.workTypeBtn.frame = CGRectMake(workTypeBtnX, workTypeBtnY, workTypeBtnW, workTypeBtnH);
                    
                    CGFloat workTypeBottomLineViewX= paddingY;
                    CGFloat workTypeBottomLineViewY = parentH - 1;
                    CGFloat workTypeBottomLineViewW = parentW - 2 * workTypeBottomLineViewX;
                    CGFloat workTypeBottomLineViewH = lineHeight;
                    self.workTypeBottomLineView.frame = CGRectMake(workTypeBottomLineViewX, workTypeBottomLineViewY, workTypeBottomLineViewW, workTypeBottomLineViewH);
                    break;
                }
                case 8:{
                    CGFloat workLabelX = 0;
                    CGFloat workLabelY = 0;
                    CGFloat workLabelW = parentW * 0.4;
                    CGFloat workLabelH = parentH - 1;
                    self.workLabel.frame = CGRectMake(workLabelX, workLabelY, workLabelW, workLabelH);
                    
                    CGFloat workBtnX = CGRectGetMaxX(_workLabel.frame);
                    CGFloat workBtnY = paddingY;
                    CGFloat workBtnW = parentW * 0.6 - paddingX;
                    CGFloat workBtnH = parentH - 2 * workBtnY;
                    self.workBtn.frame = CGRectMake(workBtnX, workBtnY, workBtnW, workBtnH);
                    
                    CGFloat workBottomLineViewX= paddingY;
                    CGFloat workBottomLineViewY = parentH - 1;
                    CGFloat workBottomLineViewW = parentW - 2 * workBottomLineViewX;
                    CGFloat workBottomLineViewH = lineHeight;
                    self.workBottomLineView.frame = CGRectMake(workBottomLineViewX, workBottomLineViewY, workBottomLineViewW, workBottomLineViewH);
                    break;
                }
                case 9:{
                    if (_plan.leveltype == 4) {
                        CGFloat projectLabelX = 0;
                        CGFloat projectLabelY = 0;
                        CGFloat projectLabelW = parentW * 0.4;
                        CGFloat projectLabelH = parentH - 1;
                        self.projectLabel.frame = CGRectMake(projectLabelX, projectLabelY, projectLabelW, projectLabelH);
                        
                        CGFloat projectBtnX = CGRectGetMaxX(_projectLabel.frame);
                        CGFloat projectBtnY = paddingY;
                        CGFloat projectBtnW = parentW * 0.6 - paddingX;
                        CGFloat projectBtnH = parentH - 2 * projectBtnY;
                        self.projectBtn.frame = CGRectMake(projectBtnX, projectBtnY, projectBtnW, projectBtnH);
                        
                        CGFloat projectBottomLineViewX= paddingY;
                        CGFloat projectBottomLineViewY = parentH - 1;
                        CGFloat projectBottomLineViewW = parentW - 2 * projectBottomLineViewX;
                        CGFloat projectBottomLineViewH = lineHeight;
                        self.projectBottomLineView.frame = CGRectMake(projectBottomLineViewX, projectBottomLineViewY, projectBottomLineViewW, projectBottomLineViewH);
                    }
                    break;
                }
                case 10:{
                    if ([_plan.jobremark_placeholder length] > 0) {
                        CGFloat bzLabelX = 0;
                        CGFloat bzLabelY = 0;
                        CGFloat bzLabelW = 120.0f;
                        CGFloat bzLabelH = parentH;
                        self.bzLabel.frame = CGRectMake(bzLabelX, bzLabelY, bzLabelW, bzLabelH);
                        
                        CGFloat bzTextFieldX = CGRectGetMaxX(_bzLabel.frame);
                        CGFloat bzTextFieldY = paddingY;
                        CGFloat bzTextFieldW = parentW - bzLabelW - paddingX;
                        CGFloat bzTextFieldH = parentH - 2 * bzTextFieldY;
                        self.bzTextField.frame = CGRectMake(bzTextFieldX, bzTextFieldY, bzTextFieldW, bzTextFieldH);
                        NSString *holderText = _plan.jobremark_placeholder;
                        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
                        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, holderText.length)];
                        self.bzTextField.attributedPlaceholder = placeholder;
                        
                        CGFloat bzBottomLineViewX = paddingY;
                        CGFloat bzBottomLineViewY = parentH - 1;
                        CGFloat bzBottomLineViewW = parentW - 2 * bzBottomLineViewX;
                        CGFloat bzBottomLineViewH = lineHeight;
                        self.bzBottomLineView.frame = CGRectMake(bzBottomLineViewX, bzBottomLineViewY, bzBottomLineViewW, bzBottomLineViewH);
                    }
                    break;
                }
                case 11:{
                    CGFloat trackLabelX = 0;
                    CGFloat trackLabelY = 0;
                    CGFloat trackLabelW = 80.0f;
                    CGFloat trackLabelH = parentH;
                    self.trackLabel.frame = CGRectMake(trackLabelX, trackLabelY, trackLabelW, trackLabelH);
                    
                    CGFloat trackBtnY = paddingY;
                    CGFloat trackBtnH = parentH - 2 * trackBtnY;
                    CGFloat trackBtnW = trackBtnH;
                    CGFloat trackBtnX = parentW - paddingX - trackBtnW;
                    self.trackBtn.frame = CGRectMake(trackBtnX, trackBtnY, trackBtnW, trackBtnH);
                    
                    CGFloat trackTextLabelX = CGRectGetMaxX(_trackLabel.frame);
                    CGFloat trackTextLabelY = paddingY;
                    CGFloat trackTextLabelW = trackBtnX - trackLabelW;
                    CGFloat trackTextLabelH = parentH - 2 * trackTextLabelY;
                    self.trackTextLabel.frame = CGRectMake(trackTextLabelX, trackTextLabelY, trackTextLabelW, trackTextLabelH);
                    
                    CGFloat trackBottomLineViewX = paddingY;
                    CGFloat trackBottomLineViewY = parentH - 1;
                    CGFloat trackBottomLineViewW = parentW - 2 * trackBottomLineViewX;
                    CGFloat trackBottomLineViewH = 1;
                    self.trackBottomLineView.frame = CGRectMake(trackBottomLineViewX, trackBottomLineViewY, trackBottomLineViewW, trackBottomLineViewH);
                    break;
                }
                case 12:{
                    CGFloat contentTextViewX = paddingX;
                    CGFloat contentTextViewY = paddingX;
                    CGFloat contentTextViewW = parentW - 2 * contentTextViewX;
                    CGFloat contentTextViewH = parentH - 2 * contentTextViewY;
                    self.contentTextView.frame = CGRectMake(contentTextViewX, contentTextViewY, contentTextViewW, contentTextViewH);
                    
                    CGFloat contentBottomLineViewX = 0;
                    CGFloat contentBottomLineViewY = parentH - 1;
                    CGFloat contentBottomLineViewW = parentW;
                    CGFloat contentBottomLineViewH = lineHeight;
                    self.contentBottomLineView.frame = CGRectMake(contentBottomLineViewX, contentBottomLineViewY, contentBottomLineViewW, contentBottomLineViewH);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
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


#pragma mark - 日期按钮点击
/** 日期按钮点击 */
- (void)dateBtnClick {
    if (_datePickerView == nil) {
        _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _datePickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_datePickerView];
    }
    [self.superview.superview addSubview:_cover];
}

/** 日期按钮 代理方法 */
- (void)didFinishDatePicker:(DatePickerView *)datePickerView buttonType:(DatePickerViewButtonType)buttonType {
    switch (buttonType) {
        case DatePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case DatePickerViewButtonTypeSure:{
            _plan.logdate = datePickerView.selectedDate;
            [self.dateBtn setVal:datePickerView.selectedDate andDis:datePickerView.selectedDate];
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 时间按钮点击
/** 时间按钮点击 */
- (void)timeBtnClick {
    if (_timePickerView == nil) {
        _timePickerView = [[TimePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _timePickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_timePickerView];
    }
    [self.superview.superview addSubview:_cover];
}

/** 时间按钮 代理方法 */
- (void)didFinishTimePicker:(NSString *)timeStr buttonType:(TimePickerViewButtonType)buttonType {
    switch (buttonType) {
        case TimePickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case TimePickerViewButtonTypeSure:
            _plan.logtime = timeStr;
            [self.timeBtn setVal:timeStr andDis:timeStr];
            [self tapCover];
            break;
        default:
            break;
    }
}

#pragma mark - 工作项
/** 类型按钮点击 */
- (void)planTypeBtnClick {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _selectPickerView.tag = 1;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WKWorkTypeResult* wk in self.workTypeResultArray) {
            [tempArray addObject:wk.typeName];
        }
        
        _selectPickerView.dataArry = tempArray;
        _selectPickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:_cover];
}

/** 类型数据来源 */
- (NSMutableArray *)planTypeSource {
    if (_planTypeSource == nil) {
        _planTypeSource = [NSMutableArray arrayWithObjects:@"拜访客户",@"重要工作",@"随笔" ,nil];
    }
    return _planTypeSource;
}

/** 字典懒加载 */
- (NSMutableDictionary *)planTypeDict {
    if (_planTypeDict == nil) {
        _planTypeDict = [NSMutableDictionary dictionaryWithObjects:@[@(PlanTypeVisitBpc),@(PlanTypeImportantWork),@(PlanTypeNote)] forKeys:@[@"拜访客户",@"重要工作",@"随笔"]];
    }
    return _planTypeDict;
}

#pragma mark - 客户建档按钮点击
- (void)bpcTypeBtnClick {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0)];
        _selectPickerView.tag = 2;
        _selectPickerView.dataArry = self.bpcTypeSource;
        _selectPickerView.delegate = self;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

/** 客户类型数据来源 */
- (NSMutableArray *)bpcTypeSource {
    if (_bpcTypeSource == nil) {
        _bpcTypeSource = [NSMutableArray arrayWithObjects:@"未建客户代码",@"已建客户代码", nil];
    }
    return _bpcTypeSource;
}

- (NSArray *)bpcTypeArray {
    if (!_bpcTypeArray) {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"未建客户代码",@"1"] forKeys:@[@"typeName",@"type"]];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"已建客户代码",@"2"] forKeys:@[@"typeName",@"type"]];
        _bpcTypeArray = [NSArray arrayWithObjects:dict1, dict2,nil];
    }
    return _bpcTypeArray;
}

/** 字典懒加载 */
- (NSMutableDictionary *)bpcTypeDict {
    if (_bpcTypeDict == nil) {
        _bpcTypeDict = [NSMutableDictionary dictionaryWithObjects:@[@(BpcTypePotential),@(BpcTypeSigning)] forKeys:@[@"未建客户代码",@"已建客户代码"]];
    }
    return _bpcTypeDict;
}

#pragma mark - 客户工作类别
- (void)workTypeBtnClick {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _selectPickerView.tag = 3;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WKWorkType* wk in self.workTypeArray) {
            [tempArray addObject:wk.levelName];
        }
        
        _selectPickerView.dataArry = tempArray;
        _selectPickerView.delegate = self;
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - 客户具体工作项
- (void)workBtnClick {
    switch (_plan.type) {
        case 4: case 6:{
            if (_selectPickerView == nil) {
                _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
                _selectPickerView.tag = 4;
                _selectPickerView.delegate = self;
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (WKWork* wk in self.workArray) {
                    [tempArray addObject:wk.jobName];
                }
                _selectPickerView.dataArry = tempArray;
                
                [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.cover addSubview:_selectPickerView];
            }
            [self.superview.superview addSubview:self.cover];
            break;
        }
        case 5: case 7: {
            if (_multiSelectPickerView == nil) {
                _multiSelectPickerView = [[MultiSelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
                _multiSelectPickerView.workArray = self.workArray;
                _multiSelectPickerView.delegate = self;
                
                [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.cover addSubview:_multiSelectPickerView];
            }
            
            NSMutableArray *tempArray = [NSMutableArray array];
            if ([_plan.jobtype length] > 0) {
                if ([_plan.jobtype containsString:@","]) {
                    NSArray *array = [_plan.jobtype componentsSeparatedByString:@","];
                    [tempArray addObjectsFromArray:array];
                }else{
                    [tempArray addObject:_plan.jobtype];
                }
            }
            _multiSelectPickerView.chooseArray = tempArray;
            
            [self.superview.superview addSubview:self.cover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 工程项目
- (void)projectBtnClick {
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        _selectPickerView.tag = 5;
        _selectPickerView.delegate = self;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WKProjectResult* pr in self.projectList) {
            [tempArray addObject:pr.projectname];
        }
        _selectPickerView.dataArry = tempArray;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

#pragma mark - MultiSelectPickerViewDelegate
- (void)didFinishMultiSelectPicker:(MultiSelectPickerView *)selectPickerView buttonType:(MultiSelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case MultiSelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case MultiSelectPickerViewButtonTypeSure:{
            NSMutableString *val = [NSMutableString string];
            NSMutableString *dis = [NSMutableString string];
            for (NSString *str in selectPickerView.chooseArray) {
                [val appendString:str];
                [val appendString:@","];
                for (WKWork *wk  in self.workArray) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%d",wk.jobType]]) {
                        [dis appendString:wk.jobName];
                        [dis appendString:@","];
                        break;
                    }
                }
            }
            if ([val length] > 0) {
                NSRange deleteRange = {[val length] - 1, 1};
                [val deleteCharactersInRange:deleteRange];
                self.plan.jobtype = val;
            }else{
                self.plan.jobtype = @"";
            }
            if ([dis length] > 0) {
                NSRange deleteRange = {[dis length] - 1, 1};
                [dis deleteCharactersInRange:deleteRange];
                [_workBtn setTitle:dis forState:UIControlStateNormal];
            }else{
                [_workBtn setTitle:@"" forState:UIControlStateNormal];
            }
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - SelectPickerViewDelegate
- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType {
    if (selectPickerView.tag == 1) { // 工作项
        switch (buttonType) {
            case SelectPickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case SelectPickerViewButtonTypeSure:{
                if ([self.workTypeResultArray count] < 1) {
                    [self tapCover];
                    break;
                }
                WKWorkTypeResult *wk = [self.workTypeResultArray objectAtIndex:selectPickerView.index];
                if (_plan.type == wk.type) {
                    [self tapCover];
                    break;
                }
                _plan.type = wk.type;
                [_planTypeBtn setTitle:wk.typeName forState:UIControlStateNormal];
                _workTypeArray = wk.level2;
                _plan.leveltype = 0;
                _plan.jobtype = @"";
                _plan.projectid = @"";
                _plan.jobremark = @"";
                [self tapCover];
                if ([self.delegate respondsToSelector:@selector(didFinishPlanType:)]) {
                    [self.delegate didFinishPlanType:self];
                }
                break;
            }
            default:
                break;
        }
    }else if (selectPickerView.tag == 2) { // 客户建档
        switch (buttonType) {
            case SelectPickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case SelectPickerViewButtonTypeSure:{
                int prev = _plan.kh_lb;
                NSDictionary *bpcDict = [self.bpcTypeArray objectAtIndex:selectPickerView.index];
                int next = [bpcDict[@"type"] intValue];
                if (prev == next) {
                    [self tapCover];
                    break;
                }
                _plan.khmc = @"";
                _plan.khdm = @"";
                _plan.kh_lb = next;
                [_bpcTypeBtn setTitle:bpcDict[@"typeName"] forState:UIControlStateNormal];
                [self tapCover];
                if ([self.delegate respondsToSelector:@selector(didFinishBpcType:)]) {
                    [self.delegate didFinishBpcType:self];
                }
                break;
            }
            default:
                break;
        }
    }else if (selectPickerView.tag == 3) { // 客户工作类别
        switch (buttonType) {
            case SelectPickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case SelectPickerViewButtonTypeSure:{
                if ([self.workTypeArray count] < 1) {
                    [self tapCover];
                    break;
                }
                WKWorkType *wk = [self.workTypeArray objectAtIndex:selectPickerView.index];
                if (_plan.leveltype == wk.levelType) {
                    [self tapCover];
                    break;
                }
                _plan.leveltype = wk.levelType;
                [_workTypeBtn setTitle:wk.levelName forState:UIControlStateNormal];
                _workArray = wk.jobs;
                _plan.jobtype = @"";
                _plan.jobremark = @"";
                _plan.projectid = @"";
                _plan.jobremark_placeholder = @"";
                if ([self.delegate respondsToSelector:@selector(didFinishWorkType:)]) {
                    [self.delegate didFinishWorkType:self];
                }
                [self tapCover];
                break;
            }
            default:
                break;
        }
    }else if (selectPickerView.tag == 4){ //客户具体工作项
        switch (buttonType) {
            case SelectPickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case SelectPickerViewButtonTypeSure:{
                if ([self.workArray count] < 1) {
                    [self tapCover];
                    break;
                }
                WKWork *wk = [self.workArray objectAtIndex:selectPickerView.index];
                if ([_plan.jobtype isEqualToString:[NSString stringWithFormat:@"%d",wk.jobType]]) {
                    [self tapCover];
                    break;
                }
                _plan.jobtype = [NSString stringWithFormat:@"%d",wk.jobType];
                [_workBtn setTitle:wk.jobName forState:UIControlStateNormal];
                _plan.jobremark_placeholder = wk.jobRemark;
                _plan.jobremark = @"";
                if ([self.delegate respondsToSelector:@selector(didFinishWork:)]) {
                    [self.delegate didFinishWork:self];
                }
                [self tapCover];
                break;
            }
            default:
                break;
        }
    }else if (selectPickerView.tag == 5){ //工程项目
        switch (buttonType) {
            case SelectPickerViewButtonTypeCancle:
                [self tapCover];
                break;
            case SelectPickerViewButtonTypeSure:{
                if ([self.projectList count] < 1) {
                    [self tapCover];
                    break;
                }
                WKProjectResult *pr = [self.projectList objectAtIndex:selectPickerView.index];
                if ([_plan.projectid isEqualToString:pr.projectid]) {
                    [self tapCover];
                    break;
                }
                _plan.projectid = pr.projectid;
                [_projectBtn setTitle:pr.projectname forState:UIControlStateNormal];
                [self tapCover];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - bpcTextFieldChanged
- (void)bpcTextFieldChanged:(UITextField *)bpcTextField {
    if ([bpcTextField.text length] < 1) {
        _plan.khdm = @"";
        _plan.khmc = @"";
    }
}

#pragma mark - operatorTextFieldChanged
- (void)operatorTextFieldChanged:(UITextField *)operatorTextField {
    if ([operatorTextField.text length] < 1) {
        _plan.operatorid = @"";
        _plan.operatorname = @"";
    }
}

#pragma mark - operatorSearchBtnClick
- (void)operatorSearchBtnClick {
    if ([self.delegate respondsToSelector:@selector(planWriteTableCellDidClickOperatorSearch:)]) {
        [self.delegate planWriteTableCellDidClickOperatorSearch:self];
    }
}

#pragma mark - bpcSearchBtnClick
- (void)bpcSearchBtnClick {
    if ([self.delegate respondsToSelector:@selector(planWriteTableCellDidClickBpcSearch:bpcType:)]) {
        [self.delegate planWriteTableCellDidClickBpcSearch:self bpcType:self.plan.kh_lb];
    }
}

#pragma mark - telSearchBtnClick
- (void)telSearchBtnClick {
    if ([self.delegate respondsToSelector:@selector(planWriteTableCellDidClickTelSearch:)]) {
        [self.delegate planWriteTableCellDidClickTelSearch:self];
    }
}

#pragma mark - trackBtnClick
- (void)trackBtnClick {
    if (![_plan.signin isEqual:[NSNull null]] && [_plan.signin length]>0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(planWriteTableCellDidClickTrack:)]) {
        [self.delegate planWriteTableCellDidClickTrack:self];
    }
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 2 || textField.tag == 5) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            self.plan.title = textField.text;
            break;
        case 3:
            self.plan.kh_lxdh = textField.text;
            break;
        case 4:
            self.plan.kh_lxr = textField.text;
            break;
        case 6:
            self.plan.jobremark = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.plan.content = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.plan.content = textView.text;
}

@end
