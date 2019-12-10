//
//  PlanContentPhotoView.m
//  HYWork
//
//  Created by information on 2017/5/18.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "PlanContentPhotoView.h"
#import "PlanPhotosView.h"
#import "PlanCommentView.h"
#import "RjhPlanFrame.h"
#import "RjhPlan.h"

@interface PlanContentPhotoView()<PlanCommentViewDelegate>
/** 正文内容 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 图片 */
@property (nonatomic, weak) PlanPhotosView *photosView;
/** 考勤图标 */
@property (nonatomic, weak) UIButton  *kqBtn;
/** 考勤地址 */
@property (nonatomic, weak) UILabel  *addressLabel;
/** 签到时间图标 */
@property (nonatomic, weak) UIButton  *kqTimeBtn;
/** 签到时间 */
@property (nonatomic, weak) UILabel  *kqTimeLabel;
/** 评论 */
@property (nonatomic, weak) PlanCommentView *commentView;
@end

@implementation PlanContentPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 0.设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.正文内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = RjhTextFont;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 2.图片
        PlanPhotosView *photosView = [[PlanPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
        
        // 7.考勤图标
        UIButton *kqBtn = [[UIButton alloc] init];
        [kqBtn setImage:[UIImage imageNamed:@"planSingIn"] forState:UIControlStateNormal];
        [self addSubview:kqBtn];
        self.kqBtn = kqBtn;
        
        // 8.考勤地点
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = RjhTextFont;
        addressLabel.numberOfLines = 0;
        addressLabel.textColor = GQColor(170, 170, 170);
        [self addSubview:addressLabel];
        self.addressLabel = addressLabel;
        
        // 9.考勤时间图标
        UIButton *kqTimeBtn = [[UIButton alloc] init];
        [kqTimeBtn setImage:[UIImage imageNamed:@"planSingInTime"] forState:UIControlStateNormal];
        [self addSubview:kqTimeBtn];
        self.kqTimeBtn = kqTimeBtn;
        
        // 10.考勤时间
        UILabel *kqTimeLabel = [[UILabel alloc] init];
        kqTimeLabel.font = RjhTextFont;
        kqTimeLabel.numberOfLines = 0;
        kqTimeLabel.textColor = GQColor(170, 170, 170);
        [self addSubview:kqTimeLabel];
        self.kqTimeLabel = kqTimeLabel;
        
        // 11.评论
        PlanCommentView *commentView = [[PlanCommentView alloc] init];
        commentView.delegate = self;
        [self addSubview:commentView];
        self.commentView = commentView;
    }
    return self;
}

/** PlanCommentViewDelegate */
- (void)commentViewDidReplyByRemark:(PlanCommentView *)commentView remark:(RjhRemark *)remark {
    if ([self.delegate respondsToSelector:@selector(contentPhotoView:replyRemark:)]) {
        [self.delegate contentPhotoView:self replyRemark:remark];
    }
}

- (void)commentViewLongPressToDelete:(PlanCommentView *)commentView remark:(RjhRemark *)remark {
    if ([self.delegate respondsToSelector:@selector(contentPhotoView:deleteRemark:)]) {
        [self.delegate contentPhotoView:self deleteRemark:remark];
    }
}

- (void)setPlanFrame:(RjhPlanFrame *)planFrame {
    _planFrame = planFrame;
    
    // 1.取出模型数据
    RjhPlan *plan = planFrame.plan;
    
    // 1.正文内容
    self.contentLabel.frame = self.planFrame.contentLabelF;
    self.contentLabel.text = [plan.content isEqual:[NSNull null]] ? @"" : plan.content;
    
    // 2.图片
    if (![plan.imagesurl isEqual:[NSNull null]] && plan.imagesurl.count) {
        self.photosView.hidden = NO;
        self.photosView.frame = self.planFrame.photosViewF;
        self.photosView.photos = plan.imagesurl;
    }else{
        self.photosView.hidden = YES;
    }
    
    // 7.考勤图标
    self.kqBtn.frame = self.planFrame.kqBtnF;
    
    // 8.考勤地点
    self.addressLabel.frame = self.planFrame.addressLabelF;
    self.addressLabel.text = [plan.signin isEqual:[NSNull null]] ? @"" : plan.signin;
    
    // 9.考勤时间图标
    self.kqTimeBtn.frame = self.planFrame.kqTimeBtnF;
    
    // 10.考勤时间
    self.kqTimeLabel.frame = self.planFrame.kqTimeLabelF;
    self.kqTimeLabel.text = [plan.signin_time isEqual:[NSNull null]] ? @"" : plan.signin_time;
    
    // 11.评论
    self.commentView.frame = self.planFrame.commentViewF;
    self.commentView.remarks = plan.remarklist;
}

@end
