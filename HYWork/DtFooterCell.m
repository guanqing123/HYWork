//
//  DtFooterCell.m
//  HYWork
//
//  Created by information on 16/3/5.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtFooterCell.h"

@interface DtFooterCell()

@property (nonatomic,weak) UILabel *label;
@property (nonatomic,weak) UIImageView *imgView;

@end


@implementation DtFooterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DtFooter";
    DtFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DtFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"查看更多动态";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"more_32"];
        imgView.image = img;
        [self.contentView addSubview:imgView];
        _imgView = imgView;
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 60.0f, 10.0f, 100.0f, 20.0f)];
    
        //UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x, 12.5, 15, 15)];


        //return cell;
    }
    return self;
}

- (void)layoutSubviews {
    
    _label.frame = CGRectMake(self.frame.size.width / 2 - 60.f, 10.0f, 100.0f, 20.0f);
    
    CGFloat imgX = CGRectGetMaxX(_label.frame);
    
    _imgView.frame = CGRectMake(imgX, 12.5f, 15.0f, 15.0f);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
