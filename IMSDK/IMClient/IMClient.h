//
//  YGTCPUserStateManager.h
//  IM
//
//  Created by jiangxincai on 15/4/20.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "YGCommon.h"
#import "IMMessage.h"
#import <UIKit/UIKit.h>

@protocol ReceiveMessageDelegate <NSObject>

@required

/**
 接收消息的回调方法

 @param message 当前接收到的消息
 @param pushMessageType 消息类型
 */
- (void)onReceived:(id)message
            PushMessageType:(YGHandlePushMessageType)pushMessageType;

@end

@interface IMClient : NSObject

@property (nonatomic, weak) id<ReceiveMessageDelegate>receiveMessageDelegate;


/**
 *  当前登录用户的ID
 */
@property (nonatomic,copy) NSString *userID;

@property (nonatomic,copy) NSString *token;

/**
 *  当前用户的头像
 */
@property (nonatomic,copy) NSString *avatar;

/**
 *  当前用户的登录名
 */
@property (nonatomic,copy) NSString *name;



/**
  服务器host
 */
@property (nonatomic,copy) NSString *host;

/**
 服务器port
 */
@property (nonatomic,copy) NSString *port;

/**
 *  推送token
 */
@property (copy, nonatomic) NSString *devicetoken;


/**
 app名称，用于区分APNS推送证书
 */
@property (nonatomic, copy) NSString *appName;


//设备id（应用不卸载只有一个）
@property (nonatomic, strong ,readonly) NSString *deviceID;


+ (instancetype)sharedClient;



/**
 *
 *
 *  @param code        token
 *  @param isReconnect 是否重连
 *  @param success     成功
 *  @param failure     失败
 */
//- (void)connectWithVerifyCode:(NSString*)code isReconnect:(BOOL)isReconnect success:(void(^)(id user))success failure:(void(^)(NSError* error))failure;

/**
 *  重新连接
 *
 *  @param block 结果block
 */
- (void)reconnect:(void (^)(BOOL reconnectIsSuccess))block;

/**
 *  连接结果
 *
 *  @param block 结果
 */
- (void)connectResult:(ResultBlock)block;

/**
 *  退出登录
 */
//- (void)logoutHandle:(int)type;//0 被踢下线  1 正常logout

/**
 *  断开连接
 */
//- (void)disconnectHandle;

/**
 *  发送退出登录消息给服务器
 */
- (void)sendOfflineWithUnreadCount:(NSInteger)count;

/**
 *  发送应用退到后台消息给服务器
 */
- (void)sendOfflineBackgroundWithUnreadCount:(NSInteger)count;


/**
 *  Im登录
 */
- (void)imConnectWithUserId:(NSString *)userId
                      Token:(NSString *)token
                 ServerHost:(NSString *)host
                 ServerPort:(NSString *)port
                    Success:(void(^)(id user))success
                    failure:(void(^)(NSError* error))failure;




/**
 获取离线消息
 */
- (void)getOfflineMessages;



/**
 发送消息
 @param message 消息体
 @param success 成功回调，返回消息实际到达服务器的时间
 @param failure 失败回调
 */
- (void)sendMessage:(IMMessage *)message
            Success:(void(^)(NSString* time))success
            failure:(void(^)(NSError* error))failure;


/**
 连接客服

 @param Id 客服ID
 @param sessionId 会话ID
 @param mobile 手机号
 @param type 1-发起请求 2-结束会话 3-客服端确认收到会话请求 4-用户端确认收到结束会话通知
 @param photo 用户头像
 */
- (void)connectCustomerServiceWithID:(NSString *)Id
                          SesssionId:(NSString *)sessionId
                              Mobile:(NSString *)mobile
                               Photo:(NSString *)photo
                                Type:(NSInteger)type
                             Success:(void(^)(void))success
                             failure:(void(^)(NSError* error))failure;

/**
 APP进入后台

 @param application <#application description#>
 */
- (void)applicationDidEnterBackground:(UIApplication *)application UnreadCount:(NSInteger)count;


//
/**
 APP将要从后台返回

 @param application <#application description#>
 */
- (void)applicationWillEnterForeground:(UIApplication *)application;

/**
 注册推送
 */
- (void)registerAppName:(NSString *)appName;


/**
 绑定deviceToken，用于APNS

 @param deviceToken 推送token
 */
- (void)bindDeviceToken:(NSData *)deviceToken;


@end
