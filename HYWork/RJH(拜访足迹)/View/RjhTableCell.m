//
//  RjhTableCell.m
//  HYWork
//
//  Created by information on 2017/5/17.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhTableCell.h"
#import "PlanTopColorView.h"
#import "PlanMiddelTextView.h"
#import "PlanContentPhotoView.h"
#import "RjhPlanFrame.h"

@interface RjhTableCell()<PlanToolBarViewDelegate,PlanTopColorViewDelegate,PlanContentPhotoViewDelegate>
/** 顶部颜色view */
@property (nonatomic, weak) PlanTopColorView  *topColorView;
/** 中间文本view */
@property (nonatomic, weak) PlanMiddelTextView  *middelTextView;
/** 底部文本图片view */
@property (nonatomic, weak) PlanContentPhotoView  *contentPhotoView;
/** 底部工具条view */
@property (nonatomic, weak) PlanToolBarView  *toolBarView;
@end

@implementation RjhTableCell

#pragma mark -初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"plan";
    RjhTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RjhTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 0.非常重要
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = GQColor(226, 226, 226);
        
        // 1.添加顶部颜色view
        [self setupTopColorView];
        
        // 2.中间描述的view
        [self setupMiddleTextView];
        
        // 3.底部正文/图片view
        [self setupContentPhotoView];
        
        // 4.设置工具条
        [self setupToolBarView];
    }
    return self;
}

/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += RjhPlanTableBorder;
    frame.origin.x = RjhPlanTableBorder;
    frame.size.width -= 2 * RjhPlanTableBorder;
    frame.size.height -= RjhPlanTableBorder;
    [super setFrame:frame];
}

/**
 * 添加顶部颜色view
 */
- (void)setupTopColorView {
    /** 顶部的颜色view */
    PlanTopColorView *topColorView = [[PlanTopColorView alloc] init];
    topColorView.delegate = self;
    [self.contentView addSubview:topColorView];
    self.topColorView = topColorView;
}

#pragma mark PlanTopColorViewDelegate
- (void)planTopColorViewDidClickAttendanceBtn:(PlanTopColorView *)topColorView {
    if ([self.delegate respondsToSelector:@selector(tableCellTopColorViewDidClickAttendanceBtn:)]) {
        [self.delegate tableCellTopColorViewDidClickAttendanceBtn:self];
    }
}

/**
 * 添加中间文本view
 */
- (void)setupMiddleTextView {
    /** 添加中间文本view */
    PlanMiddelTextView *middelTextView = [[PlanMiddelTextView alloc] init];
    [self.contentView addSubview:middelTextView];
    self.middelTextView = middelTextView;
}

/**
 * 底部正文/图片view
 */
- (void)setupContentPhotoView {
    /** 底部正文/图片view */
    PlanContentPhotoView *contentPhotoView = [[PlanContentPhotoView alloc] init];
    contentPhotoView.delegate = self;
    [self.contentView addSubview:contentPhotoView];
    self.contentPhotoView = contentPhotoView;
}

/** PlanContentPhotoViewDelegate */
- (void)contentPhotoView:(PlanContentPhotoView *)contentPhotoView replyRemark:(RjhRemark *)remark{
    if ([self.delegate respondsToSelector:@selector(tableCell:replyRemark:)]) {
        [self.delegate tableCell:self replyRemark:remark];
    }
}

- (void)contentPhotoView:(PlanContentPhotoView *)contentPhotoView deleteRemark:(RjhRemark *)remark {
    if ([self.delegate respondsToSelector:@selector(tableCell:deleteRemark:)]) {
        [self.delegate tableCell:self deleteRemark:remark];
    }
}

/**
 *  添加底部的工具条
 */
- (void)setupToolBarView {
    /** 底部正文/图片view */
    PlanToolBarView *toolBarView = [[PlanToolBarView alloc] init];
    toolBarView.delegate = self;
    [self.contentView addSubview:toolBarView];
    self.toolBarView = toolBarView;
}

#pragma mark PlanToolBarViewDelegate
- (void)toolBarView:(PlanToolBarView *)toolBar buttonType:(ToolBarButtonType)buttonType {
    if ([self.delegate respondsToSelector:@selector(tableCell:buttonType:)]) {
        [self.delegate tableCell:self buttonType:buttonType];
    }
}

#pragma mark - 数据的设置
/**
 * 数据的设置
 */
- (void)setPlanFrame:(RjhPlanFrame *)planFrame {
    _planFrame = planFrame;
    
    //1.设置顶部颜色view
    [self setupTopColorViewData];
    
    //2.设置中间描述的view
    [self setupMiddleTextViewData];
    
    //3.底部正文/图片view
    [self setupContentPhotoViewData];
    
    //4.设置工具条view
    [self setupToolBarViewData];
}

/**
 * 设置顶部colorview的数据
 */
- (void)setupTopColorViewData {
    // 1.topColorView
    self.topColorView.frame = self.planFrame.topColorViewF;
    
    // 2.传递数据模型
    self.topColorView.planFrame = self.planFrame;
}

/**
 * 设置中间描述的view的数据
 */
- (void)setupMiddleTextViewData {
    // 1.topColorView
    self.middelTextView.frame = self.planFrame.middelTextViewF;
    
    // 2.传递数据模型
    self.middelTextView.planFrame = self.planFrame;
}

/**
 * 设置底部正文/图片view的数据
 */
- (void)setupContentPhotoViewData {
    // 1.contentPhotoView
    self.contentPhotoView.frame = self.planFrame.contentPhotoViewF;
    
    // 2.传递数据模型
    self.contentPhotoView.planFrame = self.planFrame;
}

/**
 * 设置底部正文/图片view的数据
 */
- (void)setupToolBarViewData {
    // 1.toolBarView
    self.toolBarView.frame = self.planFrame.toolbarViewF;
}

@end
