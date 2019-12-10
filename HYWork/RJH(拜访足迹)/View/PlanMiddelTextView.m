//
//  PlanMiddelTextView.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#define fieldFont [UIFont systemFontOfSize:14]

#import "PlanMiddelTextView.h"
#import "RjhPlanFrame.h"
#import "RjhPlan.h"

@interface PlanMiddelTextView()
/** 标题title */
@property (nonatomic, weak) UILabel  *titleLabel;
@property (nonatomic, weak) UILabel  *title;
/** 客户kh */
@property (nonatomic, weak) UILabel  *khLabel;
@property (nonatomic, weak) UILabel  *kh;
/** 联系人/联系电话 */
@property (nonatomic, weak) UILabel  *telLabel;
@property (nonatomic, weak) UILabel  *tel;
@property (nonatomic, weak) UIButton  *phoneBtn;

/** 打电话 */
@property (nonatomic, strong)  UIWebView *webView;
@end

@implementation PlanMiddelTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
        
        // 0.设置背景色
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.标题label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"标题";
        titleLabel.font = fieldFont;
        titleLabel.textColor = GQColor(153, 153, 153);
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // 2.标题内容label
        UILabel *title = [[UILabel alloc] init];
        title.font = fieldFont;
        [self addSubview:title];
        self.title = title;
        
        // 3.客户label
        UILabel *khLabel = [[UILabel alloc] init];
        khLabel.text = @"客户";
        khLabel.font = fieldFont;
        khLabel.textColor = GQColor(153, 153, 153);
        [self addSubview:khLabel];
        self.khLabel = khLabel;
        
        // 4.客户内容label
        UILabel *kh = [[UILabel alloc] init];
        kh.font = fieldFont;
        [self addSubview:kh];
        self.kh = kh;
        
        // 5.联系人/联系电话label
        UILabel *telLabel = [[UILabel alloc] init];
        telLabel.text = @"联系人/联系电话";
        telLabel.font = fieldFont;
        telLabel.textColor = GQColor(153, 153, 153);
        [self addSubview:telLabel];
        self.telLabel = telLabel;
        
        // 6.联系人/联系电话内容label
        UILabel *tel = [[UILabel alloc] init];
        tel.textAlignment = NSTextAlignmentCenter;
        tel.font = fieldFont;
        [self addSubview:tel];
        self.tel = tel;
    
        UIButton *phoneBtn = [[UIButton alloc] init];
        phoneBtn.titleLabel.font = fieldFont;
//      phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//      phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setTitleColor:GQColor(0, 122, 255) forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:phoneBtn];
        self.phoneBtn = phoneBtn;
    }
    return self;
}

- (void)setPlanFrame:(RjhPlanFrame *)planFrame {
    _planFrame = planFrame;
    
    // 1.取出模型
    RjhPlan *plan = planFrame.plan;
    
    // 2.标题label
    self.titleLabel.frame = self.planFrame.titleLabelF;
    
    // 3.标题内容label
    self.title.frame = self.planFrame.titleF;
    self.title.text = [plan.title isEqual:[NSNull null]] ? @"" : plan.title;
    
    // 4.kh / tel
    if (plan.type != 2 && plan.type != 3) {
        // 4.1 客户label
        self.khLabel.hidden = NO;
        self.khLabel.frame = self.planFrame.khLabelF;
        
        // 4.2 客户内容label
        self.kh.hidden = NO;
        self.kh.frame = self.planFrame.khF;
        self.kh.text = [plan.khmc isEqual:[NSNull null]] ? @"" : plan.khmc;
        
        // 4.3 联系人/联系电话label
        self.telLabel.hidden = NO;
        self.telLabel.frame = self.planFrame.telLabelF;
        
        // 4.4 联系人/联系电话内容label
        self.tel.hidden = NO;
        self.tel.frame = self.planFrame.telF;
        self.tel.text = [NSString stringWithFormat:@"%@",[plan.kh_lxr isEqual:[NSNull null]] ? @"" : plan.kh_lxr];
        
        // 4.5 联系电话内容label
        self.phoneBtn.hidden = NO;
        self.phoneBtn.frame = self.planFrame.phoneBtnF;
        [self.phoneBtn setTitle:[plan.kh_lxdh isEqual:[NSNull null]] ? @"" : plan.kh_lxdh forState:UIControlStateNormal];
    } else {
        // 4.1 客户label
        self.khLabel.hidden = YES;
        
        // 4.2 客户内容label
        self.kh.hidden = YES;
        
        // 4.3 联系人/联系电话label
        self.telLabel.hidden = YES;
        
        // 4.4 联系人内容label
        self.tel.hidden = YES;
        
        // 4.5 联系电话内容label
        self.phoneBtn.hidden = YES;
    }
}

/** 打电话 */
#pragma mark - 打电话
- (void)phoneBtnClick:(UIButton *)phoneBtn {
    if ([phoneBtn.titleLabel.text isEqual:[NSNull null]]) {
        return;
    }
    //BOOL flag = [self checkPhoneNum:phoneBtn.titleLabel.text];
    //if (flag) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneBtn.titleLabel.text]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    //}
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

/** 是否为手机号码 */
- (BOOL)checkPhoneNum:(NSString *)str {
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

@end
