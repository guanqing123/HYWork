//
//  CygnTableCell.m
//  HYWork
//
//  Created by information on 16/2/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CygnTableCell.h"

@interface CygnTableCell()

@end

@implementation CygnTableCell

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;

    //0. 总列数
    int totalColumns = 4;
    
    //1. 功能尺寸
    CGFloat appW = SCREEN_WIDTH / 5 ;
    CGFloat appH = 60;
    
    //2.间隙 = (cell的宽度 - totalColumns * appW) / totalColumns + 1;
    CGFloat marginX = (SCREEN_WIDTH - totalColumns * appW) / (totalColumns + 1);
    CGFloat marginY = 10;
    
    for (int index = 0; index < _dataArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        
        // 计算行号和列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        
        CGFloat appX = marginX + col * (appW + marginX);
        CGFloat appY = marginY + row * (appH + marginY);
        button.frame = CGRectMake(appX, appY, appW, appH);
        

        Item *item = [_dataArray objectAtIndex:index];
        UIImage *image = [UIImage imageNamed:item.image];
        [button setImage:image forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        CGFloat imageW = image.size.width;
        CGFloat edgX = (appW - imageW) * 0.5;
        CGFloat edgY = appH - image.size.height;
        //设置按钮图片的内边距
        button.imageEdgeInsets = UIEdgeInsetsMake(0, edgX, edgY, edgX);
        [button setTitle:item.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -imageW, 0, 0);
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
    }
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    //0. 总列数
//    int totalColumns = 4;
//    
//    //1. 功能尺寸
//    CGFloat appW = self.frame.size.width / 5 ;
//    CGFloat appH = 60;
//    
//    //2.间隙 = (cell的宽度 - totalColumns * appW) / totalColumns + 1;
//    CGFloat marginX = (self.frame.size.width - totalColumns * appW) / (totalColumns + 1);
//    CGFloat marginY = 10;
//    
//    for (int index = 0; index < _dataArray.count; index++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        // 计算行号和列号
//        int row = index / totalColumns;
//        int col = index % totalColumns;
//        
//        CGFloat appX = marginX + col * (appW + marginX);
//        CGFloat appY = marginY + row * (appH + marginY);
//        button.frame = CGRectMake(appX, appY, appW, appH);
//        UIImage *image = nil;
//        if (index != _dataArray.count - 1) {
//            image = [UIImage imageNamed:@"库存查询"];
//            [button setImage:image forState:UIControlStateNormal];
//            //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//            CGFloat imageW = image.size.width;
//            CGFloat edgX = (appW - imageW) * 0.5;
//            CGFloat edgY = appH - image.size.height;
//            //设置按钮图片的内边距
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, edgX, edgY, edgX);
//            [button setTitle:[_dataArray objectAtIndex:index] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            [button setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
//            button.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -imageW, 0, 0);
//        }else{
//            image = [UIImage imageNamed:[_dataArray objectAtIndex:index]];
//            [button setImage:image forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(addButtonItem) forControlEvents:UIControlEventTouchUpInside];
//        }
//        [self.contentView addSubview:button];
//    }
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    CygnTableCell *cell = [[CygnTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick:(UIButton *)btn {
    Item *item = [_dataArray objectAtIndex:btn.tag];
    if ([self.delegate respondsToSelector:@selector(cygnTableCell:btnDidClickWithItem:)]) {
        [self.delegate cygnTableCell:self btnDidClickWithItem:item];
    }
}

@end
