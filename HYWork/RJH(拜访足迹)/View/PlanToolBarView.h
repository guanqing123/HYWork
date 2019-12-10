//
//  PlanToolBarView.h
//  HYWork
//
//  Created by information on 2017/5/20.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ToolBarButtonTypeCamera,
    ToolBarButtonTypeComment,
    ToolBarButtonTypeDelete
}ToolBarButtonType;

@class PlanToolBarView;

@protocol PlanToolBarViewDelegate <NSObject>
@optional
- (void)toolBarView:(PlanToolBarView *)toolBar buttonType:(ToolBarButtonType)buttonType;
@end

@interface PlanToolBarView : UIImageView

@property (nonatomic, weak) id<PlanToolBarViewDelegate> delegate;

@property (nonatomic, weak) UIButton  *planCamera;
@property (nonatomic, weak) UIButton  *planComment;
@property (nonatomic, weak) UIButton  *planDelete;

@end
