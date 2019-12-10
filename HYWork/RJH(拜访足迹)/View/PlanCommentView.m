//
//  PlanCommentView.m
//  HYWork
//
//  Created by information on 2017/6/12.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "PlanCommentView.h"
#import "UIImage+Extension.h"
#import "RjhRemark.h"
// 正文的字体
#define RjhTextFont [UIFont systemFontOfSize:14]

@implementation PlanCommentView


- (void)setRemarks:(NSArray *)remarks {
    _remarks = remarks;
    
    // 删除之前的,然后再添加
    for (UILabel *commentLabel in self.subviews) {
        if ([commentLabel isKindOfClass:[UILabel class]]) {
            [commentLabel removeFromSuperview];
        }
    }
    
    
    int i = 0;
    for (RjhRemark *remark in remarks) {
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.tag = i;
        i++;
        commentLabel.numberOfLines = 0;
        commentLabel.font = RjhTextFont;
        commentLabel.textAlignment = NSTextAlignmentLeft;
        NSString *mark = @"";
        if (![remark.sendeename isEqual:[NSNull null]] && [remark.sendeename length] > 0) {
            mark = [NSString stringWithFormat:@"%@回复%@:%@",remark.operatorname,remark.sendeename,remark.remark];
            
            int operatornameL =  (int)[remark.operatorname length];
            int sendeenameL = (int)[remark.sendeename length];
            int remarkL = (int)[remark.remark length];
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:mark];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:GQColor(60, 90, 152) range:NSMakeRange(0, operatornameL)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(operatornameL, 2)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:GQColor(60, 90, 152) range:NSMakeRange(operatornameL + 2, sendeenameL)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(operatornameL + 2 +sendeenameL, remarkL)];
            
            [commentLabel setAttributedText:attributeStr];
        }else{
            mark = [NSString stringWithFormat:@"%@:%@",remark.operatorname,remark.remark];
            
            int operatornameL =  (int)[remark.operatorname length];
            int remarkL = (int)[remark.remark length];
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:mark];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:GQColor(60, 90, 152) range:NSMakeRange(0, operatornameL)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(operatornameL, remarkL)];
            
            [commentLabel setAttributedText:attributeStr];
        }
        commentLabel.frame = CGRectFromString(remark.remarkF);
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPress:)];
        longPressRecognizer.minimumPressDuration = 1.0;
        commentLabel.userInteractionEnabled = YES;
        [commentLabel addGestureRecognizer:recognizer];
        [commentLabel addGestureRecognizer:longPressRecognizer];
        
        [self addSubview:commentLabel];
    }
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(commentViewDidReplyByRemark:remark:)]) {
        [self.delegate commentViewDidReplyByRemark:self remark:[self.remarks objectAtIndex:recognizer.view.tag]];
    }
}

- (void)labelLongPress2:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //让当前的对象成为第一响应者
        [self becomeFirstResponder];
        //创建UIMenuController的控件
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
        UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delete:)];
        
        
        //[menu setMenuVisible:NO];
        
        [menu setMenuItems:[NSArray arrayWithObjects:copy, delete, nil]];
        menu.arrowDirection = UIMenuControllerArrowDown;
        [menu setTargetRect:recognizer.view.frame inView:self];
        [menu update];
        [menu setMenuVisible:YES animated:YES];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"point = %@",NSStringFromCGPoint(point));
//}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)labelLongPress:(UILongPressGestureRecognizer *)recognizer {
     if (recognizer.state == UIGestureRecognizerStateBegan) {
         if ([self.delegate respondsToSelector:@selector(commentViewLongPressToDelete:remark:)]) {
             [self.delegate commentViewLongPressToDelete:self remark:[self.remarks objectAtIndex:recognizer.view.tag]];
         }
     }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage resizableImage:@"LikeCmtBg"]];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
