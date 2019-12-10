//
//  PlanCommentView.h
//  HYWork
//
//  Created by information on 2017/6/12.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RjhRemark.h"
@class PlanCommentView;

@protocol PlanCommentViewDelegate <NSObject>
@optional
/** 回复评论 */
- (void)commentViewDidReplyByRemark:(PlanCommentView *)commentView remark:(RjhRemark *)remark;
/** 长按删除 */
- (void)commentViewLongPressToDelete:(PlanCommentView *)commentView remark:(RjhRemark *)remark;
@end

@interface PlanCommentView : UIImageView
/**
 * 需要展示的评论(数组里面装的都是)
 */
@property (nonatomic, strong)  NSArray *remarks;

@property (nonatomic, weak) id<PlanCommentViewDelegate>  delegate;

@end
