//
//  RjhCommentViewController.m
//  HYWork
//
//  Created by information on 2017/6/12.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhCommentViewController.h"
#import "IWTextView.h"
#import "RjhRemark.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "RjhManager.h"
#import "LoadViewController.h"


@interface RjhCommentViewController () <UITextViewDelegate>
@property (nonatomic, weak) IWTextView  *textView;
@property (nonatomic, copy) NSString *logid;
@property (nonatomic, strong) RjhRemark *remark;
@end

@implementation RjhCommentViewController

- (id)initWithLogid:(NSString *)logid rjhRemark:(RjhRemark *)remark {
    if (self = [super init]) {
        _logid = logid;
        _remark = remark;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航栏属性
    [self setupNavBar];
    
    // 添加textView
    [self setupTextView];
}

/** 添加textView */
- (void)setupTextView {
    // 1.添加
    IWTextView *textView = [[IWTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    textView.frame = self.view.bounds;
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = [self.remark.operatorname length] < 1 ? @"说些什么..." : [NSString stringWithFormat:@"回复 %@",self.remark.operatorname];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 2.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}

/** 页面滚动退键盘 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

/** 页面将要显示的时候调出键盘 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

/** 监听文字改变 */
- (void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
}

/** 设置导航栏属性 */
- (void)setupNavBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"评论";
}

/** 取消 */
- (void)cancel {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/** 评论 */
- (void)send {
    [self.textView resignFirstResponder];
    [MBProgressHUD showMessage:@"正在提交评论..." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logid"] = self.logid;
    params[@"operatorid"] = [LoadViewController shareInstance].emp.ygbm;
    params[@"sendeeid"] = self.remark.operatorid;
    params[@"remark"] = self.textView.text;
    [RjhManager saveCommentWithParameters:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD showSuccess:@"评论成功"];
            if ([self.delegate respondsToSelector:@selector(rjhCommentViewControllerDidComment:)]) {
                [self.delegate rjhCommentViewControllerDidComment:self];
            }
            // 关闭控制器
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"评论失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return false;
    }
    //判断键盘是不是九宫格键盘
    if ([self isNineKeyBoard:text]) {
        return YES;
    }else{
        if ([self hasEmoji:text] || [self stringContainsEmoji:text]) {
            return false;
        }
    }
    return true;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/** 利用下面这个方法stringContainsEmoji可以限制系统键盘自带的表情 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

#pragma mark -屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
