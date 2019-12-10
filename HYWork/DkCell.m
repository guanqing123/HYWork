//
//  DkCell.m
//  HYWork
//
//  Created by information on 16/3/22.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DkCell.h"
#import "PubLabel.h"

#define DkCellFont [UIFont systemFontOfSize:13]

@implementation DkCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DkCell";
    DkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        PubLabel *khdmLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:khdmLabel];
        
        PubLabel *khmcLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:khmcLabel];
        
        PubLabel *dkdhLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:dkdhLabel];
        
        PubLabel *dkddLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:dkddLabel];
        
        PubLabel *hzddLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:hzddLabel];
        
        PubLabel *zjrqLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:zjrqLabel];
        
        PubLabel *jeLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:jeLabel];
        
        PubLabel *ztLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:ztLabel];
        
        PubLabel *syhbLabel = [PubLabel labelWithFont:DkCellFont];
        [self addSubview:syhbLabel];
    }
    return self;
}

@end
