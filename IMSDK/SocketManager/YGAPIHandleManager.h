//
//  YGAPIHandleManager.h
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YGHandlePushMessageType) {
    YGHandlePushMessageType_ReceiveChatMessage = 0,//收到消息
    YGHandlePushMessageType_ReceiveAddContact,//收到好友申请
    YGHandlePushMessageType_ReceiveJoinGroup,//收到加入群申请
    YGHandlePushMessageType_BeAgreedGroup,//收到被群同意
    YGHandlePushMessageType_BePulledInGroup,//收到被群拉入
    YGHandlePushMessageType_BeCreatedGroup,//收到被群创建拉进
    YGHandlePushMessageType_ReceiveGoodLuck,//收到自己中奖消息
    YGHandlePushMessageType_ReceiveGroupGoodLuck,//收到群里有人中奖消息
    YGHandlePushMessageType_ReceiveFileResult,//收到文件发送完成
    YGHandlePushMessageType_ReceiveBlackList,//收到黑名单
    YGHandlePushMessageType_ReceiveWhiteList,//收到白名单
    YGHandlePushMessageType_ReceiveAdmin,//收到被设为管理员
    YGHandlePushMessageType_ReceiveUnadmin,//收到取消管理员
    YGHandlePushMessageType_JoinGroupMember,//收到群成员加入通知
    YGHandlePushMessageType_OtherBeJoinGroup,//别的群成员被拉入群
    YGHandlePushMessageType_ServerKickOff,//收到被踢通知
    YGHandlePushMessageType_beDeletedFriend,//被删除好友
    YGHandlePushMessageType_DeleteFriendFromPC,//PC端主动删除好友
    YGHandlePushMessageType_beEndChatForStranger,// 临时聊天被结束
    YGHandlePushMessageType_DeletedFriendFromNet,//删除好友(网站删除)
    YGHandlePushMessageType_AddFriend,//被同意添加好友
    YGHandlePushMessageType_AccpetFriendFromPC,//自己在PC同意别人添加好友
    YGHandlePushMessageType_invitedJoinGroup,//被邀请入群
    YGHandlePushMessageType_MemberBeKicked,//自己是普通成员踢
    YGHandlePushMessageType_GroupMemberQuit,//收到群成员退出
    YGHandlePushMessageType_DissolveGroup,//群解散
    YGHandlePushMessageType_DissolveGroupBySelfFromPC,// 自己在pc端解散群
    YGHandlePushMessageType_OtherBeKicked,//别人被踢掉、
    YGHandlePushMessageType_DisableSendMsg,//被禁言
    YGHandlePushMessageType_AbleSendMsg,//被取消禁言
    YGHandlePushMessageType_GroupBeFreezed,//群被冻结
    YGHandlePushMessageType_GroupRemoveFreeze,//群被冻结
    YGHandlePushMessageType_UserBeShutup,//收到用户被禁言
    YGHandlePushMessageType_System_Activity,//收到系统活动消息
    YGHandlePushMessageType_System_Warning,//收到系统违规警告通知
    YGHandlePushMessageType_System_Update,//收到系统升级通知
    YGHandlePushMessageType_System_Lose,//收到未获得商品通知
    YGHandlePushMessageType_System_Accounts,//收到系统资金转账通知
    YGHandlePushMessageType_System_Show,//收到系统晒单审核未通过
    YGHandlePushMessageType_System_Send,//收到发货提醒
    YGHandlePushMessageType_System_Showaccess,//晒单审核通过
    YGHandlePushMessageType_GroupInfoChange,//群信息改变
    YGHandlePushMessageType_MemberInfoChange,//群成员信息改变
    YGHandlePushMessageType_UpdateSelfSetsInGroupFromPc,// 自己在PC端改变群设置
    YGHandlePushMessageType_Wordfilter_Cheat,//收到提示关键字推送
    YGHandlePushMessageType_Wordfilter_Advert,//收到屏蔽关键字推送
    YGHandlePushMessageType_ReceiveGetGoods,//====新增收到自己中奖消息
    YGHandlePushMessageType_RetractMessage,//收到撤回消息
    YGHandlePushMessageType_ReceiChatCalling,//收到视频语音通话
    //======这里是直播通知消息的分界线======
    YGHandlePushMessageType_LiveUserEnter,//进入直播间通知
    YGHandlePushMessageType_LiveUserLeave,//离开直播间通知
    YGHandlePushMessageType_liveUpvote,//用户点赞(通知)
    YGHandlePushMessageType_liveEnd,//结束直播(通知)
    YGHandlePushMessageType_liveTopOnlineUsers,//获取当前直播间前N个在线用户通知
    YGHandlePushMessageType_livePause,//暂停直播通知
    YGHandlePushMessageType_liveResume,//恢复直播通知
    YGHandlePushMessageType_liveForeverFormbid,//永久禁播通知
    YGHandlePushMessageType_liveUnFormbid,//解冻主播通知
    YGHandlePushMessageType_liveForceStop,//关停直播间通知
    YGHandlePushMessageType_liveWarningAnchor,//警告主播通知
    YGHandlePushMessageType_liveWarningUser,//警告用户通知
    YGHandlePushMessageType_liveSlientUser,//用户禁言通知
    YGHandlePushMessageType_liveUnSlientUser,//用户解除禁言通知
    YGHandlePushMessageType_liveSlientAnchor,//主播禁言通知
    YGHandlePushMessageType_liveUnSlientAnchor,//主播解除禁言通知
    YGHandlePushMessageType_liveRealNameAuth,//实名认证审批通知
    YGHandlePushMessageType_liveGlobalAffiche,//直播全局公告通知 
    YGHandlePushMessageType_liveGlobaClose,//直播全局关闭通知
    YGHandlePushMessageType_liveGlobaOpen,//直播全局打开
    YGHandlePushMessageType_liveUserSupport,//用户支持通知
    YGHandlePushMessageType_liveWishReach,//心愿达成结果通知 1.实现 2.失败。3.强制关闭 4.取消 5.发起
    YGHandlePushMessageType_ReceiveLiveChatMessage,//直播室聊天消息
    //======这里是动态通知消息的分界线======
    YGHandlePushMessageType_PublishComment,//动态评论推送消息
    YGHandlePushMessageType_TopAttentionUser,//关注用户置顶/取消置顶

    
    //============红包=================
    YGHandlePushMessageType_RedPacketRefund,    // 红包退款
    YGHandlePushMessageType_ReceiveRedPacket,//领取红包通知
    
//    301-下单成功 302-支付成功 303-已发货 304-被分享人开店 305-店主获得收益
    //------------满金店---------------
    YGHandlePushMessageType_OrderSuccess = 301,   //下单成功
    YGHandlePushMessageType_PaySuccess = 302,     //支付成功
    YGHandlePushMessageType_Shipped = 303,        //已发货
    YGHandlePushMessageType_SharedOpenStore = 304,//被分享人开店
    YGHandlePushMessageType_Income = 305,         //店主获得收益
    
    YGHandlePushMessageType_CustomerService,    // 客服服务
    YGHandlePushMessageType_Unknow,             //未知
    
};


@protocol YGHandlePushMessageDelegate <NSObject>

@optional

- (void)handlePushMessageJsonDictionary:(NSDictionary*)dictionary withType:(YGHandlePushMessageType)type;
- (void)handlePushMessagesArray:(NSArray *)msgArray;

@end

@class YGSuperAPI;

@interface YGAPIHandleManager : NSObject

+ (instancetype)sharedManager;

@property (weak, nonatomic) id <YGHandlePushMessageDelegate> delegate;
@property (strong, atomic) NSMutableDictionary *apiResponseMap;
/**
 *  注册接口类的实例到manager
 *
 *  @param api 请求的接口
 *
 *  @return 重复的不注册，返回no
 */
- (BOOL)registerApi:(YGSuperAPI*)api;

/**
 *  解除注册api
 *
 *  @param randomID id
 */
- (void)removeApiWithRandomID:(NSString*)randomID;

/**
 *  解除所有注册api
 *
 */
- (void)removeAllApi;

/**
 *  注册超时，到达超时时间还未清除缓存，代表超时，返回error
 *
 *  @param api 请求的接口
 */
- (void)registerTimeoutWithTime:(double)delayInSeconds randomID:(NSString *)randomID;


/**
 *  处理返回的数据
 *
 *  @param data 返回的数据
 */
- (void)receiveServerDictionary:(NSDictionary*)jsonDictionary;


/**
 处理非请求返回的数据
 */
- (void)unrequestAPIHandelWithDictionary:(NSDictionary *)jsonDictionary firstKey:(NSString*)firstKey;

#pragma mark - reply

- (void)replyMessageToServerWithDictionary:(NSDictionary *)dictionary;

@end
