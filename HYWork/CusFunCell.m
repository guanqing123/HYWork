//
//  CusFunCell.m
//  HYWork
//
//  Created by information on 16/4/19.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CusFunCell.h"

@interface CusFunCell()

@property (nonatomic, weak) UIImageView  *imgView;

@property (nonatomic, weak) UILabel  *label;

@property (nonatomic, weak) UIImageView  *choosedImgView;

@end

@implementation CusFunCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CusFunCell";
    CusFunCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CusFunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
        _imgView = imgView;
        [self.contentView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 20)];
        _label = label;
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        
        UIImageView *choosedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 10, 20, 20)];
        _choosedImgView = choosedImgView;
        [self.contentView addSubview:choosedImgView];
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        subView.backgroundColor = GQColor(238, 238, 238);
        [self.contentView addSubview:subView];
    }
    return self;
}

- (void)setItem:(Item *)item {
    _item = item;
    
    self.imgView.image = [UIImage imageNamed:item.image];
    
    self.label.text = item.title;
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    if (choose) {
        _choosedImgView.image = [UIImage imageNamed:@"home_func_unselect"];
    }else {
        _choosedImgView.image = [UIImage imageNamed:@"home_func_select"];
    }
}

@end
