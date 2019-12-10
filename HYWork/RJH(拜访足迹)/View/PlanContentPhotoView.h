//
//  PlanContentPhotoView.h
//  HYWork
//
//  Created by information on 2017/5/18.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhRemark.h"
@class PlanContentPhotoView;

@protocol PlanContentPhotoViewDelegate <NSObject>
@optional
/** 回复评论 */
- (void)contentPhotoView:(PlanContentPhotoView *)contentPhotoView replyRemark:(RjhRemark *)remark;
/** 删除评论 */
- (void)contentPhotoView:(PlanContentPhotoView *)contentPhotoView deleteRemark:(RjhRemark *)remark;
@end

@class RjhPlanFrame;
@interface PlanContentPhotoView : UIView
@property (nonatomic, weak) RjhPlanFrame  *planFrame;

@property (nonatomic, weak) id<PlanContentPhotoViewDelegate>  delegate;
@end
