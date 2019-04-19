//
//  YGAPIProtocol.h
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YGAPIProtocol <NSObject>
@required

/**
 *  解析数据的方法
 *
 *  @return 返回一个解析好的数据类型，可以是NSString,NSArray,也可以是model
 */
- (id)analysisReturnDataWithDictionary:(NSDictionary*)dictionary;

/**
 *  创建打包字典的方法
 *
 *  @return 返回一个打包好一个NSDictionary方便转换NSData
 */
- (NSDictionary *)creatPackageDictionaryWithObject:(id)object;

/**
 *  超时时间，默认为10秒
 *
 *  @return 时间秒
 */
- (NSInteger)requestTimeOutTimeInterval;

/**
 *  超时重试次数，默认为0
 *
 *  @return 次数
 */
- (NSInteger)numberOfTimeOutRetries;


/**
 *  是否需要分包发送
 *
 *  @return 是否
 */
- (BOOL)isNeedPartPackage;

@optional

/**
 *  分包方法加字段方法
 *
 *  @param dictionary 已经完成的包
 *
 *  @return 加好字段的包
 */
- (NSDictionary *)addPartTextWithPackageDictionary:(NSDictionary *)dictionary;

/**
 *  分包统一的名称
 *
 *  @return 名称
 */
- (NSString *)partName;

/**
 *  分包的当前包
 *
 *  @return 包
 */
- (NSUInteger)partOrder;

/**
 *  分包的总数
 *
 *  @return 总数
 */
- (NSUInteger)partTotal;

@end
