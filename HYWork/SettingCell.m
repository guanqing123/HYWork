//
//  SettingCell.m
//  HYWork
//
//  Created by information on 16/4/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"

@interface SettingCell()
/**
 *  箭头
 */
@property (nonatomic, strong)  UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong)  UISwitch *switchView;

@end

@implementation SettingCell

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowcell"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    [defaults synchronize];
    
    if ([self.item.title isEqualToString:PS]) {
        if ([self.delegate respondsToSelector:@selector(tableViewCellRestartApp:)]) {
            [self.delegate tableViewCellRestartApp:self];
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"setting";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setItem:(SettingItem *)item {
    _item = item;
    
    //1.设置数据
    [self setupData];
    
    //2.设置右边的内容
    [self setupRightContent];
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent {
    if ([self.item isKindOfClass:[SettingArrowItem class]]) { // 箭头
        self.accessoryView = self.arrowView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([self.item isKindOfClass:[SettingSwitchItem class]]) { //开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
    }else { // 空
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

/**
 *  设置数据
 */
- (void)setupData {
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.text = self.item.subtitle;
}

@end
