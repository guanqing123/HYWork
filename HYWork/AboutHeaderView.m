//
//  AboutHeaderView.m
//  HYWork
//
//  Created by information on 16/6/21.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "AboutHeaderView.h"

@interface AboutHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *version;
@end

@implementation AboutHeaderView

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:nil options:nil] lastObject];
}

/**
 *  当一个对象从xib中创建初始化完毕的时候就会调用一次
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [dict objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"版本号%@",version];
}

@end
