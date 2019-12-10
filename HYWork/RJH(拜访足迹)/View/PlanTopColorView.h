//
//  PlanTopColorView.h
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlanTopColorView;

@protocol PlanTopColorViewDelegate <NSObject>
@optional
- (void)planTopColorViewDidClickAttendanceBtn:(PlanTopColorView *)topColorView;
@end

@class RjhPlanFrame;
@interface PlanTopColorView : UIImageView
@property (nonatomic, strong)  RjhPlanFrame *planFrame;

@property (nonatomic, weak) id<PlanTopColorViewDelegate>  delegate;
@end
