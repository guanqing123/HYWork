//
//  KhhfSearchView.h
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKKhhfTableParam.h"

@interface KhhfSearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *districtField;

@property (weak, nonatomic) IBOutlet UITextField *flField;

@property (nonatomic, strong)  WKKhhfTableParam *tableParam;

@property (nonatomic, copy) dispatch_block_t searchBlock;

@property (nonatomic, copy) dispatch_block_t districtBlock;

@property (nonatomic, copy) dispatch_block_t classifyBlock;

+ (instancetype)searchView;

@end
