//
//  BXViewCell.m
//  HYWork
//
//  Created by information on 16/5/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BXViewCell.h"
#import "BXItem.h"

@implementation BXViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"BXVIEWCELL";
    BXViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BXViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        label.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)setBxItem:(BXItem *)bxItem {
    _bxItem = bxItem;
    
    self.textLabel.text = bxItem.requestname;
    
    if ([bxItem.newflag intValue]) {
        [self.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    }else{
        [self.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    self.detailTextLabel.text = bxItem.receivetime;
    
}

@end
