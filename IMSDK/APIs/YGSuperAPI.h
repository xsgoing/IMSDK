//
//  YGSuperApi.h
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGAPIProtocol.h"
#import "IMClient.h"
#import "YGChatConstant.h"
#import "IMReachabilityManager.h"
static NSInteger const YGRequestPageCount = 20;

@class YGSuperAPI;

@protocol YGAPIDelegate <NSObject>

- (void)api:(YGSuperAPI *)api didReceiveResponse:(id)response error:(NSError *)error;

@end



@interface YGSuperAPI : NSObject <YGAPIProtocol>

/**
 *  回调block
 */
@property (nonatomic,copy) RequestCompletion completion;

/**
 *  代理回调
 */
@property (weak, nonatomic) id<YGAPIDelegate> delegate;

/**
 *  随机ID
 */
@property (nonatomic,copy) NSString *randomID;

/**
 *  请求完成标识
 */
@property (assign, nonatomic) BOOL isCompletion;

/**
 *  当前超时次数
 */
@property (assign, nonatomic) NSInteger retryNumbers;

/**
 *  发送data数据
 */
@property (strong, nonatomic) NSData *saveData;



/**
 *  请求数据，通过Object参数,在API类里面打包成为json数据NSDictionary类型，转为data发送,收到后在API类通过Analysis这个block处理后通过completion返回回调的model使用
 *
 *  @param object     请求需要打包的数据
 *  @param completion 结束回调block
 */
- (void)requestWithObject:(id)object completion:(RequestCompletion)completion;

- (void)requestWithObject:(id)object delegate:(id<YGAPIDelegate>)delegate;
/**
 *  重新发送数据
 */
- (void)retrySendData;

- (void)callBackWithError:(NSError *)error;

/**
 *  请求api的类方法
 *
 *  @param object 需要打包的数据
 *  @param block  结束回调的block
 */
+ (void)requestWithObject:(id)object completion:(RequestCompletion)completion;

#pragma mark - 子类方法
/**
 *  复写创建发送data方法可以额外添加二进制流
 *
 *  @param object
 *
 *  @return
 */
- (id)sendDataWithObject:(id)object;

/**
 *  判断是否返回错误
 *
 *  @param string type字段
 *
 *  @return 返回nserror或者nil
 */
+ (NSError*)judgeRequestErrorWithString:(NSString*)string;

+ (NSString *)className;

@end
