//
//  RjhSignInTableCell.m
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhSignInTableCell.h"
#import "CustomerLabel.h"

@interface RjhSignInTableCell()
//第一个cell
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) CustomerLabel  *nameLabel;
@property (nonatomic, weak) CustomerLabel  *descLabel;
@property (nonatomic, weak) UIView  *lineView;
//第二个cell
@property (nonatomic, weak) UIImageView *xqView;
@property (nonatomic, weak) CustomerLabel *xqLabel;
@property (nonatomic, weak) UIImageView *sjView;
@property (nonatomic, weak) CustomerLabel *sjLabel;
//第三个cell
@property (nonatomic, weak) UIImageView  *locView;
@property (nonatomic, weak) UILabel *dqwzLabel;
@property (nonatomic, weak) CustomerLabel *detailLabel;
@property (nonatomic, weak) UIButton *refreshBtn;
@property (nonatomic, weak) UIView  *locLineView;
//第四个cell
@property (nonatomic, weak) UIButton  *signInBtn;
@end

@implementation RjhSignInTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    RjhSignInTableCell *cell = [[RjhSignInTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil indexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _indexPath = indexPath;
        switch (indexPath.row) {
            case 0:{
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.image = [UIImage imageNamed:@"sign"];
                self.imgView = imgView;
                [self.contentView addSubview:imgView];
                
                CustomerLabel *nameLabel = [[CustomerLabel alloc] init];
                nameLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                nameLabel.font = [UIFont systemFontOfSize:20];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                self.nameLabel = nameLabel;
                [self.contentView addSubview:nameLabel];
                
                CustomerLabel *descLabel = [[CustomerLabel alloc] init];
                descLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                descLabel.textAlignment = NSTextAlignmentLeft;
                descLabel.textColor = GQColor(150.0f, 150.0f, 150.0f);
                self.descLabel = descLabel;
                [self.contentView addSubview:descLabel];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
                self.lineView = lineView;
                [self.contentView addSubview:lineView];
                break;
            }
            case 1:{
                UIImageView *xqView = [[UIImageView alloc] init];
                xqView.image = [UIImage imageNamed:@"rili"];
                self.xqView = xqView;
                [self.contentView addSubview:xqView];
                
                CustomerLabel *xqLabel = [[CustomerLabel alloc] init];
                xqLabel.font = [UIFont systemFontOfSize:14];
                xqLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                xqLabel.textColor = GQColor(150, 150, 150);
                self.xqLabel = xqLabel;
                [self.contentView addSubview:xqLabel];
                
                UIImageView *sjView = [[UIImageView alloc] init];
                sjView.image = [UIImage imageNamed:@"shijian"];
                self.sjView = sjView;
                [self.contentView addSubview:sjView];
                
                CustomerLabel *sjLabel = [[CustomerLabel alloc] init];
                sjLabel.textAlignment = NSTextAlignmentLeft;
                sjLabel.font = [UIFont systemFontOfSize:14];
                sjLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                sjLabel.textColor = GQColor(150, 150, 150);
                self.sjLabel = sjLabel;
                [self.contentView addSubview:sjLabel];
                break;
            }
            case 2:{
                UIImageView *locView = [[UIImageView alloc] init];
                locView.image = [UIImage imageNamed:@"dinweidizhi"];
                self.locView = locView;
                [self.contentView addSubview:locView];
                
                UILabel *dqwzLabel = [[UILabel alloc] init];
                dqwzLabel.text = @"当前位置";
                dqwzLabel.textColor = GQColor(150, 150, 150);
                dqwzLabel.font = [UIFont systemFontOfSize:14];
                self.dqwzLabel = dqwzLabel;
                [self.contentView addSubview:dqwzLabel];
                
                CustomerLabel *detailLabel = [[CustomerLabel alloc] init];
                detailLabel.font = [UIFont systemFontOfSize:14];
                detailLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
                self.detailLabel = detailLabel;
                detailLabel.numberOfLines = 0;
                [self.contentView addSubview:detailLabel];
                
                UIButton *refreshBtn = [[UIButton alloc] init];
                [refreshBtn addTarget:self action:@selector(refreshLoc) forControlEvents:UIControlEventTouchUpInside];
                self.refreshBtn = refreshBtn;
                [self.contentView addSubview:refreshBtn];
                
                UIView *locLineView = [[UIView alloc] init];
                locLineView.backgroundColor = GQColor(238, 238, 238);
                self.locLineView = locLineView;
                [self.contentView addSubview:locLineView];
                break;
            }
            case 3:{
                UIButton *signInBtn = [[UIButton alloc] init];
                [signInBtn setImage:[UIImage imageNamed:@"signIn"] forState:UIControlStateNormal];
                [signInBtn addTarget:self action:@selector(signInClick) forControlEvents:UIControlEventTouchUpInside];
                self.signInBtn = signInBtn;
                [self.contentView addSubview:signInBtn];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_indexPath.row == 2) {
        CGContextRef  context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.1);
        CGFloat rectX = 15;
        CGFloat rectY = 0;
        CGFloat rectW = self.frame.size.width - 2 * rectX;
        CGFloat rectH = self.frame.size.height;
        CGRect  rectangle = CGRectMake(rectX,rectY,rectW,rectH);
        CGContextAddRect(context, rectangle);
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat parentW = self.frame.size.width;
    CGFloat parentH = self.frame.size.height;
    switch (_indexPath.row) {
        case 0:{
            CGFloat paddingX = 15;
            CGFloat paddingY = 10;
            
            CGFloat imgViewX = paddingX;
            CGFloat imgViewY = paddingY;
            CGFloat imgViewW = 60;
            CGFloat imgViewH = 60;
            self.imgView.frame = CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
            
            CGFloat nameLabelX = CGRectGetMaxX(_imgView.frame);
            CGFloat nameLabelY = paddingY;
            CGFloat nameLabelW = parentW - nameLabelX - paddingX;
            CGFloat nameLabelH = 30;
            self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
            
            CGFloat descLabelX = nameLabelX;
            CGFloat descLabelY = CGRectGetMaxY(_nameLabel.frame);
            CGFloat descLabelW = parentW - descLabelX - paddingX;
            CGFloat descLabelH = 30;
            self.descLabel.frame = CGRectMake(descLabelX, descLabelY, descLabelW, descLabelH);
            
            CGFloat lineViewX = paddingX;
            CGFloat lineViewY = parentH - 1;
            CGFloat lineViewW = parentW - 2 * paddingX;
            CGFloat lineViewH = 1;
            self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
            break;
        }
        case 1:{
            CGFloat paddingX = 15;
            CGFloat paddingY = 20;
            
            CGFloat xqViewX = paddingX;
            CGFloat xqViewY = paddingY;
            CGFloat xqViewW = paddingY;
            CGFloat xqViewH = xqViewW;
            self.xqView.frame = CGRectMake(xqViewX, xqViewY, xqViewW, xqViewH);
            
            CGFloat xqLabelX = CGRectGetMaxX(_xqView.frame);
            CGFloat xqLabelY = paddingY;
            CGFloat xqLabelW = parentW/2 - xqLabelX;
            CGFloat xqLabelH = xqViewH;
            self.xqLabel.frame = CGRectMake(xqLabelX, xqLabelY, xqLabelW, xqLabelH);
            
            CGFloat sjViewX = CGRectGetMaxX(_xqLabel.frame) + paddingX;
            CGFloat sjViewY = paddingY;
            CGFloat sjViewW = paddingY;
            CGFloat sjViewH = sjViewW;
            self.sjView.frame = CGRectMake(sjViewX, sjViewY, sjViewW, sjViewH);
            
            CGFloat sjLabelX = CGRectGetMaxX(_sjView.frame);
            CGFloat sjLabelY = paddingY;
            CGFloat sjLabelW = parentW - sjLabelX;
            CGFloat sjLabelH = paddingY;
            self.sjLabel.frame = CGRectMake(sjLabelX, sjLabelY, sjLabelW, sjLabelH);
            break;
        }
        case 2:{
            CGFloat paddingX = 15;
            CGFloat paddingY = 10;
            
            CGFloat locViewX = paddingX;
            CGFloat locViewY = paddingY / 2;
            CGFloat locViewW = 25;
            CGFloat locViewH = 30;
            self.locView.frame = CGRectMake(locViewX, locViewY, locViewW, locViewH);
            
            CGFloat dqwzLabelX = CGRectGetMaxX(_locView.frame);
            CGFloat dqwzLabelY = paddingY;
            CGFloat dqwzLabelW = 60;
            CGFloat dqwzLabelH = 20;
            self.dqwzLabel.frame = CGRectMake(dqwzLabelX, dqwzLabelY, dqwzLabelW, dqwzLabelH);
            
            CGFloat detailLabelX = CGRectGetMaxX(_dqwzLabel.frame);
            CGFloat detailLabelY = 0;
            CGFloat detailLabelW = parentW - detailLabelX - 55;
            CGFloat detailLabelH = 40;
            self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
            
            CGFloat refreshBtnX = CGRectGetMaxX(_detailLabel.frame);
            CGFloat refreshBtnY = 0;
            CGFloat refreshBtnW = 40;
            CGFloat refreshBtnH = 40;
            self.refreshBtn.frame = CGRectMake(refreshBtnX, refreshBtnY, refreshBtnW, refreshBtnH);
            
            CGFloat locLineViewX = paddingX;
            CGFloat locLineViewY = 40;
            CGFloat locLineViewW = parentW - 2 * locLineViewX;
            CGFloat locLineViewH = 1;
            self.locLineView.frame = CGRectMake(locLineViewX, locLineViewY, locLineViewW, locLineViewH);
            
            CGFloat mapViewX = paddingX;
            CGFloat mapViewY = CGRectGetMaxY(self.locLineView.frame);
            CGFloat mapViewW = parentW - 2 * mapViewX;
            CGFloat mapViewH = parentH - mapViewY;
            self.mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
            break;
        }
        case 3:{
            CGFloat signInBtnX = parentW / 2 - 50;
            CGFloat signInBtnY = parentH / 2 - 50;
            CGFloat signInBtnW = 100;
            CGFloat signInBtnH = 100;
            self.signInBtn.frame = CGRectMake(signInBtnX, signInBtnY, signInBtnW, signInBtnH);
            break;
        }
        default:
            break;
    }
}

- (void)setSignIn:(RjhSignIn *)signIn {
    _signIn = signIn;
    switch (_indexPath.row) {
        case 0:{
            self.nameLabel.text = self.signIn.ygxm;
            self.descLabel.text = [NSString stringWithFormat:@"今日您已签到 %d 次",self.signIn.count];
            break;
        }
        case 1:{
            self.xqLabel.text = self.signIn.date;
            self.sjLabel.text = self.signIn.time;
            break;
        }
        case 2:{
            [self.refreshBtn setImage:[UIImage imageNamed:self.signIn.imageName] forState:UIControlStateNormal];
            self.detailLabel.text = self.signIn.signin;
            break;
        }
        default:
            break;
    }
}

- (void)refreshLoc {
    if (self.signIn.canClick && [self.delegate respondsToSelector:@selector(signInTableCellRefreshLocation:)]) {
        [self.delegate signInTableCellRefreshLocation:self];
    }
}

- (void)signInClick {
    if ([self.delegate respondsToSelector:@selector(signInTableCell:)]) {
        [self.delegate signInTableCell:self];
    }
}

@end
