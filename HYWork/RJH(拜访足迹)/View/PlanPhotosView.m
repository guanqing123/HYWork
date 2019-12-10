//
//  PlanPhotosView.m
//  HYWork
//
//  Created by information on 2017/5/18.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#define PhotoMargin 5

#import "PlanPhotosView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation PlanPhotosView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //初始化9个子控制器
        for (int i = 0; i < 9; i++) {
            UIImageView *photoView = [[UIImageView alloc] init];
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
            [photoView addGestureRecognizer:recognizer];
            [self addSubview:photoView];
        }
    }
    return self;
}

- (void)photoTap:(UITapGestureRecognizer *)recognizer {
    int count = (int)self.photos.count;
    
    //1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // 一个Photo对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        
        Photo *photo = self.photos[i];
        mjphoto.url = [NSURL URLWithString:photo.url];
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = myphotos; // 设置所有的图片
    browser.currentPhotoIndex = recognizer.view.tag; //弹出相册时显示的第一张图片是？
    
    [browser show];
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    //设置子控件的size
    int maxColumns = (photos.count == 4) ? 2 : 3;
    CGFloat parentW = [UIScreen mainScreen].bounds.size.width - 30;
    CGFloat PhotoW = 0;
    CGFloat PhotoH = 0;
    if (photos.count == 1) { //一张图片大小为photoView的2/3
        PhotoW = parentW * 2 / 3;
        PhotoH = PhotoW * 2 /3;
    }else { //超过一张都显示photoView的1/3
        PhotoW = (parentW - 2 * PhotoMargin) / 3;
        PhotoH = PhotoW;
    }

    
    for (int i = 0; i<self.subviews.count; i++) {
        // 取出i位置对应的imageView
        UIImageView *photoView = self.subviews[i];
        
        // 判断这个imageView是否需要显示数据
        if (i < photos.count) {
            // 显示图片
            photoView.hidden = NO;
            
            // 显示小图片
            Photo *photo = photos[i];
            [photoView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            
            // 设置子控件的point
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat photoX = col * (PhotoW + PhotoMargin);
            CGFloat photoY = row * (PhotoH + PhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, PhotoW, PhotoH);
            
            // Aspect : 按照图片的原来宽高比进行缩
            // UIViewContentModeScaleAspectFit : 按照图片的原来宽高比进行缩放(一定要看到整张图片)
            // UIViewContentModeScaleAspectFill :  按照图片的原来宽高比进行缩放(只能图片最中间的内容)
            // UIViewContentModeScaleToFill : 直接拉伸图片至填充整个imageView
            
            if (photos.count == 1) {
                //photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.contentMode = UIViewContentModeScaleToFill;
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
        } else { // 隐藏imageView
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)photosViewSizeWithPhotosCount:(int)count {
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    CGFloat parentW = [UIScreen mainScreen].bounds.size.width - 30;
    CGFloat PhotoW = 0;
    CGFloat PhotoH = 0;
    if (count == 1) { //一张图片大小为photoView的2/3
        PhotoW = parentW * 2 / 3;
        PhotoH = PhotoW * 2 /3;
    }else { //超过一张都显示photoView的1/3
        PhotoW = (parentW - 2 * PhotoMargin) / 3;
        PhotoH = PhotoW;
    }
    
    // 总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * PhotoH + (rows - 1) * PhotoMargin;
    
    //总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    //宽度
    CGFloat photosW = cols * PhotoW + (cols - 1) * PhotoMargin;
    
    return CGSizeMake(photosW, photosH);
    /**
     一共60条数据 == count
     一页10条 == size
     总页数 == pages
     pages = (count + size - 1) / size
     */
}

@end
