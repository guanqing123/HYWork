//
//  IFOEMUtils.h
//  IFWidget
//
//  Created by 魏阳露 on 15/3/18.
//  Copyright (c) 2015年 FineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
  开放给客户的OEM定制工具
*/
@interface IFOEMUtils : NSObject

/*
  增加服务器，如果同名服务器存在不会添加
  @param serverName 服务器名称
  @param serverURL 服务器地址
  @param username 用户名
  @param password 密码
  @param userEditable 默认用户是否可以编辑 默认为YES
*/
+ (void) addServerWithName:(NSString *)serverName andURL:(NSString *)serverURL addUsername:(NSString *)username addPassword:(NSString *)password userEditable:(BOOL)userEditable;

/*
  增加服务器，如果同名服务器存在不会添加
  @param serverName 服务器名称
  @param serverURL 服务器地址
  @param username 用户名
  @param password 密码
*/
+ (void) addServerWithName:(NSString *) serverName andURL:(NSString *) serverURL addUsername:(NSString *) username addPassword:(NSString *) password;

/*
  根据服务器名称和服务器地址删除服务器
  @param serverName 服务器名称
  @param serverURL 服务器地址
*/
+ (void) removeServer:(NSString *) serverName serverURL:(NSString *) serverURL;

/*
  删除FR内置的Demo服务器
*/
+ (void) removeDemoServer;

/*
  去掉关于页面
*/
+ (void) removeAbout;

/*
  设置App的版本，会显示在关于界面
*/
+ (void) setAppVersion:(NSString *) version;

/*
  设置版权信息
*/
+ (void) setCopyright:(NSString *) copyRight;

/*
  设置关于界面里展示的图片名字
*/
+ (void) setAppIconName:(NSString *) iconName;

/**
 *  设置处理通知消息的方法
 */
+ (void) setMessageHandler:(void (^) (NSString *message, BOOL isSuccess)) handler;

/**
 *  自定义app设置按钮
 */
+ (void) setAppSettingBarButtonItem:(UIBarButtonItem *) settingItem;

/**
    保持Pad上一级目录树菜单始终显示在左侧
 */
+ (void) keepFolderLeftOnPad;

/**
    把首页放置到一级目录树上显示
    @param image:首页的缩略图
 */
+ (void) putHomePageOnFolderWithImage:(UIImage *) image;

/**
 *  设置是否需要报表缩略图
 */
+ (void) setNeedReportScreenshot:(BOOL) needReportScreenshot;

//设置信鸽推送中使用到的appId
+ (void) setXinGeAppId:(uint32_t) appId;

//设置信鸽推送中使用到的appKey
+ (void) setXinGeAppKey:(NSString *) appKey;

//一级目录上自定义快捷方式
+ (void) addNodeOnFolder:(NSString *) nodeName withImage:(UIImage *) image andUrl:(NSString *) url serverURL:(NSString *) serverUrl;

//是否支持收藏
+ (void) setSupportFavorite:(BOOL) isSupportFavorite;

+ (void) setWeiXinAppID:(NSString *) appId;

+ (void)setNeedCheckCprUpdate:(BOOL) update;

+ (void) setNeedChartAnimation:(BOOL) chartAnimation;

/**
 * 设置是否显示主目录下左上角的返回按钮
 * @param show 是否显示
 */
+ (void)setShowMainMenuLeftBackButton:(BOOL)show;

@end
