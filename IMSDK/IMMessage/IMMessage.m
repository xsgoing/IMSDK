//
//  YGMessageModel.m
//  IM
//
//  Created by jiangxincai on 15/5/8.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "IMMessage.h"
//#import "FMDatabase.h"
#import "YGTimeUtils.h"

#import "IMClient.h"

//#import "YGIMDataBaseManager.h"
@implementation IMMessage

/**
 初始化图片消息
 
 @param fullImageName 大图名称
 @param thumbImageName 预览图名称
 @return IMMessage
 */
- (instancetype)initMessageWithFullImage:(NSString *)fullImageName
                            PreviewImage:(NSString *)thumbImageName
                               ImageSize:(CGSize)size{
    NSParameterAssert(fullImageName!= nil);
    NSParameterAssert(thumbImageName!= nil);
    self = [super init];
    if (self) {
        
        self.previewImageName = thumbImageName;
        self.mediaName = fullImageName;
        self.imageWidth = size.width;
        self.imageHeight = size.height;
        self.contentType = YGMessageContentTypeImage;
        self.messageID = [YGTimeUtils messageID];
    }
    return self;
}

/**
 初始化文本消息
 
 @param text 文本
 @return IMMessage
 */
- (instancetype)initMessageWithText:(NSString *)text {
    
    NSParameterAssert(text!= nil);
    self = [super init];
    if (self) {
        self.text = text;
        self.contentType = YGMessageContentTypeText;
        self.messageID = [YGTimeUtils messageID];
        NSMutableArray *textArray = [NSMutableArray new];
        NSInteger count = text.length/IMServiceMostSendTextLength + 1;
        if (count == 1) {

        } else {
            self.contentType = YGMessageContentTypeLongText;
        }
    }
    return self;
}


/**
 初始化语音消息
 
 @param audioName  语音文件名
 @param duration 语音时长
 @return IMMessage
 */
- (instancetype)initMessageWithAudio:(NSString *)audioName Duration:(long)duration {
 
    NSParameterAssert(audioName!= nil);
    NSParameterAssert(duration > 0);
    self = [super init];
    if (self) {
        
        self.mediaName = audioName;
        self.currentTime = duration;
        self.contentType = YGMessageContentTypeAudio;
        self.messageID = [YGTimeUtils messageID];
    }
    return self;
}

/**
 初始化评价消息
 
 @param result 评价结果
 @return IMMessage
 */
- (instancetype)initMessagewithEvaluationID:(NSString *)Id Result:(EvaluationResult)result {
    
    NSParameterAssert(result!=0);
    NSParameterAssert(Id!=nil);
    self = [super init];
    if (self) {
        
        self.evaluationResult = result;
        self.evalId = Id;
        self.messageID = [YGTimeUtils messageID];
        self.contentType = YGMessageContentTypeEvaluation;
    }
    return self;
}

- (instancetype)initMessagewithCommondityID:(NSString *)goodsid
                                   Goodspic:(NSString *)goodsPic
                                  GoodsName:(NSString *)goodsName
                                 GoodsPrice:(double)goodsPrice
                                   Fronturl:(NSString *)frontUrl
                                   Afterurl:(NSString *)afterUrl
{
    NSParameterAssert(goodsid != nil);
    NSParameterAssert(goodsPic != nil);
    NSParameterAssert(goodsName != nil);
    NSParameterAssert(frontUrl != nil);
    NSParameterAssert(afterUrl != nil);
    
    self = [super init];
    if (self) {
        
        self.goodsId = goodsid;
        self.goodsPic = goodsPic;
        self.goodsName = goodsName;
        self.goodsPrice = goodsPrice;
        self.mfrontUrl = frontUrl;
        self.afterUrl = afterUrl;
        self.messageID = [YGTimeUtils messageID];
          self.contentType = YGMessageContentTypeCommodity;
    }
    return self;
}


- (instancetype)initMessagewithOrder:(NSString *)orderNo OrderTime:(NSString *)orderTime H5fronturl:(NSString *)h5frontUrl Fronturl:(NSString *)frontUrl Afterurl:(NSString *)afterUrl Goodspic:(NSString *)goodsPic GoodsName:(NSString *)goodsName GoodsPrice:(double)goodsPrice SkuName:(NSString *)skuName {
    
    NSParameterAssert(orderNo != nil);
    NSParameterAssert(orderTime != nil);
    NSParameterAssert(h5frontUrl != nil);
    NSParameterAssert(frontUrl != nil);
    NSParameterAssert(afterUrl != nil);
    NSParameterAssert(goodsPic != nil);
    NSParameterAssert(goodsName != nil);
    NSParameterAssert(skuName != nil);
    
    self = [super init];
    if (self) {
        
        self.orderNo = orderNo;
        self.orderTime = orderTime;
        self.h5frontUrl = h5frontUrl;
        self.mfrontUrl = frontUrl;
        self.afterUrl = afterUrl;
        self.goodsPic = goodsPic;
        self.goodsName = goodsName;
        self.goodsPrice = goodsPrice;
        self.skuName = skuName;
        self.messageID = [YGTimeUtils messageID];
          self.contentType = YGMessageContentTypeOrder;
    }
    return self;
}

- (instancetype)initMessagewithCustom:(NSString *)customNo
                          CustomTimne:(NSString *)customTime
                             Fronturl:(NSString *)frontUrl
                             Afterurl:(NSString *)afterUrl
                             Goodspic:(NSString *)goodsPic
                            GoodsName:(NSString *)goodsName
                           GoodsPrice:(double)goodsPrice
                              SkuName:(NSString *)skuName {
    
    NSParameterAssert(customNo != nil);
    NSParameterAssert(customTime != nil);
    NSParameterAssert(frontUrl != nil);
    NSParameterAssert(afterUrl != nil);
    NSParameterAssert(goodsPic != nil);
    NSParameterAssert(goodsName != nil);
    NSParameterAssert(skuName != nil);
    
    self = [super init];
    if (self) {
        
        self.customNo = customNo;
        self.customTime = customTime;
        self.mfrontUrl = frontUrl;
        self.afterUrl = afterUrl;
        self.goodsPic = goodsPic;
        self.goodsName = goodsName;
        self.goodsPrice = goodsPrice;
        self.skuName = skuName;
        self.messageID = [YGTimeUtils messageID];
          self.contentType = YGMessageContentTypeCustom;
    }
    return self;
}

- (instancetype)initMessagewithExtent:(id)extentBody {
    
    NSParameterAssert(extentBody != nil);
  
    self = [super init];
    if (self) {

        self.extentBody = extentBody;
        self.messageID = [YGTimeUtils messageID];
          self.contentType = YGMessageContentTypeExtend;
    }
    return self;
}


- (id)init
{
    NSAssert(NO, @"%s is not a valid initializer for %@.", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

- (void)dealloc
{
    _senderID = nil;
    
    _date = nil;
    _text = nil;
    
}

- (NSUInteger)messageHash
{
    return self.hash;
}


- (instancetype)initMessageWithDictionary:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
