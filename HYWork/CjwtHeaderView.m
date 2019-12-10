//
//  CjwtHeaderView.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CjwtHeaderView.h"

@interface CjwtHeaderView()
@property (nonatomic, weak) UIButton  *nameView;
@end

@implementation CjwtHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cjwtHeaderView";
    CjwtHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [[CjwtHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 1.添加按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        // 背景图片
        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        // 设置按钮内部的左边箭头图片
        [nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置按钮的内容左对齐
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮的内边距
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置按钮内部的imageView的内容模式为居中
        nameView.imageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不要裁剪
        nameView.imageView.clipsToBounds = NO;
        
        nameView.titleLabel.numberOfLines = 0;
        nameView.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置按钮的frame
    self.nameView.frame = self.bounds;
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
    // 设置标题
    [self.nameView setTitle:model.question forState:UIControlStateNormal];
    
    //gq
    if (self.model.isOpened) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)nameViewClick {
    // 修改组模型的标记 (状态取反)
    self.model.isOpened = !self.model.isOpened;
    
    // 刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        [self.delegate headerViewDidClickedNameView:self];
    }
}

/**
 *  当一个控件被添加到父控件中就会调用
 */
//- (void)didMoveToSuperview
//{
//    if (self.model.isOpened) {
//        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    } else {
//        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
//    }
//}

@end
