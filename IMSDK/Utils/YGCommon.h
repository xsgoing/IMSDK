//
//  Common.h
//  mobile
//
//  Created by xk on 14-11-20.
//  Copyright (c) 2014年 1yyg. All rights reserved.
//

#ifndef mobile_Common_h
#define mobile_Common_h

//设置界面换绑手机
#define Setting_Bind_Phone_KEY  @"phone"
//客户热线
#define yHotlinePhone @"telprompt://4000588688"

//Img
#define USER_PHOTO_Default_Img      [UIImage imageNamed:@"Default_Avatar"]
#define GROUP_PHOTO_Default_Img      [UIImage imageNamed:@"im_default_group"]
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define GOODS_Default_Img           [UIImage imageNamed:@"goods_pic_default"]
#define GOODS_Default_GifImg        [UIImage imageNamed:@"goods_pic_default"]
#define Live_Default_Img            [UIImage imageNamed:@"live_defualt"]
#define Live_Default_Avtar          [UIImage imageNamed:@"live_default_avatar"]
#define Line_Default_Cover          [UIImage imageNamed:@"live_default_cover"]
#define IMServiceMostSendTextLength 200
#define GOODS_Default_BIG_GifImg    [UIImage imageNamed:@"shareorder_detail_image_default"]
#define GOODS_Default_BIG_Failed    [UIImage imageNamed:@"shareorder_detail_image_failed"]

#define yLine_Horizontal_Image      [UIImage imageNamed:@"line_horizontal_view"]
#define yLine_Vertical_Image        [UIImage imageNamed:@"line_vertical_view"]

//图片处理系数
#define IM_ImageCompressionRatio 1

//MBProgressHUD 提示显示时间
#define HUD_DURATION_TIME 1

//view显示与隐藏动画持续时间
#define kView_Animate_Duration 0.25f


//解析网络数据数组
#define kModel_Arr              @"modelArr"
#define kReplyModel_arr         @"replyModel_arr"

//解析添加购物车的model
#define kAddToCartModel @"AddToCartModel"

//更新用户信息key
#define kUpdateUserInfoKey  @"UpdateUserInfoKey"


#pragma mark -
#pragma mark - NotificationCenter 通知中心命名

#define kNC_LoginKickOffLine        @"NC_LoginKickOffLine"      //单点登录被踢下线
#define kNC_GetQQLoginInfoSuc       @"NC_GetQQLoginInfoSuc"     //获取QQ验证信息成功
#define kNC_LoginSuc                @"NC_LoginSuc"              //登录成功
#define kNC_LoginOutSuc             @"NC_LoginOutSuc"           //退出登录成功
#define kNC_SettingBindPhoneSuc     @"NC_SettingBindPhoneSuc"   //设置绑定手机号成功
#define kNC_UploadAvatarSuc         @"NC_UploadAvatarSuc"       //更新头像成功
#define kNC_UploadNickNameSuc       @"NC_UploadNickNameSuc"     //修改昵称成功
#define kNC_UploadUserHeadView      @"NC_UploadUserHeadView"    //更新用户信息
#define kNC_AddGoodsToCart          @"NC_AddGoodsToCart"        //添加商品到购物车
#define kNC_ShopCartGoodsOutOfDate  @"NC_ShopCartGoodsOutOfDate"//购物车商品过期
#define kNC_GetLAnnouncedSuc        @"NC_GetLAnnouncedSuc"      //获取最新揭晓数据
#define kNC_GetCalculateSuc         @"NC_GetCalculateSuc"       //获取正在计算数据
#define kNC_GetDidAnnouncedSuc      @"NC_GetDidAnnouncedSuc"    //获取已经揭晓数据
#define kNC_HadNewAnnouncedData     @"NC_HadNewAnnouncedData"   //有揭晓数据变化
#define kNC_GetBarcodeRNOInfo       @"NC_GetBarcodeRNOInfo"     //获取已开奖商品信息
#define kNC_ClearShoppingCart       @"NC_ClearShoppingCart"     //清除购物车数据
#define kNC_ClikedHomePage          @"NC_ClikedHomePage"        //首页
#define kNC_ClikedProductList       @"NC_ClikedProductList"     //商品列表
#define kNC_ClikedLatest            @"NC_ClikedLatest"          //最新揭晓
#define kNC_ClikedShopCart          @"NC_ClikedShopCart"        //购物车
#define kNC_ClikedMyCloud           @"NC_ClikedMyCloud"         //我的云购
#define kNC_Show_MyShareOrderImg    @"NC_Show_MyShareOrderImg"  //显示我的晒单图片
#define kNC_Hide_MyShareOrderImg    @"NC_Hide_MyShareOrderImg"  //隐藏我的晒单图片
#define kNC_UpdateUserInfo          @"NC_UpdateUserInfo"        //更新用户数据
#define kNC_LoginUserName           @"NC_LoginUserName"         //登录用户名
#define kNC_RequestAuthNameFailure  @"NC_RequestAuthNameFailure"  //长效失效需要重新登录
#define kNC_offlineMsgLoaded        @"kNC_offlineMsgLoaded"     // 离线消息接收完成


#define KNC_userUnMessageCount      @"KNC_userUnMessageCount"   //用户未读消息数量
#define kNC_LoginAgain              @"NC_LoginAgain"            //获取加密串，再次登录
#define kNC_StartGetLatestData      @"NC_StartGetLatestData"    //读取最新揭晓数据
#define kNC_StopGetLatestData       @"NC_StopGetLatestData"     //停止读取最新揭晓数据
#define kNC_UpdateGoodsSeconds      @"NC_UpdateGoodsSeconds"    //更新时间秒数
#define kNC_GetWXLoginInfoSuc       @"NC_GetWXLoginInfoSuc"     //获取微信验证信息成功
#define kNC_AwardProductInsertOrderSuc  @"NC_AwardProductInsertOrderSuc"    //获得商品晒单成功
#define kNC_WXPaySuc                @"NC_WXPaySuc"          //微信支付成功通知
#define kNC_FastPaySuc              @"NC_FastPaySuc"        //快捷支付成功通知
#define kNC_SearchDeltailValue      @"kNC_SearchDeltailValue"       //搜索
#define kNC_DeleteShoppingCart       @"NC_DeleteShoppingCart"       //删除购物车数据
#define kNC_RefreshAwardProductList @"NC_RefreshAwardProductList"   //刷新获奖商品列表

#define kNC_RechargeResult          @"NC_RechargeResult"            //充值结果回调通知
#define KNC_ShareOrderBackAction    @"NC_ShareOrderSubmit"          //发布晒单返回按钮通知
#define KNC_ShareOrderLikeAction    @"NC_ShareOrderLikeAction"      //个人中心的晒单列表点击喜欢按钮
#define KNC_ShareOrderSubmitImage   @"NC_ShareOrderSubmitImage"     //发布晒单图片上传后刷新最后一个图片item
#define KNC_GoodsDetailsFirstImage  @"NC_GoodsDetailsFirstImage"    //详情第一张图片 加载完成
#define KNC_OrderDetailsOneStandards    @"NC_OrderDetailsOneStandards"  //订单详情只有一个规格的状态
#define kNC_CurrentClikedHomeTab    @"NC_CurrentClikedHomePage"         //点击当前tabbar首页
#define kNC_CurrentClikedProductTab @"NC_CurrentClikedProductTab"       //点击当前tabbar所有商品
#define kNC_CurrentClikedLatestTab  @"NC_CurrentClikedLatestTab"        //点击当前tabbar最新揭晓
#define kNC_CurrentClikedCartTab    @"NC_CurrentClikedCartTab"          //点击当前tabbar购物车
#define kNC_CurrentClikedMyCloudTab @"NC_CurrentClikedMyCloudTab"       //点击当前tabbar我的云购
#define KNC_PublishWishBackLive     @"NC_PublishWishBackLive"//发布心愿后回到直播界面
#define KNC_PersonCardAtBtnClick    @"NC_PersonCardAtBtnClick"//个人名片@TA按钮点击
#define KNC_KeyboadBtnClick         @"NC_KeyboadBtnClick"//唤起键盘
#define KNC_LiveShareCopyPlay       @"NC_LiveShareCopyPlay"//播放分享


#pragma mark -
#pragma mark - NSUserDefaults命名

#define kUD_AuthUpdateTime          @"UD_AuthUpdateTime"            //auth update time
#define kUD_LoginUserName           @"UD_LoginUserName"         //用户登录账号，用于日志上传
#define kUD_LoginPwd                @"UD_LoginPwd"              //用户登录密码，用于日志上传
#define kUD_UserModel               @"UD_UserModel"             //用户model实例缓存
#define KUD_UserUnMessageCount      @"KUD_UserUnMessageCount"   //用户未读消息数量
#define kUD_IsFirstLaunch           @"UD_IsFirstLaunch"         //第一次启动记录
#define kUD_IsFirstAppUsing         @"UD_IsFirstAppUsing"       //第一次启动APP操作记录
#define kUD_NotFirstIMUsing          @"UD_NotFirstIMUsing"        //第一次打开IM
#define kUD_DescName                @"UD_DescName"              //手机号 邮箱
#define kUD_IsClosedDownloadPic     @"UD_IsClosedDownloadPic"       //是否下载图片
#define kUD_IsSwitchBrighteness     @"kUD_IsSwitchBrighteness"      //是否调节亮度
#define KUD_ScreenBrihtness         @"KUD_ScreenBrihtness"          //屏幕亮度
#define KUD_CurrentBrightness       @"KUD_CurrentBrightness"        //未打开APP之前的屏幕亮度
#define kUD_UpdateUserInfo          @"UD_UpdateUserInfo"            //更新用户信息
#define KUD_SystemMessageLastTime   @"KUD_SystemMessageLastTime"    //记录该设备最后一条消息时间
#define kUD_ADImgInfo               @"UD_ADImgInfo"                 //src;starttime;endtime
#define kUD_DBVersion               @"UD_DBVersion"                 //dataBase
#define kUD_NetEnvironmentConfig    @"UD_NetEnvironmentConfig"      //内外网环境配置
#define kUD_SaveLatelyPayType       @"UD_SaveLatelyPayType"         //保存最近一次使用的第三方支付方式

#define kUD_DPlusIMHostIPAndUpdateTime        @"UD_DPlusIMHostIPAndUpdateTime"          //d+ IM host
#define kUD_DPlusIMVideoIPAndUpdateTime       @"UD_DPlusIMVideoIPAndUpdateTime"         //d+ IM video
#define kUD_DPlusIMLoadFileIPAndUpdateTime    @"UD_DPlusIMLoadFileIPAndUpdateTime"      //d+ IM file
#define kUD_DPlusIMImgIPAndUpdateTime         @"UD_DPlusIMImgIPAndUpdateTime"           //d+ IM img
#define kUD_DPlusIMUploadFileIPAndUpdateTime  @"UD_DPlusIMUploadFileIPAndUpdateTime"    //d+ IM upload file
#define kUD_DPlusUpdateIPAndUpdateTime        @"UD_DPlusUpdateIPAndUpdateTime"          //d+ 更新

#define kNC_ReceiveContacts             @"NC_ReceiveContacts"       //收到添加好友
#define kNC_ReceiveGroupNotification    @"NC_ReceiveGroupNotification"  //收到群通知
#define kNC_DeleteMessages              @"NC_DeleteMessages"        //删除聊天记录
#define kNc_ReceiveGoodluck             @"Nc_ReceiveGoodluck"       //收到获奖消息
#define KNC_ReceiveGetGoods             @"NC_ReceiveGetGoods"       //收到自己获奖消息
#define kNC_ReceiveFileResult           @"NC_ReceiveFileResult"     //收到文件发送结果
#define kNC_MemberInfoChange            @"NC_MemberInfoChange"      //收到成员信息改变
#define kNC_GroupInfoChange             @"NC_GroupInfoChange"       //收到群信息改变
#define KNC_GroupInfoSync               @"KNC_GroupInfoSync"        //pc群设置同步
#define KNC_FileOverSize                @"NC_FileOverSize"          //发送文件过大
#define KNC_ReceiveChatCalling          @"NC_ChatCalling"           //视频音频通话聊天
#define KNC_MessageChatCalling          @"NC_MessageCalling"           //视频音频通话聊天
#define KNC_ChatConnected               @"NC_ChatConnected"           //已连接视频音频通话聊天
#define kNC_UpdateAllSession            @"NC_UpdateAllSession"      //收到连续更新session消息
#define kNC_RepalyReceiveChatCalling    @"NC_RepalyReceiveChatCalling" //在回看页面收到视频语音通话

#define kNc_ReceiveRestrict             @"NC_ReceiveRestrict"       //收到撤回消息

#define kNC_GroupNameDidChange     @"NC_GroupNameDidChange"         //群名称被修改
#define kNC_GroupAdminDidChange     @"NC_GroupAdminDidChange"       //群管理员被修改
#define KNC_StopScrollTableView    @"NC_TableViewStopScroll"        //修改群名禁止tableview 滑动
#define kNC_AddGroup               @"NC_AddGroup"                   //加入或创建了一个群
#define kNC_FriendNameDidChange    @"kNC_FriendNameDidChange"       //好友备注被修改
#define kNC_quitGroup              @"NC_quitGroup"                  //退群
#define KNC_DissolveGroupByselfFromPC          @"KNC_DissolveGroupByselfFromPC" //自己解散群
#define KNC_DissolveGroup          @"KNC_DissolveGroup"             // 群被解散

#define kNC_DeleteFriend           @"NC_DeleteFriend"               //删除好友
#define kNC_FriendPacketDidChanged @"NC_PacketDidChanged"           //好友分组被改变
#define kNC_GroupDownloadComplete  @"NC_GroupDownloadComplete"      //群下载完成
#define kNC_FriendDidDeleted       @"NC_FriendDidDeleted"           //好友被删除
#define kNC_friendDidAddCompleted  @"KNC_friendDidAddCompleted"     //对方已经通过申请

#define kNC_LoginIM                @"NC_LoginIM"                //IM 登录
#define kNC_LoginIMSuccess         @"NC_LoginIMSuccess"         //IM 登录成功
#define kNC_DisconnectIM           @"NC_DisconnectIM"           //IM 退出
#define kNC_GetKeywordsSuccess     @"NC_GetKeywordsSuccess"     //获取关键词成功

#define kNC_LatestAnnouncedSuccess      @"NC_LatestAnnouncedSuccess"    //获取即将揭晓数据成功
#define KNC_DetailGetLatestAnnounced    @"NC_DetailGetLatestAnnounced"  //揭晓结果后再详情界面接受成功通知

#define kNC_LiveRoomClickUserAvatar     @"NC_LiveRoomClickUserAvatar"

#define kNC_LiveRoomUserWeb         @"NC_LiveRoomUserWeb"  //记录进入的直播间UserWeb
#define KNC_ReceiveMessageRefresh          @"KNC_MessageRefresh" //
#define kNc_ReceiveRedPacket             @"NC_ReceiveRedPacket"       //收到领取红包

///////////////动态评论////////////////////
#define kNC_DynamicListHighlight   @"NC_DynamicListHighlight"//动态列表高亮
#define kNC_DynamicReplyHighlight   @"NC_DynamicReplyHighlight"//动态评论高亮
#define kNC_DynamicDetailReplyHighlight   @"NC_DynamicDetailReplyHighlight"//动态评论高亮
#define kNC_PublishDynamic   @"NC_PublishDynamic"//动态发布
#define kNC_DynamicComment   @"NC_DynamicComment"//动态评论
#define kNC_DeleteDynamic    @"NC_DeleteDynamic"//删除动态
#define kNC_ChangesDynamic   @"NC_ChangesDynamic"//动态改变
#define kNC_ExpandDynamic    @"NC_ExpandDynamic"//动态展开


//IM生成设备唯一码
#define kUD_DeviceID @"UD_DeviceID"
#define kUD_WordFilterVersion @"UD_WordFilterVersion"//7 提示性词 版本号
#define kUD_WordFilterVersion1 @"UD_WordFilterVersion1"//8 广告词 版本号
#define kUD_TCPServerID [NSString stringWithFormat:@"UD_TCPServerID_%@",[YGTCPUserManager sharedManager].userID]        //用户tcp服务器


#define AddressBookUpdataTime   [NSString stringWithFormat:@"AddressBookUpdataTime_%@",[YGTCPUserManager sharedManager].userID]

#define kIM_BlockedContacts     [NSString stringWithFormat:@"IM_BlockedContacts_%@",[YGTCPUserManager sharedManager].userID]    //被屏蔽的联系人
#define kIM_NoRemindGroups      [NSString stringWithFormat:@"IM_NoRemindGroups_%@",[YGTCPUserManager sharedManager].userID]     //消息不打扰联系人

#pragma mark - Block Typedef

typedef void(^CompleteBlock)(void);

typedef void(^ChangeInfo)(id obj);

typedef void(^ResultBlock)(BOOL result);

typedef void (^numberBlock)(NSInteger number);

typedef void(^errorBlock)(NSError *error);

#endif
