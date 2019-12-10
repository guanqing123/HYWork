//
//  RJHPhotoCollectionReusableView.m
//  HYWork
//
//  Created by information on 2017/6/2.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RJHPhotoCollectionReusableView.h"
#import "CustomerLabel.h"
#import "DatePickerView.h"

@interface RJHPhotoCollectionReusableView()<UITextFieldDelegate,SelectPickerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) CustomerLabel  *cameraBtnLocLabel;
@property (nonatomic, weak) UISwitch *cameraBtnSwitch;
@property (nonatomic, weak) UIView   *cameraBtnBottomLineView;

@property (nonatomic, weak) CustomerLabel  *photoOrderLabel;
@property (nonatomic, weak) UISwitch *photoOrderSwitch;
@property (nonatomic, weak) UIView   *photoOrderBottomLineView;

@property (nonatomic, weak) CustomerLabel  *maxImagesCountLabel;
@property (nonatomic, weak) UITextField  *maxImagesCountField;
@property (nonatomic, weak) UIView       *maxImagesCountBottomLineView;

@property (nonatomic, weak) CustomerLabel  *rowCountLabel;
@property (nonatomic, weak) UITextField *rowCountField;
@property (nonatomic, weak) UIView   *rowCountBottomLineView;

@property (nonatomic, strong)  UIView *cover;
@end

@implementation RJHPhotoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CustomerLabel *cameraBtnLocLabel = [[CustomerLabel alloc] init];
        cameraBtnLocLabel.text = @"显示内部拍照按钮";
        cameraBtnLocLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        cameraBtnLocLabel.font = [UIFont systemFontOfSize:15];
        cameraBtnLocLabel.textAlignment = NSTextAlignmentRight;
        self.cameraBtnLocLabel = cameraBtnLocLabel;
        [self addSubview:cameraBtnLocLabel];
        
        UISwitch *cameraBtnSwitch = [[UISwitch alloc] init];
        [cameraBtnSwitch addTarget:self action:@selector(cameraBtnSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
        self.cameraBtnSwitch = cameraBtnSwitch;
        [self addSubview:cameraBtnSwitch];
        
        UIView *cameraBtnBottomLineView = [[UIView alloc] init];
        self.cameraBtnBottomLineView = cameraBtnBottomLineView;
        cameraBtnBottomLineView.backgroundColor = GQColor(238, 238, 238);
        [self addSubview:cameraBtnBottomLineView];
        
        CustomerLabel *photoOrderLabel = [[CustomerLabel alloc] init];
        photoOrderLabel.text = @"照片按修改时间升序排列";
        photoOrderLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        photoOrderLabel.font = [UIFont systemFontOfSize:15];
        photoOrderLabel.textAlignment = NSTextAlignmentRight;
        self.photoOrderLabel = photoOrderLabel;
        [self addSubview:photoOrderLabel];
        
        UISwitch *photoOrderSwitch = [[UISwitch alloc] init];
        [photoOrderSwitch addTarget:self action:@selector(photoOrderSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
        self.photoOrderSwitch = photoOrderSwitch;
        [self addSubview:photoOrderSwitch];
        
        UIView *photoOrderBottomLineView = [[UIView alloc] init];
        self.photoOrderBottomLineView = photoOrderBottomLineView;
        photoOrderBottomLineView.backgroundColor = GQColor(238, 238, 238);
        [self addSubview:photoOrderBottomLineView];
        
        CustomerLabel *maxImagesCountLabel = [[CustomerLabel alloc] init];
        maxImagesCountLabel.text = @"照片最大可选张数";
        maxImagesCountLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        maxImagesCountLabel.font = [UIFont systemFontOfSize:15];
        maxImagesCountLabel.textAlignment = NSTextAlignmentRight;
        self.maxImagesCountLabel = maxImagesCountLabel;
        [self addSubview:maxImagesCountLabel];
        
        UITextField *maxImagesCountField = [[UITextField alloc] init];
        maxImagesCountField.backgroundColor = GQColor(238, 238, 238);
        maxImagesCountField.font = [UIFont systemFontOfSize:15];
        maxImagesCountField.borderStyle = UITextBorderStyleRoundedRect;
        maxImagesCountField.textAlignment = NSTextAlignmentCenter;
        maxImagesCountField.userInteractionEnabled = NO;
        self.maxImagesCountField = maxImagesCountField;
        [self addSubview:maxImagesCountField];
        
        UIView *maxImagesCountBottomLineView = [[UIView alloc] init];
        self.maxImagesCountBottomLineView = maxImagesCountBottomLineView;
        maxImagesCountBottomLineView.backgroundColor = GQColor(238, 238, 238);
        [self addSubview:maxImagesCountBottomLineView];
        
        CustomerLabel *rowCountLabel = [[CustomerLabel alloc] init];
        rowCountLabel.text = @"每行展示照片张数";
        rowCountLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        rowCountLabel.font = [UIFont systemFontOfSize:15];
        rowCountLabel.textAlignment = NSTextAlignmentRight;
        self.rowCountLabel = rowCountLabel;
        [self addSubview:rowCountLabel];
        
        UITextField *rowCountField = [[UITextField alloc] init];
        rowCountField.backgroundColor = GQColor(238, 238, 238);
        rowCountField.font = [UIFont systemFontOfSize:15];
        rowCountField.borderStyle = UITextBorderStyleRoundedRect;
        rowCountField.textAlignment = NSTextAlignmentCenter;
        rowCountField.delegate = self;
        self.rowCountField = rowCountField;
        [self addSubview:rowCountField];
        
        UIView *rowCountBottomLineView = [[UIView alloc] init];
        self.rowCountBottomLineView = rowCountBottomLineView;
        rowCountBottomLineView.backgroundColor = GQColor(238, 238, 238);
        [self addSubview:rowCountBottomLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat parentW = self.frame.size.width;
    CGFloat marginXY = 5;
    CGFloat lineViewHeight = 1;
    CGFloat labelH = 31;
    
    CGFloat cameraBtnLocLabelX = 0;
    CGFloat cameraBtnLocLabelY = lineViewHeight;
    CGFloat cameraBtnLocLabelW = parentW * 0.6;
    CGFloat cameraBtnLocLabelH = labelH;
    _cameraBtnLocLabel.frame = CGRectMake(cameraBtnLocLabelX, cameraBtnLocLabelY, cameraBtnLocLabelW, cameraBtnLocLabelH);
    
    CGFloat cameraBtnSwitchX = CGRectGetMaxX(_cameraBtnLocLabel.frame);
    CGFloat cameraBtnSwitchY = cameraBtnLocLabelY;
    _cameraBtnSwitch.frame = (CGRect){{cameraBtnSwitchX , cameraBtnSwitchY},CGSizeZero};
    
    CGFloat cameraBtnBottomLineViewX = 0;
    CGFloat cameraBtnBottomLineViewY = CGRectGetMaxY(_cameraBtnSwitch.frame) + marginXY;
    CGFloat cameraBtnBottomLineViewW = parentW;
    CGFloat cameraBtnBottomLineViewH = lineViewHeight;
    _cameraBtnBottomLineView.frame = CGRectMake(cameraBtnBottomLineViewX, cameraBtnBottomLineViewY, cameraBtnBottomLineViewW, cameraBtnBottomLineViewH);
    
    CGFloat photoOrderLabelX = 0;
    CGFloat photoOrderLabelY = CGRectGetMaxY(_cameraBtnBottomLineView.frame) + marginXY;
    CGFloat photoOrderLabelW = parentW * 0.6;
    CGFloat photoOrderLabelH = labelH;
    _photoOrderLabel.frame = CGRectMake(photoOrderLabelX, photoOrderLabelY, photoOrderLabelW, photoOrderLabelH);
    
    CGFloat photoOrderSwitchX = CGRectGetMaxX(_photoOrderLabel.frame);
    CGFloat photoOrderSwitchY = photoOrderLabelY;
    _photoOrderSwitch.frame = (CGRect){{photoOrderSwitchX , photoOrderSwitchY},CGSizeZero};
    
    CGFloat photoOrderBottomLineViewX = 0;
    CGFloat photoOrderBottomLineViewY = CGRectGetMaxY(_photoOrderSwitch.frame) + marginXY;
    CGFloat photoOrderBottomLineViewW = parentW;
    CGFloat photoOrderBottomLineViewH = lineViewHeight;
    _photoOrderBottomLineView.frame = CGRectMake(photoOrderBottomLineViewX, photoOrderBottomLineViewY, photoOrderBottomLineViewW, photoOrderBottomLineViewH);
    
    CGFloat maxImagesCountLabelX = 0;
    CGFloat maxImagesCountLabelY = CGRectGetMaxY(_photoOrderBottomLineView.frame) + marginXY;
    CGFloat maxImagesCountLabelW = parentW * 0.6;
    CGFloat maxImagesCountLabelH = labelH;
    _maxImagesCountLabel.frame = CGRectMake(maxImagesCountLabelX, maxImagesCountLabelY, maxImagesCountLabelW, maxImagesCountLabelH);
    
    
    CGFloat maxImagesCountFieldX = CGRectGetMaxX(_maxImagesCountLabel.frame);
    CGFloat maxImagesCountFieldY = maxImagesCountLabelY;
    CGFloat maxImagesCountFieldW = 60;
    CGFloat maxImagesCountFieldH = labelH;
    _maxImagesCountField.frame = CGRectMake(maxImagesCountFieldX, maxImagesCountFieldY, maxImagesCountFieldW, maxImagesCountFieldH);
    
    CGFloat maxImagesCountBottomLineViewX = 0;
    CGFloat maxImagesCountBottomLineViewY = CGRectGetMaxY(_maxImagesCountField.frame) + marginXY;
    CGFloat maxImagesCountBottomLineViewW = parentW;
    CGFloat maxImagesCountBottomLineViewH = lineViewHeight;
    _maxImagesCountBottomLineView.frame = CGRectMake(maxImagesCountBottomLineViewX, maxImagesCountBottomLineViewY, maxImagesCountBottomLineViewW, maxImagesCountBottomLineViewH);
    
    CGFloat rowCountLabelX = 0;
    CGFloat rowCountLabelY = CGRectGetMaxY(_maxImagesCountBottomLineView.frame) + marginXY;
    CGFloat rowCountLabelW = parentW * 0.6;
    CGFloat rowCountLabelH = labelH;
    _rowCountLabel.frame = CGRectMake(rowCountLabelX, rowCountLabelY, rowCountLabelW, rowCountLabelH);
    
    CGFloat rowCountFieldX = CGRectGetMaxX(_rowCountLabel.frame);
    CGFloat rowCountFieldY = rowCountLabelY;
    CGFloat rowCountFieldW = 60;
    CGFloat rowCountFieldH = labelH;
    _rowCountField.frame = CGRectMake(rowCountFieldX, rowCountFieldY, rowCountFieldW, rowCountFieldH);
    
    CGFloat rowCountBottomLineViewX = 0;
    CGFloat rowCountBottomLineViewY = CGRectGetMaxY(_rowCountField.frame) + marginXY;
    CGFloat rowCountBottomLineViewW = parentW;
    CGFloat rowCountBottomLineViewH = lineViewHeight;
    _rowCountBottomLineView.frame = CGRectMake(rowCountBottomLineViewX, rowCountBottomLineViewY, rowCountBottomLineViewW, rowCountBottomLineViewH);
}

- (void)setMaxImagesCount:(int)maxImagesCount {
    _maxImagesCount = maxImagesCount;
    _maxImagesCountField.text = [NSString stringWithFormat:@"%d",maxImagesCount];
}

- (void)setColumnNumber:(int)columnNumber {
    _columnNumber = columnNumber;
    _rowCountField.text = [NSString stringWithFormat:@"%d",columnNumber];
}

- (void)setCameraBtnSwitchValue:(BOOL)cameraBtnSwitchValue {
    _cameraBtnSwitchValue = cameraBtnSwitchValue;
    [_cameraBtnSwitch setOn:cameraBtnSwitchValue animated:YES];
}

- (void)setPhotoOrderSwitchValue:(BOOL)photoOrderSwitchValue {
    _photoOrderSwitchValue = photoOrderSwitchValue;
    [_photoOrderSwitch setOn:photoOrderSwitchValue animated:YES];
}

/** 懒加载 */
- (NSMutableArray *)columnNumberArray {
    if (_columnNumberArray == nil) {
        _columnNumberArray = [NSMutableArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6", nil];
    }
    return _columnNumberArray;
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_selectPickerView == nil) {
        _selectPickerView = [[SelectPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 236.0f, SCREEN_WIDTH, 236.0f)];
        
        _selectPickerView.delegate = self;
        _selectPickerView.dataArry = self.columnNumberArray;
        
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.cover addSubview:_selectPickerView];
    }
    [self.superview.superview addSubview:self.cover];
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _cover;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.cover.subviews[0].frame, point)) {
        return NO;
    }
    return YES;
}

- (void)tapCover {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.cover removeFromSuperview];
    }];
}

#pragma mark - SelectPickerViewDelegate
- (void)didFinishSelectPicker:(SelectPickerView *)selectPickerView buttonType:(SelectPickerViewButtonType)buttonType {
    switch (buttonType) {
        case SelectPickerViewButtonTypeCancle:
            [self tapCover];
            break;
        case SelectPickerViewButtonTypeSure:{
            _columnNumber = [[self.columnNumberArray objectAtIndex:selectPickerView.index] intValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:_columnNumber forKey:@"columnNumber"];
            _rowCountField.text = [NSString stringWithFormat:@"%d",_columnNumber];
            if ([self.delegate respondsToSelector:@selector(photoCollectionReusableView:)]) {
                [self.delegate photoCollectionReusableView:self];
            }
            [self tapCover];
            break;
        }
        default:
            break;
    }
}

#pragma mark - cameraBtnSwitchValueChange
- (void)cameraBtnSwitchValueChange:(UISwitch *)cameraBtnSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:cameraBtnSwitch.isOn forKey:@"cameraBtnSwitchValue"];
    _cameraBtnSwitchValue = cameraBtnSwitch.isOn;
    if ([self.delegate respondsToSelector:@selector(photoCollectionReusableView:)]) {
        [self.delegate photoCollectionReusableView:self];
    }
}

#pragma mark - photoOrderSwitchValueChange
- (void)photoOrderSwitchValueChange:(UISwitch *)photoOrderSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:photoOrderSwitch.isOn forKey:@"photoOrderSwitchValue"];
    _photoOrderSwitchValue = photoOrderSwitch.isOn;
    if ([self.delegate respondsToSelector:@selector(photoCollectionReusableView:)]) {
        [self.delegate photoCollectionReusableView:self];
    }
}

@end
