//
//  OperatorSearchTableCell.m
//  HYWork
//
//  Created by information on 2017/6/9.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "OperatorSearchTableCell.h"
#import "CustomerLabel.h"

@interface OperatorSearchTableCell()
@property (nonatomic, weak) CustomerLabel  *ygxmLabel;
@property (nonatomic, weak) UIButton  *markBtn;
@property (nonatomic, weak) UIView  *lineView;
@end

@implementation OperatorSearchTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"OperatorSearchTableCell";
    OperatorSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OperatorSearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CustomerLabel *ygxmLabel = [[CustomerLabel alloc] init];
        ygxmLabel.textInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        _ygxmLabel = ygxmLabel;
        [self.contentView addSubview:ygxmLabel];
        
        UIButton *markBtn = [[UIButton alloc] init];
        markBtn.adjustsImageWhenHighlighted = NO;
        markBtn.contentMode = UIViewContentModeCenter;
        [markBtn addTarget:self action:@selector(markBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _markBtn = markBtn;
        [self.contentView addSubview:markBtn];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = GQColor(238, 238, 238);
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    if (self.isChoosed) {
        [self.markBtn setImage:[UIImage imageNamed:@"plan_select"] forState:UIControlStateNormal];
    }else{
        [self.markBtn setImage:[UIImage imageNamed:@"plan_unselect"] forState:UIControlStateNormal];
    }
}

- (void)setZjxs:(ZJXS *)zjxs {
    _zjxs = zjxs;
    
    self.ygxmLabel.text = zjxs.ygxm;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    CGFloat marginX = 25;
    
    CGFloat markBtnW = 25;
    CGFloat markBtnH = parentH;
    CGFloat markBtnX = parentW - markBtnW - marginX;
    CGFloat markBtnY = 0;
    self.markBtn.frame = CGRectMake(markBtnX, markBtnY, markBtnW, markBtnH);
    
    CGFloat ygxmLabelX = 0;
    CGFloat ygxmLabelY = 0;
    CGFloat ygxmLabelW = markBtnX;
    CGFloat ygxmLabelH = parentH;
    self.ygxmLabel.frame = CGRectMake(ygxmLabelX, ygxmLabelY, ygxmLabelW, ygxmLabelH);
    
    CGFloat lineViewX = 0;
    CGFloat lineViewY = parentH - 1;
    CGFloat lineViewW = parentW;
    CGFloat lineViewH = 1;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

- (void)markBtnClick {
    if ([self.delegate respondsToSelector:@selector(operatorSearchTableCellDidClickMarkBtn:)]) {
        [self.delegate operatorSearchTableCellDidClickMarkBtn:self];
    }
}

@end
