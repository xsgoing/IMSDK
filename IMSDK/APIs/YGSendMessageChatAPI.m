//
//  YGSendMessageChatAPI.m
//  IM
//
//  Created by jiangxincai on 15/4/15.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//


#import "IMMessage.h"
#import "YGTimeUtils.h"
#import "YGUtilities.h"
#import "YGSendMessageChatAPI.h"


@interface YGSendMessageChatAPI ()


@property (nonatomic, assign) NSUInteger order;

@property (nonatomic, copy) NSString *subType;


@end

@implementation YGSendMessageChatAPI



- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary{
    
    int code = [dictionary[MESSAGEPROTOCOL_CODE] intValue];
    
    if (code!=0) {
        
        return [NSError errorWithDomain:dictionary[@"error"] code:code userInfo:nil];
    }
    NSString *msgTime = dictionary[@"time"];
    self.returnTime = [YGTimeUtils messageDateWithMessageTime:msgTime];
    return self.returnTime;
}

- (NSInteger)numberOfTimeOutRetries {
    return 3;
}

- (NSInteger)requestTimeOutTimeInterval {
    return 8;
}

- (NSDictionary*)creatPackageDictionaryWithObject:(id)object {
    
    self.message = (IMMessage *)object;
    self.randomID = self.message.messageID;
    if (self.isNeedPartPackage) {
        self.randomID = [YGTimeUtils messageID];
        self.order = self.message.part_order;
    }
    
    
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                @{
                                  @"api": @"Message",
                                  @"apiId": @"1003",
                                  @"id": self.randomID,
                                  @"from": self.message.senderID,
                                  @"appName":STR_IS_NULL([IMClient sharedClient].appName),
                                  @"to": self.message.recevierID,
                                  @"data":[self dataDictionayWithObj:object],
                                  
                                  }];
    
    
   
    
    return dic;
}

- (NSDictionary *)dataDictionayWithObj:(id)object {
    
    NSMutableDictionary *mDic;
    
   

        NSDictionary *dic = @{
                              @"type":  @"chat",
                              @"chatType" : @"0",   // 1.陌生人，0.好友, 2.临时
                              @"subType":self.subType,
                              @"body":[self bodyDictionaryWithObject:object],
                              @"time": @"",
                              @"senderInfo": @{
                                      @"userName":STR_IS_NULL(self.message.senderName),
                                      @"photo":STR_IS_NULL(self.message.senderAvatar)
                                      },

                              };
         mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    

    
    return mDic;
}



- (NSString *)subType {

    switch (self.message.contentType) {
        case  YGMessageContentTypeText: //文字消息
            return @"txt";
            break;
        case  YGMessageContentTypeImage: //图片消息
            return @"img";
            break;
        case  YGMessageContentTypeAudio: //语音消息
            return @"audio";
            break;
        case  YGMessageContentTypeVideo: //视频消息
            return @"video";
            break;
        case  YGMessageContentTypeShortVideo: //小视频消息
            return @"smallVideo";
            break;
        case  YGMessageContentTypeImFile: //文件消息
            return @"file";
            break;

        case  YGMessageContentTypeMediaCall: //语音聊天
            return @"call";
            break;
        case YGMessageContentTypeRetract:   // 撤回
            return @"retract";
            break;
        case YGMessageContentTypeLongText:  // 长文本
            return @"bigtxt";
            break;
        case YGMessageContentTypeRedPacket:  //红包
            return @"redEnvelopesSendOut";
            break;
        case YGMessageContentTypeEvaluation:// 评价
            return @"eval";
            break;
        case YGMessageContentTypeCommodity: //商品
            return @"goods";
            break;
        case YGMessageContentTypeOrder: //订单
            return @"order";
            break;
        case YGMessageContentTypeCustom: //售后
            return @"custom";
            break;
        case YGMessageContentTypeExtend: //扩展
            return @"extend";
            break;
        default:
            return @"txt";
            break;
    }
}

- (NSDictionary *)bodyDictionaryWithObject:(id)object {
    NSMutableDictionary *dic = nil;
    
    switch (self.message.contentType) {
        
        case YGMessageContentTypeImage: {
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{

                    @"id":self.message.mediaName,
                    @"smallId":self.message.previewImageName,//小图片路径
                    @"width":@(self.message.imageWidth),
                    @"height":@(self.message.imageHeight)
                    }
                   ];
        }
            break;
        case YGMessageContentTypeRetract: {
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"retractId":self.message.messageID,//撤回消息的id
                     }
                   ];
        }
            break;
        case YGMessageContentTypeLongText:{

            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"partName":[self partName],
                     @"partOrder":@([self partOrder]),
                     @"text":self.message.text,
                     @"partTotal":@([self partTotal])
                     }
                   ];

        }
            break;
      
        case  YGMessageContentTypeEvaluation: {
            
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"id":self.message.evalId,
                     @"type":@(2),
                     @"subtype":@(1),
                     @"result":@(self.message.evaluationResult)
                     }
                   ];
        }
            break;
        case  YGMessageContentTypeCommodity: {
            
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"goodsid":self.message.goodsId,
                     @"goodspic":self.message.goodsPic,
                     @"goodsname":self.message.goodsName,
                     @"goodsprice":@(self.message.goodsPrice),
                     @"mfronturl":self.message.mfrontUrl,
                     @"afterurl":self.message.afterUrl}
                   ];
        }
            break;
        case  YGMessageContentTypeOrder: {
        
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"orderno":self.message.orderNo,
                     @"ordertime":self.message.orderTime,
                     @"h5fronturl":self.message.h5frontUrl,
                     @"goodspic":self.message.goodsPic,
                     @"goodsname":self.message.goodsName,
                     @"goodsprice":@(self.message.goodsPrice),
                     @"mfronturl":self.message.mfrontUrl,
                     @"afterurl":self.message.afterUrl,
                     @"skuname":self.message.skuName
                     }
                   ];
        }
            break;
        case  YGMessageContentTypeCustom: {

            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"customno":self.message.customNo,
                     @"customtimne":self.message.customTime,
                     @"goodspic":self.message.goodsPic,
                     @"goodsname":self.message.goodsName,
                     @"goodsprice":@(self.message.goodsPrice),
                     @"fronturl":self.message.mfrontUrl,
                     @"afterurl":self.message.afterUrl}
                   ];
        }
            break;
        case  YGMessageContentTypeExtend: {
            
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"text":self.message.extentBody}
                   ];
        }
            break;
        default:
            dic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     @"text":self.message.text
                    }
                   ];

            break;
    }
    
    return dic;
}

- (BOOL)isNeedPartPackage {
    if (self.textArray.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)partName {
    return self.message.messageID;
}

- (NSUInteger)partOrder {
    return self.message.part_order;
}

- (NSUInteger)partTotal {
    return self.textArray.count;
}



@end
