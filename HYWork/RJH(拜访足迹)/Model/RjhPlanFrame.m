//
//  RjhPlanFrame.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#define topViewH 30
#define twoLetterW 40
#define lineHeight 24

#import "RjhPlanFrame.h"
#import "RjhPlan.h"
#import "PlanPhotosView.h"

@implementation RjhPlanFrame

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  获得计划模型数据之后, 根据计划数据计算所有子控件的frame
 */
- (void)setPlan:(RjhPlan *)plan {
    _plan = plan;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - 2 * RjhPlanTableBorder;
    
    // 1.topColorView
    CGFloat topColorViewX = 0;
    CGFloat topColorViewY = 0;
    CGFloat topColorViewW = cellW;
    CGFloat topColorViewH = topViewH;
    _topColorViewF = CGRectMake(topColorViewX, topColorViewY, topColorViewW, topColorViewH);
    
    // 2.timeLabel
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = 0;
    CGFloat timeLabelW = 100;
    CGFloat timeLabelH = topColorViewH;
    _timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    // 3.undertakeLabel
    CGFloat undertakeLabelX = CGRectGetMaxX(_timeLabelF);
    CGFloat undertakeLabelY = 0;
    CGFloat undertakeLabelW = cellW - 2 * timeLabelW;
    if ([plan.operatorid isEqual:[NSNull null]] || [plan.operatorid length] < 1) {
        undertakeLabelW = 0;
    }
    CGFloat undertakeLabelH = topColorViewH;
    _undertakeLabelF = CGRectMake(undertakeLabelX, undertakeLabelY, undertakeLabelW, undertakeLabelH);
    
    // 4.trashBtn
    CGFloat attendanceBtnX = cellW - topViewH;
    CGFloat attendanceBtnY = 0;
    CGFloat attendanceBtnWH = topColorViewH;
    _attendanceBtnF = CGRectMake(attendanceBtnX, attendanceBtnY, attendanceBtnWH, attendanceBtnWH);
    
    // 5.middelTextView
    CGFloat middelTextViewX = 0;
    CGFloat middelTextViewY = CGRectGetMaxY(_topColorViewF);
    CGFloat middelTextViewW = cellW;
    CGFloat middelTextViewH = 0;
    
    // 6.titleLabel
    CGFloat titleLabelX = RjhPlanTableBorder;
    CGFloat titleLabelY = RjhPlanTableBorder;
    CGFloat titleLabelW = twoLetterW;
    CGFloat titleLabelH = lineHeight;
    _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // 7.title
    CGFloat titleX = CGRectGetMaxX(_titleLabelF);
    CGFloat titleY = titleLabelY;
    CGFloat titleW = cellW - titleLabelW - 2 * RjhPlanTableBorder;
    CGFloat titleH = lineHeight;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);

    // 8.kh / tel
    if (_plan.type != 2 && _plan.type != 3) {
        /** 客户label */
        CGFloat khLabelX = RjhPlanTableBorder;
        CGFloat khLabelY = CGRectGetMaxY(_titleLabelF);
        CGFloat khLabelW = twoLetterW;
        CGFloat khLabelH = lineHeight;
        _khLabelF = CGRectMake(khLabelX, khLabelY, khLabelW, khLabelH);
        
        /** 客户内容label */
        CGFloat khX = CGRectGetMaxX(_khLabelF);
        CGFloat khY = khLabelY;
        CGFloat khW = cellW - khLabelW - 2 * RjhPlanTableBorder;
        CGFloat khH = lineHeight;
        _khF = CGRectMake(khX, khY, khW, khH);
        
        /** 联系人/联系电话label */
        CGFloat telLabelX = khLabelX;
        CGFloat telLabelY = CGRectGetMaxY(_khLabelF);
        CGFloat telLabelW = twoLetterW * 3;
        CGFloat telLabelH = lineHeight;
        _telLabelF = CGRectMake(telLabelX, telLabelY, telLabelW, telLabelH);
        
        /** 联系人内容label */
        CGFloat telX = CGRectGetMaxX(_telLabelF);
        CGFloat telY = telLabelY;
        CGFloat telW = 60;
        CGFloat telH = lineHeight;
        _telF = CGRectMake(telX, telY, telW, telH);
        
        /** 联系电话内容label */
        CGFloat phoneBtnX = CGRectGetMaxX(_telF);
        CGFloat phoneBtnY = telLabelY;
        CGFloat maxPhoneBtnW = cellW - phoneBtnX - 2 * RjhPlanTableBorder;
        CGFloat phoneBtnW = 0;
        if (![plan.kh_lxdh isEqual:[NSNull null]] && [plan.kh_lxdh length] > 0) {
            CGSize  contentSize = [self sizeWithText:plan.kh_lxdh font:RjhTextFont maxSize:CGSizeMake(maxPhoneBtnW, lineHeight)];
            phoneBtnW = contentSize.width;
        }
        CGFloat phoneBtnH = lineHeight;
        _phoneBtnF = CGRectMake(phoneBtnX, phoneBtnY, phoneBtnW, phoneBtnH);
        
        middelTextViewH = CGRectGetMaxY(_telLabelF) + RjhPlanTableBorder;
    }else{
        middelTextViewH = CGRectGetMaxY(_titleF) + RjhPlanTableBorder;
    }
    _middelTextViewF = CGRectMake(middelTextViewX, middelTextViewY, middelTextViewW, middelTextViewH);
    
    // 9.contentPhotoView
    CGFloat contentPhotoViewX = 0;
    CGFloat contentPhotoViewY = CGRectGetMaxY(_middelTextViewF);
    CGFloat contentPhotoViewW = cellW;
    CGFloat contentPhotoViewH = 0;
    
    // 10.contentLabel
    CGFloat contentLabelX = RjhPlanTableBorder;
    CGFloat contentLabelY = RjhPlanTableBorder;
    CGFloat contentLabelW = cellW - 2 * contentLabelX;
    CGFloat contentLabelH = 0;
    if (![plan.content isEqual:[NSNull null]] && [plan.content length] > 0) {
        CGSize  contentSize = [self sizeWithText:plan.content font:RjhTextFont maxSize:CGSizeMake(contentLabelW, MAXFLOAT)];
        contentLabelH = contentSize.height;
    }
    _contentLabelF = CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH);
    
    // 11.photosView
    if (![plan.imagesurl isEqual:[NSNull null]] && plan.imagesurl.count) {
        CGSize photosViewSize = [PlanPhotosView photosViewSizeWithPhotosCount:(int)plan.imagesurl.count];
        CGFloat photosViewX = contentLabelX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + RjhPlanCellBorder;
        _photosViewF = (CGRect){{photosViewX, photosViewY},photosViewSize};
    }
    
    // 12.kqBtn
    CGFloat kqBtnX = 0;
    CGFloat kqBtnY = 0;
    if (![plan.imagesurl isEqual:[NSNull null]] && plan.imagesurl.count) {
        kqBtnY = CGRectGetMaxY(_photosViewF) + RjhPlanCellBorder;
    }else{
        kqBtnY = CGRectGetMaxY(_contentLabelF) + RjhPlanCellBorder;
    }
    CGFloat kqBtnW = lineHeight;
//    CGFloat kqBtnH = lineHeight;
//    _kqBtnF = CGRectMake(kqBtnX, kqBtnY, kqBtnW, kqBtnH);
    
    // 13.addressLabel
    CGFloat addressLabelX = kqBtnW;
    CGFloat addressLabelY = kqBtnY;
    CGFloat addressLabelW = cellW - kqBtnW;
    CGFloat addressLabelH = 0;
    if (![plan.signin isEqual:[NSNull null]] && [plan.signin length] > 0) {
        CGSize  addressSize = [self sizeWithText:plan.signin font:RjhTextFont maxSize:CGSizeMake(addressLabelW, MAXFLOAT)];
        addressLabelH = addressSize.height;
    }
    _addressLabelF = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    CGFloat kqBtnH = addressLabelH;
    _kqBtnF = CGRectMake(kqBtnX, kqBtnY, kqBtnW, kqBtnH);
    
    // 14.kqTimeBtn
    CGFloat kqTimeBtnX = 0;
    CGFloat kqTimeBtnY = CGRectGetMaxY(_kqBtnF);
    CGFloat kqTimeBtnW = lineHeight;
    
    // 15.kqTimeLabel
    CGFloat kqTimeLabelX = kqTimeBtnW;
    CGFloat kqTimeLabelY = kqTimeBtnY;
    CGFloat kqTimeLabelW = cellW - kqTimeBtnW;
    CGFloat kqTimeLabelH = 0;
    if (![plan.signin_time isEqual:[NSNull null]] && [plan.signin_time length] > 0) {
        kqTimeLabelH = lineHeight;
    }
    _kqTimeLabelF = CGRectMake(kqTimeLabelX, kqTimeLabelY, kqTimeLabelW, kqTimeLabelH);
    
    CGFloat kqTimeBtnH = kqTimeLabelH;
    _kqTimeBtnF = CGRectMake(kqTimeBtnX, kqTimeBtnY, kqTimeBtnW, kqTimeBtnH);
    
    // 16.comment
    CGFloat commentViewX = RjhPlanTableBorder;
    CGFloat commentViewY = CGRectGetMaxY(_kqTimeBtnF);
    CGFloat commentViewW = cellW - 2 * commentViewX;
    CGFloat commentViewH = 0;
    if (![plan.remarklist isEqual:[NSNull null]] && [plan.remarklist count] > 0) {
        for (int i = 0; i < [plan.remarklist count]; i ++) {
            RjhRemark *remark = [plan.remarklist objectAtIndex:i];
            CGFloat remarkX = 0;
            CGFloat remarkY = 0;
            if (i == 0) {
              remarkY = 7;
            }else{
                CGRect tempF =  CGRectFromString(((RjhRemark *)[plan.remarklist objectAtIndex:(i - 1)]).remarkF);
                remarkY = CGRectGetMaxY(tempF);
            }
            CGFloat remarkW = commentViewW;
            
            NSString *mark = @"";
            if (![remark.sendeename isEqual:[NSNull null]] && [remark.sendeename length] > 0) {
                mark = [NSString stringWithFormat:@"%@回复%@:%@",remark.operatorname,remark.sendeename,remark.remark];
            }else{
                mark = [NSString stringWithFormat:@"%@:%@",remark.operatorname,remark.remark];
            }
            CGSize  remarkSize = [self sizeWithText:mark font:RjhTextFont maxSize:CGSizeMake(remarkW, MAXFLOAT)];
            CGFloat remarkH = remarkSize.height;
            remark.remarkF = NSStringFromCGRect(CGRectMake(remarkX, remarkY, remarkW, remarkH));
            if (i == [plan.remarklist count] - 1) {
                commentViewH = CGRectGetMaxY(CGRectFromString(remark.remarkF)) + 1;
            }
        }
        _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
        
        contentPhotoViewH = CGRectGetMaxY(_commentViewF) + RjhPlanTableBorder;
    }else{
        _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
        
        contentPhotoViewH = CGRectGetMaxY(_kqTimeBtnF) + RjhPlanTableBorder;
    }
    _contentPhotoViewF = CGRectMake(contentPhotoViewX, contentPhotoViewY, contentPhotoViewW, contentPhotoViewH);
    
    // 16.toolBarView
    CGFloat toolBarViewX = 0;
    CGFloat toolBarViewY = CGRectGetMaxY(_contentPhotoViewF) + 1;
    CGFloat toolBarViewW = cellW;
    CGFloat toolBarViewH = topViewH;
    _toolbarViewF = CGRectMake(toolBarViewX, toolBarViewY, toolBarViewW, toolBarViewH);
    
    // 17.cellHeight
    _cellHeight = CGRectGetMaxY(_toolbarViewF) + RjhPlanTableBorder;
}

@end
