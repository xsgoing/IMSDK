//
//  YGChatConstant.h
//  IMDB
//
//  Created by xk on 15/5/7.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#ifndef IMDB_YGChatConstant_h
#define IMDB_YGChatConstant_h

#define TCPAPI_ERROR_PACKAGE @"打包错误"
#define TCPAPI_ERROR_TIMEOUT @"请求超时"
#define TCPAPI_ERROR_FAILURE @"请求失败"
#define TCPAPI_ERROR_ANALYSI @"解析错误"
#define TCPAPI_ERROR_SERVERDATA @"服务器返回数据错误"
#define TCPAPI_ERROR_SERVERNNOCONNECT @"服务器无法连接"
#define TCPAPI_ERROR_DISCONNECT @"网络断开,请检查网络"
#define TCPAPI_ERROR_NOCONNECT @"未登录"
#define TCPAPI_ERROR_IMCLOSE @"消息通知服务暂时关闭"
#define UserDefaultsObj     [NSUserDefaults standardUserDefaults]

//#define IM_TCP_PORT 6333
#define UDP_SERVER_TRANSFER_PORT 6224  //中转 鉴权端口号

//#define IM_INSIDENET_IP @"1.1.1.116"
//#define IM_INSIDENET_IP @"1.1.1.80"
//#define IM_INSIDENET_IP @"1.1.1.133"
#define IM_INSIDENET_IP @"1.1.1.35"
#define IM_OUTSIDENET_IP @"14.17.97.163"
#define IM_UDPNAT_IP @"218.17.43.171"
//#define IMDPlusState    (([UserDefaultsObj integerForKey:kUD_NetEnvironmentConfig]==2)?1:0)     //IM D+
#define IMDPlusState    1   //IM D+
//测试的密钥
#define IM_OutsideNetTestToken  @"test.tcp@2015"
#define IM_OfficialToken        @"1yyg.im.tcp@2016"//@"test.imserver.2017"
#define IM_LocalToken           @"test.imserver.2017"


typedef NS_ENUM(NSUInteger, TCPAPIErrorCode) {
    TCPAPIErrorCodeRequestPackage = 1000,
    TCPAPIErrorCodeRequestTimeOut,
    TCPAPIErrorCodeRequestFailure,
    TCPAPIErrorCodeAnalysisMistake,
    TCPAPIErrorCodeServerDataError,
    TCPAPIErrorCodeServerNOConnect,
    TCPAPIErrorCodeDisconnect,
    TCPAPIErrorCodeNOconnect,
    TCPAPIErrorCodeIMClose,
    TCPAPIErrorCodeKickout,//-14
};

typedef NS_ENUM(NSUInteger, YGIMResult) {
    YGIMResult_YES = 0,//结果为yes
    YGIMResult_NO,//结果为no
    YGIMResult_NetWorkError,//结果网络错误
};

typedef void(^RequestCompletion)(id response,NSError* error);

/**
 消息的状态
 */
typedef enum :NSInteger
{
    ChatMessageStatus_uploading          = 0, // 消息上传发送中
    ChatMessageStatus_uploadSuccess      = 1, // 消息上传发送成功
    ChatMessageStatus_uploadFailed       = 2, // 消息上传发送失败
    ChatMessageStatus_downloading        = 3, // 消息下载中
    ChatMessageStatus_downloadSuccess    = 4, // 消息下载成功
    ChatMessageStatus_downloadFailed     = 5,  // 消息下载失败
    ChatMessageStatus_noDowload          = 6,  // 未下载
    ChatMessageStatus_uploadPause        = 7, //暂停发送
    ChatMessageStatus_downloadPause      = 8   //暂停下载
}ChatMessageStatus;


/**
 服务器的聊天联系人更新了新的信息，更新本地缓存
 */
typedef enum : NSInteger {
    ChatSessionCacheUpdateType_userHead          = 0, // 服务器头像更新了，需要更新本地缓存的头像
    ChatSessionCacheUpdateType_userName          = 1, // 服务器名称更新了，需要更新本地缓存的名称
    ChatSessionCacheUpdateType_unReadMsgCount    = 2  // 服务器未读消息数更新了，需要更新本地缓存的未读消息数
    
}ChatSessionCacheUpdateType;


/**
 * 好友黑名单关系
 */
typedef enum : NSInteger {
    BlacklistStatus_none        = 0, // 正常好友关系
    BlacklistStatus_incast      = 1, // 对方被我加入了黑名单
    BlacklistStatus_outcast     = 2, // 我被对方加入了黑名单
    BlacklistStatus_bothcast    = 3  // 双方都被对方加入了黑名单
}YGBlacklistStatus;


typedef NS_ENUM(NSUInteger, YGMessageContentType) {
    
    YGMessageContentTypeText = 0,//文字消息
    YGMessageContentTypeImage,//图片消息
    YGMessageContentTypeAudio,//语音消息
    YGMessageContentTypeVideo,//视频消息
    YGMessageContentTypeShortVideo,//小视频消息
    YGMessageContentTypeRelationship,//关系消息
   
    YGMessageContentTypeNewMessageRemind,//以下为新消息提示消息
    YGMessageContentTypeImFile,//文件消息
    YGMessageContentTypeDraft,//草稿消息
    YGMessageContentTypeRetract,//撤回消息
    YGMessageContentTypeMediaCall,//语音聊天
    YGMessageContentTypeFace,//表情消息
    YGMessageContentTypeGroupCard,//分享群名片
    YGMessageContentTypeLongText, //长文本
    ygmessagecontentTypeGroupRequest,//申请入群
    YGMessageContentTypeUnKnow,// 未知消息类型
    YGMessageContentTypeRedPacket,//红包消息
    YGMessageContentTypeReceiveRedPacketMsg,//红包被领取消息
    YGMessageContentTypeRedPacketUploadFail,//红包发送失败
    YGMessageContentTypeEvaluation,//评价
    YGMessageContentTypeCommodity,//商品
    YGMessageContentTypeOrder,   // 订单
    YGMessageContentTypeCustom, //售后
    YGMessageContentTypeExtend, //扩展（自定义）
};


typedef NS_ENUM(NSUInteger, EvaluationResult) {
//    [1-很满意 2-满意 3-一般 4-不满意]
    EvaluationResult_Good = 1,
    EvaluationResult_OK = 2,
    EvaluationResult_Soso = 3,
    EvaluationResult_Bad = 4,
};


typedef NS_ENUM(NSUInteger, YGCannotSendMsgType) {
    YGCannotSendMsgType_BeDeleteByGroup,//被群删除
    YGCannotSendMsgType_groupDissolve,// 群被解散
    YGCannotSendMsgType_BeDelete,//被好友删除
    YGCannotSendMsgType_BeOutcast,//被加入黑名单
    YGCannotSendMsgType_BeDisableSendMsg,//被加入群禁言
    YGCannotSendMsgType_BeShutup,//被官方禁言
    YGCannotSendMsgType_StrangerMax,//陌生人到达最大条数
    YGCannotSendMsgType_TempChatEnd,//临时聊天已结束
    YGCannotSendMsgType_RefuseStrange,//对方拒绝接收陌生人消息
    YGCannotSendMsgType_RedPacketUploadFailed, //红包发送失败
};

typedef NS_ENUM(NSUInteger, YGGroupType) {
    YGGroupType_Normal = 0,//普通群
    YGGroupType_Official,//官方群
    YGGroupType_Commodity,//商品  群
    YGGroupType_liveRoom,//直播间
};


typedef NS_ENUM(NSUInteger, YGMessageType) {
    YGMessageTypeChat = 0,//个人
    YGMessageTypeGroupChat,//群聊
    YGMessageTypeGroupOfficial,//官方群
    YGMessageTypeGroupCommodity,//商品群
    YGMessageTypeGroupLiveRoom,//直播间
    YGMessageTypeStranger,  // 陌生人消息
    YGMessageTypeTemp,      // 临时消息
};

typedef NS_ENUM(NSUInteger, YGSessionType) {//消息会话类型
    YGSessionType_buddysMessage = 0,   //好友消息
    YGSessionType_friendNotify,     //好友通知
    YGSessionType_groupNotify,     //群通知
    YGSessionType_systemNotify,     //系统通知
    YGSessionType_congratulation,   //获奖通知
    YGSessionType_groupsMessage,    //群消息
    YGSessionType_CommodityMessage,   //商品群
    YGSessionType_OfficialGroupMessage, //官方群
    YGSessionType_strangerMessage,  //  陌生人消息
    YGSessionType_temporaryMessage  // 临时消息
};

typedef NS_ENUM(NSUInteger, YGSessionStatus) {//消息会话状态
    YGSessionStatus_Normal = 0,     //正常
    YGSessionStatus_BeRemoveGroup,  //被移除群
    YGSessionStatus_GroupDissolve,  //群被解散
   
};


typedef NS_ENUM(NSUInteger, YGMessageMediaType) {
    YGMessageMediaType_Image,//图片
    YGMessageMediaType_Audio,//音频
    YGMessageMediaType_Video,//视频
    YGMessageMediaType_ImFile,//文件
};

typedef NS_ENUM(NSUInteger, YGMessageChatCallType) {
    YGMessageChatCallType_VideoReceive = 0,//被邀请视频聊天
    YGMessageChatCallType_AudioReceive = 1,//被邀请音频聊天
    YGMessageChatCallType_VideoCall = 2,//发起视频聊天
    YGMessageChatCallType_AudioCall = 3,//发起音频聊天
    YGMessageChatCallType_AudioCalling = 4,//通话中
    YGMessageChatCallType_VideoCalling = 5,//通话中
};

typedef NS_ENUM(NSUInteger, YGMessageChatCallStatus) {
    YGMessageChatCallStatus_Trying = 100,/** 呼叫 振铃*/
    YGMessageChatCallStatus_Receive = 200, /** 接听 */
    YGMessageChatCallStatus_Call = 300,  /** 通话中 */
    YGMessageChatCallStatus_HangUp = 400, /** 挂断 ------------发送，需要保存*/
    YGMessageChatCallStatus_Refuse = 500, /** 拒绝 -----------发送，需要保存接听 */
    YGMessageChatCallStatus_Cancel = 600,/** 取消呼叫-----------发送，需要保存*/
    YGMessageChatCallStatus_ChangeToAudio = 700,/** 转为语音通话(呼叫中使用)*/
    YGMessageChatCallStatus_SwitchToAudio = 800, /** 转为语音通话(通话中使用)*/
    YGMessageChatCallStatus_UnAnswer = 900, /**对方无应答----------发送，需要保存*/
    YGMessageChatCallStatus_CallFail= 1000,/**呼叫失败-------------发送，需要保存*/
    YGMessageChatCallStatus_Busy = 1100,/**对方正忙*/
    YGMessageChatCallStatus_UDPProbe1 = 1200, /** udp 端口探测1(接听方发起) */
    YGMessageChatCallStatus_UDPProbe2 = 1201,  /** udp 端口探测2(主叫方发起) */
    YGMessageChatCallStatus_UDPProbe3 = 1202, /** udp 打洞成功 */
    YGMessageChatCallStatus_UDPProbe4 = 1203, /** udp 打洞失败 */
    YGMessageChatCallStatus_TCPProbe1 = 1210,/** tcp 端口探测1(接听方发起) */
    YGMessageChatCallStatus_TCPProbe2 = 1211, /** tcp 端口探测2(主叫方发起) */
    YGMessageChatCallStatus_TCPProbe3 = 1212,  /** tcp 打洞成功 */
    YGMessageChatCallStatus_INTERRUPTED= 1600,/**通话中断*/

};

typedef NS_ENUM(NSUInteger, YGNatBurrowType) {//打洞类型
    YGNatBurrowType_Success = 0,//打洞成功
    YGNatBurrowType_Failed = 1,//打洞失败
    YGNatBurrowType_OverTime = 2,//打洞超时
    YGNatBurrowType_Cancel = 3,//取消打洞
};


typedef NS_ENUM(NSUInteger, YGGroupMemberIdentity) {
    YGGroupMemberIdentity_NomalMember,//群成员
    YGGroupMemberIdentity_Admin,//是群成员，且是管理员
    YGGroupMemberIdentity_Owner,//群主
    YGGroupMemberIdentity_Tourist,//非群成员
};


typedef NS_ENUM(NSUInteger, YGCollectionViewCellStatus) {
    YGCollectionViewCellStatusNormal = 0,
    YGCollectionViewCellStatusEditing,
};

/* 文件类型
 */

 typedef NS_ENUM(NSUInteger, YGFileDocType) {
 YGMessageFileTypeDoc = 0,//文档类型
 YGMessageFileTypeImage,//图片类型
 YGMessageFileTypeMP3,//音乐类型
 YGMessageFileTypeMP4,//视频类型
 YGMessageFileTypeUnKnown//未知类型
 };

/*
 tool 工具
 */

typedef NS_ENUM(NSUInteger,YGliveMoreToolType) {
    YGLiveMoreToolType_updataTitle = 0,
    YGLiveMoreToolType_cancelWish,
    YGLiveMoreToolType_updataWishContent,
    YGLiveMoreToolType_beauty,
    YGLiveMoreToolType_swap
};
///结束直播类型
typedef NS_ENUM(NSUInteger,YGliveEndType) {
    YGLiveEndType_normal = 0,//正常结束
    YGLiveEndType_forbid,//强制禁播
    YGliveEndType_serverInter//服务器中断
};
//群分组
typedef NS_ENUM(NSUInteger,YGGroupSectionType) {
    YGGroupSectionType_join = 0,//我加入的群
    YGGroupSectionType_owner,//我创建的群
    YGGroupSectionType_admin,//我管理的群
};

/**
 *  根据付款对象展示的列表格式
 */
typedef enum{
    PaymentTypeChange = 0,//零钱支付
    PaymentTypeWeChat,//微信支付
    PaymentTypeAlipay,//支付宝支付
    PaymentTypeSelectPayType,//选择支付方式
    PaymentTypeErrorTip,//使用其他支付方式
}PaymentType;


///  红包类型
typedef NS_ENUM(NSInteger, RPRedpacketType) {
    
    RPRedpacketTypeSingle = 0,     /***  个人红包 */
    RPRedpacketTypeGroupAvg,       /***  群普通红包 */
    RPRedpacketTypeGroupRand,      /***  拼手气红包 */
};

///  红包与当前用户的关系
typedef NS_ENUM(NSInteger, RPRedpacketStatusType) {
    
    RPRedpacketStatusTypeOutDate = -1,        /***  红包已过期 */
    RPRedpacketStatusTypeCanGrab = 0,         /***  红包进行中 */
    RPRedpacketStatusTypeGrabReceive = 1,      /***  红包已领取 */
    RPRedpacketStatusTypeGrabFinish = 2,      /***  红包已领完 */
    
};

#define MESSAGEPROTOCOL_API @"api"
#define MESSAGEPROTOCOL_APIID @"apiId"
#define MESSAGEPROTOCOL_FROM @"from"
#define MESSAGEPROTOCOL_TO @"to"
#define MESSAGEPROTOCOL_CODE @"code"
#define MESSAGEPROTOCOL_DATA @"data"
#define MESSAGEPROTOCOL_ITEMS @"items"
#define MESSAGEPROTOCOL_ITEM @"item"
#define MESSAGEPROTOCOL_ERROR @"error"

#endif
