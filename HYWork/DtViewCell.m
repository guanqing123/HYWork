//
//  DtViewCell.m
//  HYWork
//
//  Created by information on 16/3/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

#define text_font [UIFont systemFontOfSize:15]
#define time_font [UIFont systemFontOfSize:12]

@interface DtViewCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *readTimeLabel;
@property (nonatomic, weak) UIView *lineView;
@end


@implementation DtViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"dtCell";
    DtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DtViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imgView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = text_font;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = time_font;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *readTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:readTimeLabel];
        self.readTimeLabel = readTimeLabel;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [self.contentView addSubview:view];
        self.lineView = view;
        
    }
    return self;
}

- (void)setDtCellModel:(DtCellModel *)dtCellModel {
    _dtCellModel = dtCellModel;
    
    if ([dtCellModel.imgUrl isKindOfClass:[NSNull class]]) {
        dtCellModel.imgUrl = @"";
    }
    if ([dtCellModel.title isKindOfClass:[NSNull class]]) {
        dtCellModel.title = @"";
    }
    if ([dtCellModel.time isKindOfClass:[NSNull class]]) {
        dtCellModel.time = @"";
    }
    
    NSURL *url = [NSURL URLWithString:dtCellModel.imgUrl];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"加载"]];
    
    self.titleLabel.text = dtCellModel.title;
    
    self.timeLabel.text = dtCellModel.time;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingX = 10;
    CGFloat paddingY = 5;
    
    CGFloat imageW = 90;
    CGFloat imageH = 70;

    _imgView.frame = CGRectMake(paddingX, paddingY, imageW, imageH);
    
    CGFloat titleX = CGRectGetMaxX(self.imgView.frame) + paddingY;
    CGFloat titleY = paddingY;
    CGFloat titleW = self.frame.size.width - paddingY - titleX;
    CGSize t = [self.titleLabel.text sizeWithFont:text_font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize s = [self.titleLabel.text sizeWithFont:text_font maxSize:CGSizeMake(titleW, t.height * 2)];
    CGFloat titleH = s.height;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat timeX = titleX;
    CGSize  size  = [self.timeLabel.text sizeWithFont:time_font maxSize:CGSizeMake(titleW, imageH)];
    CGFloat timeW = size.width;
    CGFloat timeH = size.height;
    CGFloat timeY = self.frame.size.height - paddingY - timeH;
    _timeLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    _lineView.frame = CGRectMake(0, 79, self.frame.size.width, 1);
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
