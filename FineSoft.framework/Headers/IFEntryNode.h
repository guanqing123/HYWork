//
//  IFEntry.h
//  IFWidget
//
//  Created by 魏阳露 on 15/6/5.
//  Copyright (c) 2015年 FineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

typedef enum {
    IFEntryTypeInvalid, //不支持的类型
    IFEntryTypeFolder,  //文件
    IFEntryTypeReport,  //报表
    IFEntryTypeLink,    //超链
    IFEntryTypeCpr,  //定时文件
    IFEntryTypeBI,  //BI
    IFEntryTypeBI_SHARE2ME, //BI分享给我的
    IFEntryTypeBI_ICREATE   //BI我创建的
} IFEntryType;

/**
 *  挂载在平台目录树上的节点对象
 */
@interface IFEntryNode : NSObject

//id标识
@property (nonatomic, copy) NSString *entryId;

//父节点id
@property (nonatomic, copy) NSString *parentId;

//显示值
@property (nonatomic, copy) NSString *displayName;

//描述
@property (nonatomic, copy) NSString *nodeDescription;

//类型
@property (nonatomic, assign) IFEntryType entryType;

//顺序
@property (nonatomic, assign) NSInteger sortIndex;

//封面图片Id
@property (nonatomic, copy) NSString *coverId;

//收藏id
@property (nonatomic, copy) NSString *favoriteId;

//暂存报表的Id
@property (nonatomic, copy) NSString *cacheReportId;

//离线的时间
@property (nonatomic, copy) NSDate *offlineDate;

//子节点
@property (nonatomic, strong) NSMutableArray *children;

//缩略图
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, copy) NSString *url;

/**
 *  根据entry信息创建node对象
 *
 *  @param entry entry信息
 *
 *  @return node对象
 */
+ (IFEntryNode *) createNode:(NSDictionary *) entry ;

/**
 *  是否是文件夹
 *
 *  @return 是否是文件夹
 */
- (BOOL) isFolder;

/**
 *  文件夹节点下的所有子报表，IFEntryNode类型的数组
 *
 *  @return 文件夹节点下的所有子报表
 */
- (NSMutableArray *) children;

/**
 *  是否是支持的类型(报表/表单/链接)
 *
 *  @return 是否是支持的类型
 */
- (BOOL) isSupport;

/**
 *  将对象转换成字典类型
 *
 *  @return 字典类型
 */
- (NSDictionary *) toJson;

@end
