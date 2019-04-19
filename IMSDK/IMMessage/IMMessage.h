//
//  YGMessageModel.h
//  IM
//
//  Created by jiangxincai on 15/5/8.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//


#import "YGAPIHandleManager.h"
#import "YGChatConstant.h"
#import <UIKit/UIKit.h>


//@class FMResultSet;

@interface IMMessage :  NSObject


/**
 协议属性
 */
@property (copy, nonatomic) NSString *senderID;


/**
 收到对象的id
 */
@property (copy, nonatomic) NSString *recevierID;


/**
 发送信息id，格式为时间
 */
@property (nonatomic, copy) NSString *messageID;


/**
 发送者头像
 */
@property (nonatomic, copy) NSString *senderAvatar;


/**
 发送者名称
 */
@property (nonatomic, copy) NSString *senderName;

@property (copy, nonatomic) NSDate *date;

@property (copy, nonatomic) NSString *text;



//聊天类型
@property (assign, nonatomic) YGMessageType type;
//消息内容类型
@property (assign, nonatomic) YGMessageContentType contentType;
//消息状态
@property (assign, nonatomic) ChatMessageStatus msgStatus;

//图片消息大图名、语音消息文件名
@property (copy, nonatomic) NSString *mediaName;
// 图片宽度
@property (assign,nonatomic) NSInteger imageWidth;
// 图片高度
@property (assign,nonatomic) NSInteger imageHeight;
//是否显示时间
//语音时长
@property (nonatomic, assign) float currentTime;
//预览图名字
@property (nonatomic, copy) NSString *previewImageName;

//是否阅读过
@property (nonatomic, assign) BOOL messageIsNotRead;

@property (assign, nonatomic) BOOL isDisplayTime;
//--------长消息-------------
@property (nonatomic,assign) int part_total;    //总段数
@property (nonatomic,assign) int part_order;    //段序号

//--------评价---------------

@property (nonatomic, copy) NSString *evalId;                       //评价ID
@property (nonatomic, assign) EvaluationResult evaluationResult;    //评价结果

//---------商品--------------
@property (nonatomic, copy) NSString *goodsId;      //商品ID
@property (nonatomic, copy)NSString *goodsPic;      //商品图片
@property (nonatomic, copy) NSString *goodsName;    //商品名称
@property (nonatomic, assign)double goodsPrice;     //商品价格
@property (nonatomic, copy) NSString *mfrontUrl;    //买家版商品前台URL
@property (nonatomic, copy)NSString *afterUrl;      //商品后台URL

//---------订单---------------
//OrderBody:{orderno:订单号，ordertime:下单时间，h5fronturl:卖家版订单前台URL，mfronturl:买家版订单前台URL，afterurl:订单后台URL，goodspic:商品图片，goodsname:商品名称，goodsprice:商品价格，skuname:sku名称}
@property (nonatomic,copy)NSString *orderNo;      //订单号
@property (nonatomic,copy)NSString *orderTime;    //下单时间
@property (nonatomic,copy)NSString *h5frontUrl;      //卖家版订单前台URL
@property (nonatomic,copy)NSString *skuName;      //sku名称

//---------售后--------------
//CustomBody:{customno:售后编号，customtimne:申请时间，fronturl:售后前台URL，afterurl:售后后台URL，goodspic:商品图片，goodsname:商品名称，goodsprice:商品价格，skuname: sku名称}
@property (nonatomic,copy)NSString *customNo;    //售后编号
@property (nonatomic,copy)NSString *customTime;  //申请时间

// 拓展
@property (nonatomic,strong)id extentBody;


/**
 *  根据缓存DB的数据初始化
 *
 *  @param rs 数据集合
 *
 *  @return 返回初始化好的对象
 */
//-(id) initWithDBResultSet:(FMResultSet *) rs;







#pragma mark - 非通知类消息实例化


/**
 *  提示新消息实例化
 *
 *  @param sessionJID
 *  @param date       最上一条时间
 *  @param type       类型
 *
 *  @return 消息
 */
//- (instancetype)initRemindNewMessageWithSessionJID:(NSString *)sessionJID date:(NSDate *)date type:(YGMessageType)type;


#pragma mark - Extension

//消息撤回信息提示
//- (instancetype)initWithRetractMagWithSessionJID:(NSString*)sessionJID messageType:(YGMessageType)messageType text:(NSString *)text Time:(NSString *)time MessageID:(NSString *)messageId;



/**
 初始化图片消息

 @param fullImageName 大图名称
 @param thumbImageName 预览图名称
 @param size      图片尺寸
 @return IMMessage
 */
- (instancetype)initMessageWithFullImage:(NSString *)fullImageName
                            PreviewImage:(NSString *)thumbImageName
                               ImageSize:(CGSize)size;


/**
 初始化文本消息

 @param text 文本
 @return IMMessage
 */
- (instancetype)initMessageWithText:(NSString *)text;


/**
 初始化语音消息

 @param audioName  语音文件名
 @param duration 语音时长
 @return IMMessage
 */
- (instancetype)initMessageWithAudio:(NSString *)audioName 
                            Duration:(long)duration;


/**
 初始化评价消息
 @param Id 评价ID
 @param result 评价结果
 @return IMMessage
 */
- (instancetype)initMessagewithEvaluationID:(NSString *)Id Result:(EvaluationResult)result;



/**
 初始化商品消息

 @param goodsid 商品ID
 @param goodsPic 商品图片
 @param goodsName 商品名称
 @param goodsPrice 商品价格
 @param frontUrl 买家版商品前台URL
 @param afterUrl 商品后台URL
 @return IMMessage
 */
- (instancetype)initMessagewithCommondityID:(NSString *)goodsid
                                    Goodspic:(NSString *)goodsPic
                                   GoodsName:(NSString *)goodsName
                                 GoodsPrice:(double)goodsPrice
                                   Fronturl:(NSString *)frontUrl
                                   Afterurl:(NSString *)afterUrl;



/**
 初始化订单消息

 @param orderno 订单号
 @param orderTime 下单时间
 @param h5frontUrl 卖家版订单前台URL
 @param frontUrl 买家版订单前台URL
 @param afterUrl 订单后台URL
 @param goodsPic 商品图片
 @param goodsName 商品名称
 @param goodsPrice 商品价格
 @param skuName sku名称
 @return IMMessage
 */
- (instancetype)initMessagewithOrder:(NSString *)orderNo
                           OrderTime:(NSString *)orderTime
                          H5fronturl:(NSString *)h5frontUrl
                            Fronturl:(NSString *)frontUrl
                            Afterurl:(NSString *)afterUrl
                            Goodspic:(NSString *)goodsPic
                           GoodsName:(NSString *)goodsName
                          GoodsPrice:(double)goodsPrice
                             SkuName:(NSString *)skuName;


/**
 初始化售后消息
 
 @param customNo 售后编号
 @param customTime 时间
 @param frontUrl 买家版订单前台URL
 @param afterUrl 订单后台URL
 @param goodsPic 商品图片
 @param goodsName 商品名称
 @param goodsPrice 商品价格
 @param skuName sku名称
 @return IMMessage
 */
- (instancetype)initMessagewithCustom:(NSString *)customNo
                           CustomTimne:(NSString *)customTime
                            Fronturl:(NSString *)frontUrl
                            Afterurl:(NSString *)afterUrl
                            Goodspic:(NSString *)goodsPic
                           GoodsName:(NSString *)goodsName
                          GoodsPrice:(double)goodsPrice
                             SkuName:(NSString *)skuName;



/**
 初始化扩展消息

 @param extentBody 扩展内容
 @return IMMessage
 */
- (instancetype)initMessagewithExtent:(id)extentBody;


/**
 字典初始化消息

 @param dic 字典
 @return IMMessage
 */
- (instancetype)initMessageWithDictionary:(NSDictionary *)dic;
@end
