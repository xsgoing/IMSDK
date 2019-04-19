//
//  YGTimeUtils.h
//  IMDB
//
//  Created by xk on 15/5/7.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGTimeUtils : NSObject


/**
 *  获得时间 （格式 : HH:mm:ss）
 */
+(NSString *) getTimeWithLonglongDate:(long long) datelonglong;

/**
 *  获得时间 （格式：HH:mm:ss.SSS）
 */
+(NSString *) getTimeWithLonglongMillisecondDate:(NSDate *) date;

/**
 *  获得当前时间戳的double类型时间
 *
 *  @return 返回当前时间的double 类型
 */
+(NSTimeInterval) getCurrentTimeDouble;

/**
 *  获得当前时间戳的long long 类型时间
 *
 *  @return 返回当前时间的long long 类型
 */
+(long long) getCurrentTimeLongLong;
/**
 *  获得当前毫秒时间戳的long long 类型时间
 *
 *  @return 返回当前时间的long long 类型
 */
+(long long) getCurrentMilliSecondLongLong;
/**
 *  返回long long时间类型
 *
 *  @param dateTime 时间转换成long long
 *
 *  @return 返回long long时间类型
 */
+(long long) getDateTimeToLongLong:(NSDate *) dateTime;

/**
 *  获得当前时间 (返回时间格式 : yyyy-MM-dd hh:mm:ss)
 */
+(NSString *)getCurrentTime;


/**
 获得当前时间
 */
+(NSDate *) getCurrentTimeDate;


/**
 字符串转换成时间类型,
 dateTimeStr字符串格式(yyyy-MM-dd HH:mm:ss)
 */
+(NSDate *) getStringToDate:(NSString *) dateTimeStr;

+(NSDate *) getTStringToDate:(NSString *) dateTimeStr;

/**
 字符串转换成时间类型,没有小时 分钟 秒
 dateTimeStr字符串格式(yyyy-MM-dd)
 */
+(NSDate *) getStringToDateWithOutHMS:(NSString *) dateTimeStr;



/**
 时间转换成字符串
 返回的字符串格式 : yyyy-MM-dd HH:mm:ss
 */
+(NSString *) getDateToString:(NSDate *) dateTime;

/**
 时间转换成字符串
 返回的字符串格式 : yyyy/MM/dd HH:mm:ss
 */
+(NSString *) getDateToStr:(NSDate *) dateTime;

+(NSString *)getDateToString:(NSDate *)date Format:(NSString *)formatStr;

/**
 时间转换成字符串 没有小时 分钟 秒
 返回的字符串格式 : yyyy-MM-dd
 */
+(NSString *) getDateToStringWithOutHMS:(NSDate *) dateTime;


/**
 时间转换成字符串 没有小时 分钟 秒
 返回的字符串格式 : yyyy-MM-dd HH:mm
 */
+(NSString *) getDateToStringWithOutS:(NSDate *) dateTime;

/**
 *  返回long long时间类型
 *
 *  @param dateTimeStr 字符串格式(yyyy-MM-dd HH:mm:ss)
 *
 *  @return 返回long long时间类型
 */
+(long long) getDateTimeStrToLongLong:(NSString *) dateTimeStr;


/**
 2  * @method
 3  *
 4  * @brief 获取两个日期之间的天数
 5  * @param fromDate       起始日期
 6  * @param toDate         终止日期
 7  * @return    总天数
 8  */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSString *)wipeOutSSS:(NSString *)date;




//IM
/**
 *  聊天消息请求id，获取当前时间到秒
 *
 *  @return 返回当前时间string到秒
 */
+ (NSString*)messageID;


/**
 *  第一次连接服务器加包时间戳，获取当前时间到秒
 *
 *  @return 返回当前时间string到秒
 */
+ (NSString*)messageIDForSecond;

/**
 *  获取服务器时间格式
 *
 *  @param lastDate 上一次请求的date
 *
 *  @return 时间string
 */
+ (NSString*)serverTimeWithlastDate:(NSDate*)lastDate;

/**
 *  通过聊天messageID获取nsdate
 *
 *  @param messageID 服务器回传的messageID
 *
 *  @return 收到消息时间
 */
+ (NSDate*)messageDateWithMessageID:(NSString*)messageID;

/**
 *  根据服务器返回的时间string获取nsdate
 *
 *  @param messageTime 时间string
 *
 *  @return 时间
 */
+ (NSDate*)messageDateWithMessageTime:(NSString*)messageTime;

/**
 *  @param theDate 时间转换成long long
 *
 *  @return 返回float 天数
 */
+ (float)getUpdataDayWithDate:(NSDate *)theDate;


/**
 *  session页面时间判断
 *
 *  @param date 消息时间
 *
 *  @return 返回时间stirng
 */
+ (NSString *)returnSessionTimeWithDate:(NSDate *)date;

+(NSString *)getHHMMSSFromSS:(NSInteger)totalTime;

/**
 *  历史消息页面时间判断
 *
 *  @param date 消息时间
 *
 *  @return 返回时间stirng
 */
+ (NSString *)returnHistorySessionTimeWithDate:(NSDate *)date;

+(NSString*) isTodayString:(NSString*) str;

/**
 服务器时间格式，用于离线消息

 @param dateTime Date
 @return 时间字符串
 */
+(NSString *)getDateToServerString:(NSDate *)dateTime;

/**
 获取多少天以前的时间

 @param count 天数
 @param date 起始时间
 @return  获取多少天以前的时间
 */
+ (NSDate *)getDaysAgo:(NSUInteger)count FromDate:(NSDate *)date;

+ (NSString *)returnSentReceiveRedPacketTimeWithDate:(NSDate *)date;

+(NSString *)getRedPacketHHMMSSFromSS:(NSInteger )seconds;

@end
