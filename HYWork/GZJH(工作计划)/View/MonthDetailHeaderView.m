//
//  MonthDetailHeaderView.m
//  HYWork
//
//  Created by information on 16/6/27.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "MonthDetailHeaderView.h"
#import "InsetsLabel.h"
#import "HYButton.h"
#import "CustomActionSheet.h"

#define TextFont [UIFont systemFontOfSize:14.0f]

@interface MonthDetailHeaderView()<CustomActionSheetDelagate,UITextViewDelegate>
@property (nonatomic, weak) HYButton  *jhztBtn;
@property (nonatomic, weak) UITextView  *pyTextView;
@end

@implementation MonthDetailHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"monthDetailHeaderView";
    MonthDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [[MonthDetailHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        CGFloat padding = 10;
        // 1.自评.任务状态
        InsetsLabel *jhztLabel = [[InsetsLabel alloc] init];
        jhztLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
        jhztLabel.text = @"自评.任务状态:";
        jhztLabel.font = TextFont;
        jhztLabel.textColor = GQColor(40, 200, 65);
        [self.contentView addSubview:jhztLabel];
        CGFloat jhztLabelX = 0;
        CGFloat jhztLabelY = 0;
        CGFloat jhztLabelW = SCREEN_WIDTH * 0.4;
        CGFloat jhztLabelH = 44.0f;
        jhztLabel.frame = CGRectMake(jhztLabelX, jhztLabelY, jhztLabelW, jhztLabelH);
        
        
        HYButton *jhztBtn = [HYButton customButton];
        [jhztBtn addTarget:self action:@selector(jhztBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _jhztBtn = jhztBtn;
        [self.contentView addSubview:jhztBtn];
        CGFloat jhztBtnX = CGRectGetMaxX(jhztLabel.frame);
        CGFloat jhztBtnH = 30.0f;
        CGFloat jhztBtnY = (jhztLabelH - jhztBtnH)/2;
        CGFloat jhztBtnW = SCREEN_WIDTH * 0.5;
        jhztBtn.frame = CGRectMake(jhztBtnX, jhztBtnY, jhztBtnW, jhztBtnH);
        
        
        UIView *jhztView = [[UIView alloc] init];
        jhztView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [self.contentView addSubview:jhztView];
        CGFloat jhztViewX = 0;
        CGFloat jhztViewY = CGRectGetMaxY(jhztLabel.frame);
        CGFloat jhztViewW = SCREEN_WIDTH;
        CGFloat jhztViewH = 1.0f;
        jhztView.frame = CGRectMake(jhztViewX, jhztViewY, jhztViewW, jhztViewH);
        
        // 2.自评.评议
        InsetsLabel *pyLabel = [[InsetsLabel alloc] init];
        pyLabel.insets = UIEdgeInsetsMake(0, padding, 0, 0);
        pyLabel.text = @"自评.评议:";
        pyLabel.font = TextFont;
        pyLabel.textColor = GQColor(40, 200, 65);
        [self.contentView addSubview:pyLabel];
        CGFloat pyLabelX = 0;
        CGFloat pyLabelY = CGRectGetMaxY(jhztView.frame);
        CGFloat pyLabelW = SCREEN_WIDTH;
        CGFloat pyLabelH = 30.0f;
        pyLabel.frame = CGRectMake(pyLabelX, pyLabelY, pyLabelW, pyLabelH);
        
        
        UITextView *pyTextView = [[UITextView alloc] init];
        pyTextView.tag = 0;
        pyTextView.font = TextFont;
        pyTextView.layer.borderWidth  = 1.0f;
        pyTextView.layer.cornerRadius = 5.0;
        pyTextView.layer.borderColor  = GQColor(200.0f, 200.0f, 200.0f).CGColor;
        pyTextView.delegate = self;
        pyTextView.returnKeyType = UIReturnKeyDone;
        _pyTextView = pyTextView;
        [self.contentView addSubview:pyTextView];
        CGFloat pyTextViewX = padding;
        CGFloat pyTextViewY = CGRectGetMaxY(pyLabel.frame);
        CGFloat pyTextViewW = SCREEN_WIDTH - padding * 2;
        CGFloat pyTextViewH = 44.0f;
        pyTextView.frame = CGRectMake(pyTextViewX, pyTextViewY, pyTextViewW, pyTextViewH);
        
        
        UIView *pyView = [[UIView alloc] init];
        pyView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [self.contentView addSubview:pyView];
        CGFloat pyViewX = 0;
        CGFloat pyViewY = CGRectGetMaxY(pyTextView.frame) + padding;
        CGFloat pyViewW = SCREEN_WIDTH;
        CGFloat pyViewH = 1.0f;
        pyView.frame = CGRectMake(pyViewX, pyViewY, pyViewW, pyViewH);
    }
    return self;
}

- (void)setMonthPlan:(MonthPlan *)monthPlan {
    _monthPlan = monthPlan;
    
    if ([monthPlan.jhzt isKindOfClass:[NSNull class]]){
        monthPlan.jhzt = @"0";
    }else{
        /**  任务状态 */
        switch ([monthPlan.jhzt intValue]) {
            case 1:
                [self.jhztBtn setVal:@"1" andDis:@"进行中"];
                break;
            case 2:
                [self.jhztBtn setVal:@"2" andDis:@"已完结"];
                break;
            case 3:
                [self.jhztBtn setVal:@"3" andDis:@"暂停"];
                break;
            case 4:
                [self.jhztBtn setVal:@"4" andDis:@"取消"];
                break;
            default:
                break;
        }
    }

    /** 评议 */
    if ([monthPlan.py isKindOfClass:[NSNull class]]) {
        self.pyTextView.text = @"";
    }else{
        self.pyTextView.text = monthPlan.py;
    }
}

- (void)jhztBtnClick:(HYButton *)btn {
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"任务状态" otherButtonTitles:@[@"进行中",@"已完结",@"暂停",@"取消"]];
    sheet.delegate = self;
    [sheet show];
}

#pragma mark - CustomActionSheetDelagate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0 : {
            self.monthPlan.jhzt = @"1";
            [self.jhztBtn setVal:@"1" andDis:@"进行中"];
            break;
        }
        case 1 : {
            self.monthPlan.jhzt = @"2";
            [self.jhztBtn setVal:@"2" andDis:@"已完结"];
            break;
        }
        case 2 : {
            self.monthPlan.jhzt = @"3";
            [self.jhztBtn setVal:@"3" andDis:@"暂停"];
            break;
        }
        case 3 : {
            self.monthPlan.jhzt = @"4";
            [self.jhztBtn setVal:@"4" andDis:@"取消"];
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
    self.monthPlan.py = textView.text;
}

@end
