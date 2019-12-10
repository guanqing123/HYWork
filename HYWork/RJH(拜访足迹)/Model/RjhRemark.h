//
//  RjhRemark.h
//  HYWork
//
//  Created by information on 2017/6/12.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RjhRemark : NSObject

/** 点评记录id */
@property (nonatomic, copy) NSString *rid;
/** 点评内容 */
@property (nonatomic, copy) NSString *remark;
/** 点评人工号 */
@property (nonatomic, copy) NSString *operatorid;
/** 点评人姓名 */
@property (nonatomic, copy) NSString *operatorname;
/** 点评接收人工号 */
@property (nonatomic, copy) NSString *sendeeid;
/** 点评接收人姓名 */
@property (nonatomic, copy) NSString *sendeename;
/** 点评日期 */
@property (nonatomic, copy) NSString *operatetime;
/** 自动的frame */
//@property (nonatomic, assign) CGRect remarkF;
//@property (nonatomic, strong) NSValue *remarkF;
@property (nonatomic, copy) NSString *remarkF;
@end
