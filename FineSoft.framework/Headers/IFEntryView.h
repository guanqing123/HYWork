//
//  IFEntryView.h
//  IFWidget
//
//  Created by 魏阳露 on 15/9/14.
//  Copyright (c) 2015年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFEntryNode.h"
#import <JavaScriptCore/JavaScriptCore.h>
@class IFReportDataAnalyserFactory;
@class IFReportDataAnalyser;

typedef NS_ENUM(NSInteger, IFEntryViewType) {
    IFEntryViewTypePage,
    IFEntryViewTypeWrite,
    IFEntryViewTypeWriteCache,
    IFEntryViewTypeBI
};

@protocol IFEntryViewDelegate

- (void) pushHyperLink:(UIViewController *)viewController withAnimate:(BOOL) animate;

@end

@interface IFEntryView : UIView {
    @protected
    NSDictionary* requestData;
    JSContext* jscontext;
    IFReportDataAnalyser* analyser;
}

@property (strong, nonatomic) NSDictionary* entry; //目录树上的报表json
@property (nonatomic, copy) NSString* sessionID;
@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) NSDictionary* parameters;
@property (nonatomic, copy) NSString* serverUrl;
@property (nonatomic, strong) id loading;
@property (nonatomic) BOOL needShareBtn;
@property (nonatomic) BOOL hasToolBarBtn;
@property (nonatomic, weak) id<IFEntryViewDelegate> entryViewDelegate;

- (id) initWithEntry:(IFEntryNode *) entryNode;
- (id)initWithPath:(NSString *)reportPath serverUrl:(NSString *)serverUrl viewType:(IFEntryViewType)viewType parameters:(NSDictionary *) params;

- (void)doLoad;
- (NSString *) entrylet;
- (NSString*)entryId;
- (void) addClickView2Load;
- (NSUInteger) addToolbarItems4ViewType:(NSMutableArray *) toolbarItems;
- (UIBarButtonItem*)createFlexible;
- (UIButton*)createToolBarItemButton:(UIImage*)image title:(NSString *)title action:(SEL)action;
- (BOOL) isParaShown;
- (id) form4JS;

-(void) closeParaViewController;

@end
