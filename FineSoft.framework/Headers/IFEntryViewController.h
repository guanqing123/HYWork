//
//  IFEntryViewController.h
//  IFWidget
//
//  Created by WeiYanglu on 14-8-13.
//  Copyright (c) 2014年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "IFEntryNode.h"
#import "IFEntryView.h"

@class IFReportDataAnalyserFactory;
@class IFReportDataAnalyser;
@class IFWidget;
@class IFFrameShareViewController;
@class IFParaViewController;

@interface IFEntryViewController : UIViewController {
    BOOL boolOldReport;
    NSMutableDictionary* requestData;
    NSString* entrylet;
    NSMutableArray* orientationListener;
    IFReportDataAnalyser* analyser;
    UIButton* flipBtn;
    JSContext* jscontext;
    BOOL paging;//因为表单里的报表块也可以翻页，所以这个属性从report挪到父类
    //去掉popView，这个之前是处理报表块超链报表，横屏，报表布局不对。
    //去掉后没有问题，先注释掉，跑完冒烟再删除。
    //IFEntryViewController* popView;
    BOOL reloading;//是否是下拉刷新
    BOOL coverflowNeedUpdate;//重新参数面板查询和下拉刷新后update翻页页面缩略图
    BOOL needShowPara;
    NSMutableDictionary* listeners;//填报成功等事件
    NSDictionary * lastReportInfo;
}

#define EVENTNAME_AFTERLOAD @"afterload"
#define TAG_BACKGROUND 9999

@property (nonatomic, weak) id screenCaptureDelegate;
@property (copy, nonatomic) NSString* name; //通过报表路径加载，比如超链里的网络报表
@property (strong, nonatomic) NSDictionary* entry; //目录树上的报表json
@property (strong, nonatomic) NSDictionary* parameters;
@property (nonatomic, copy) NSString* serverUrl;
@property (nonatomic, copy) NSString* sessionID;

@property (nonatomic) CGFloat fitScale4Mobile;    //pc端设置的报表可能很大，移动端按照需要把尺寸降低，这是缩放比例

@property (nonatomic, strong) id loading;
@property (nonatomic)BOOL allLoadSuccess;
@property (nonatomic)BOOL inSilence;   //静默模式，比如一键下载，全部提交时

- (void)updateFlipBtnTitle:(NSString*)title;

- (void)enableFavoriteBtn;

- (void)hideFavoriteBtn;

- (void)hideFilterBtn;

- (void)disableFlipBtn;

- (void)enableFlipBtn;

- (void)didFlipBtnClick:(id)sender;

- (void)showErrorView:(NSString*)message exception:(NSString*)exception;

- (void)createToolBar;

/**
 *  添加转屏事件的监听者
 *
 *  @param listener 监听者
 */
- (void)addOrientationListener:(id)listener;
/**
 *  移除转屏事件的监听者
 *
 *  @param listener 监听者
 */
- (void)removeOrientationListener:(id)listener;

/**
*  初始化转屏处理
*/
- (void)initOrientation;

- (void)removeAllOrientationListeners;

/**
 *  根据目录树上的节点信息创建报表
 *
 *  @param entryInfo 节点信息
 *
 *  @return 报表控制器
 */
- (id) initWithEntry:(IFEntryNode *) entryNode;

/**
 *  根据文件路径初始化，使用当前连接的服务器地址
 *  @param reportPath 报表路径
 */
- (id)initWithPath:(NSString*)reportPath;

/**
 *  根据文件路径和服务器地址初始化
 *  @param reportPath 报表路径
 *  @param serverUrl 服务器地址
 */
- (id)initWithPath:(NSString*)reportPath serverUrl:(NSString*)serverUrl;

/**
 *  根据文件路径和服务器地址初始化
 *  @param reportPath 报表路径
 *  @param serverUrl 服务器地址
 *  @param viewType 预览类型IFEntryViewType:分页/填报
 */
- (id)initWithPath:(NSString *)reportPath serverUrl:(NSString *)serverUrl viewType:(IFEntryViewType) viewType;

- (id)initWithPath:(NSString *)reportPath serverUrl:(NSString *)serverUrl viewType:(IFEntryViewType)viewType parameters:(NSDictionary *) params;

//预览类型
- (NSString *) viewType;

- (void)submitParameter4DynamicLink:(NSDictionary*)data;

- (void)landscape;

- (void)landscape4Init;

- (void)portrait;

- (BOOL)isPortrait;

- (CGRect)backgroundFrame;

- (void)popViewController;

- (NSString*)entryId;

-(BOOL)allLoadDataSuccess;

- (IFFrameShareViewController *)createShareViewController:(UIImage *)screenShot;

- (UIImage*)createCurrentImage;

- (UIImage*)createGaussianBlurImage;

- (void)doLoad;

- (BOOL) isParaShown;

/**
 *  截屏
 *
 *  @return 截屏图片
 */
- (UIImage*)resultScreenCapture;

- (void)doneLoadingViewData:(void (^)())success;

- (void)dealWithFirstReqData:(NSDictionary*)reqData success:(void (^)(id dictOrAttr)) success error:(void (^)(NSString *message, NSString *exception))error failure:(void (^)(NSString *message)) failure;

- (void)displayParaViewControllerInSilent:(BOOL)isSilent;

- (IFParaViewController *)createParaViewController;

- (void)loadContentFromParaData:(BOOL)needHide success:(void (^)(id dictOrAttr))success error:(void (^)(NSString *message, NSString *exception))error failure:(void (^)(NSString *message))failure;

- (void)completion:(void (^)(id dictOrAttr))success error:(void (^)(NSString *message, NSString *exception))error failure:(void (^)(NSString *message))failure;

- (void)addClickView2Load;

- (void) registerListener:(NSString *)name action:(void (^)(id))action;

- (void) fireListener:(NSString *)name;

- (JSContext *)getJSContext;

/**
 *  计算单元格的
 */
- (void (^)(id))mainProcedureBlock;


- (void)loadContent:(void (^)(id dictOrArr))success failure:(void (^)(NSString *message))failure error:(void (^)(NSString *message, NSString *exception))error;

/**
 *   处理报表web属性
 *   @param reportAttr 报表web属性配置信息
 */
- (void)dealWithReportAttr: (NSDictionary *)reportAttr;

- (void) showReport:(id) dictOrAttr;

- (void)loadDataWithParameters:(NSString *)entryId;

- (void) loadDataWithName:(NSString *) name;

- (void) touchReportOnServer:(void (^)(NSString *sessionID, id dictOrAttr, NSUInteger pageCount))success error:(void (^)(NSString *message, NSString *exception))error failure:(void (^)(NSString *message))failure;

- (void) openViewController:(UIViewController*)viewController withPush:(BOOL) isPush withAnimate:(BOOL) animate;

//js里的widget.form
- (id) form4JS;

- (void) parameterCommit;

- (void)disableFavoriteBtn;

- (void)fireBodyListener:(NSString *)listener;

-(void) refreshController;

-(void) closeParaViewController;

-(NSDictionary *) saveLastReportState;

-(void) pushToEntry:(NSMutableDictionary *) lastInfo;

@end
