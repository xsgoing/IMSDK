//
//  YGTimeUtils.m
//  IMDB
//
//  Created by xk on 15/5/7.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGTimeUtils.h"
#import "YGUtilities.h"
@implementation YGTimeUtils

/**
 *  获得时间 （格式 : HH:mm:ss）
 *
 
 */
+(NSString *) getTimeWithLonglongDate:(long long) datelonglong
{
    NSString *timeStr = nil;
    NSDate *dateTime =[NSDate dateWithTimeIntervalSince1970:datelonglong];
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm:ss"];
        timeStr = [format stringFromDate:dateTime];
    }
    return timeStr;
    
}

/**
 *  获得时间 （格式 : HH:mm:ss.SSS）
 *
 
 */
+(NSString *) getTimeWithLonglongMillisecondDate:(NSDate *) date
{
    NSString *timeStr = nil;
    if (date != nil) {
        NSDateFormatter *dateFormatter = [self new_millisecondDateFormattter];
        timeStr = [dateFormatter stringFromDate:date];
    }
    return timeStr;
    
}


/**
 *  获得当前时间戳的double类型时间
 *
 *  @return 返回当前时间的double 类型
 */
+(NSTimeInterval) getCurrentTimeDouble
{
    NSDate *nowUTC = [NSDate date];
    
    NSTimeInterval timeSpDouble = [nowUTC timeIntervalSince1970];
    
    return timeSpDouble;
}

/**
 *  获得当前时间戳的long long 类型时间
 *
 *  @return 返回当前时间的long long 类型
 */
+(long long) getCurrentTimeLongLong
{
    NSDate *nowUTC = [NSDate date];
    NSTimeInterval time = [nowUTC timeIntervalSince1970];
    long long timeSpLongLong = [[NSNumber numberWithDouble:time] longLongValue];
    
    return timeSpLongLong;
}

/**
 *  获得当前毫秒时间戳的long long 类型时间
 *
 *  @return 返回当前时间的long long 类型
 */
+(long long) getCurrentMilliSecondLongLong
{
    NSDate *nowUTC = [NSDate date];
    NSTimeInterval time = [nowUTC timeIntervalSince1970] * 1000;
    long long timeSpLongLong = [[NSNumber numberWithDouble:time] longLongValue];
    
    return timeSpLongLong;
}

/**
 *  返回long long时间类型
 *
 *  @param dateTime 时间转换成long long
 *
 *  @return 返回long long时间类型
 */
+(long long) getDateTimeToLongLong:(NSDate *) dateTime
{
    long long timeSpLongLong = 0;
    
    if (dateTime) {
        
        NSTimeInterval time = [dateTime timeIntervalSince1970];
        
        // 当前时间转换成long long类型
        timeSpLongLong = [[NSNumber numberWithDouble:time] longLongValue];
    }
    
    return timeSpLongLong;
}

/**
 *  获得当前时间 (返回时间格式 : yyyy-MM-dd hh:mm:ss)
 */
+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [format stringFromDate:nowUTC];
    
    return dateString;
}



/**
 获得当前时间
 */
+(NSDate *) getCurrentTimeDate
{
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return nowUTC;
}


/**
 字符串转换成时间类型
 */
+(NSDate *) getStringToDate:(NSString *) dateTimeStr
{
    NSDate *resultDate = nil;
    if (dateTimeStr != nil && [dateTimeStr length] > 0) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        resultDate = [format dateFromString:dateTimeStr];
    }
    return resultDate;
}

/**
 字符串转换成时间类型
 */
+(NSDate *) getTStringToDate:(NSString *) dateTimeStr
{
    NSDate *resultDate = nil;
    if (dateTimeStr != nil && [dateTimeStr length] > 0) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        resultDate = [format dateFromString:dateTimeStr];
    }
    return resultDate;
}


/**
 字符串转换成时间类型,没有小时 分钟 秒
 dateTimeStr字符串格式(yyyy-MM-dd)
 */
+(NSDate *) getStringToDateWithOutHMS:(NSString *) dateTimeStr
{
    NSDate *resultDate = nil;
    
    if (dateTimeStr != nil && [dateTimeStr length] > 0) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        resultDate = [format dateFromString:dateTimeStr];
    }
    return resultDate;
}

/**
 时间转换成字符串
 返回的字符串格式 : yyyy-MM-dd HH:mm:ss
 */
+(NSString *) getDateToString:(NSDate *) dateTime
{
    NSString *dateString = nil;
    
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString = [format stringFromDate:dateTime];
    }
    return dateString;
}
+(NSString *)getDateToString:(NSDate *)date Format:(NSString *)formatStr {
    NSString *dateString = nil;
    
    if (date != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:formatStr];
        dateString = [format stringFromDate:date];
    }
    return dateString;
}

/**
 时间转换成字符串
 返回的字符串格式 : yyyy/MM/dd HH:mm:ss
 */
+(NSString *) getDateToStr:(NSDate *) dateTime
{
    NSString *dateString = nil;
    
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        dateString = [format stringFromDate:dateTime];
    }
    return dateString;
}

/**
 时间转换成字符串 没有小时 分钟 秒
 返回的字符串格式 : yyyy-MM-dd
 */
+(NSString *) getDateToStringWithOutHMS:(NSDate *) dateTime
{
    NSString *dateString = nil;
    
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        dateString = [format stringFromDate:dateTime];
    }
    return dateString;
}

+(NSString *) getDateToStringWithOutS:(NSDate *) dateTime {
    
    NSString *dateString = nil;
    
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
        dateString = [format stringFromDate:dateTime];
    }
    return dateString;
}


/**
 *  返回long long时间类型
 *
 *  @param dateTimeStr字符串格式(yyyy-MM-dd HH:mm:ss)
 *
 *  @return 返回long long时间类型
 */
+(long long) getDateTimeStrToLongLong:(NSString *) dateTimeStr
{
    return [self getDateTimeToLongLong:[self getStringToDate:dateTimeStr]];
}

 /**
   2  * @method
   3  *
   4  * @brief 获取两个日期之间的天数
   5  * @param fromDate       起始日期
   6  * @param toDate         终止日期
   7  * @return    总天数
   8  */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}


/**
 去掉毫秒
 */

+ (NSString *)wipeOutSSS:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *destDate= [dateFormatter dateFromString:date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter1 stringFromDate:destDate];
    NSString *timerStr = [NSString stringWithFormat:@"%@", destDateString];
    return timerStr;
}


//IM
+ (NSString *)messageID {
    NSDate *bDate = [NSDate date];
    NSTimeInterval timestamp = [bDate timeIntervalSince1970] * 1000 * 1000;
    NSInteger dTime = timestamp;
    return [@(dTime).stringValue stringByAppendingString:[YGUtilities randomID]];
}

+ (NSString*)messageIDForSecond {
    NSDate *bDate = [NSDate date];
    NSTimeInterval time = [bDate timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    return @(dTime).stringValue;
}


+ (NSString*)serverTimeWithlastDate:(NSDate*)lastDate{
    if (lastDate) {
        NSDateFormatter *dateFormatter = [self millisecondDateFormattter];
        NSString *dateString = [dateFormatter stringFromDate:lastDate];
        return dateString;
    } else {
        return @"";
    }
}

+ (NSDate*)messageDateWithMessageID:(NSString*)messageID{
    long long aaa =messageID.longLongValue/1000;
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:aaa];
    return aDate;
}

+ (NSDate*)messageDateWithMessageTime:(NSString*)messageTime {
    if (!messageTime || !messageTime.length) {
        return [NSDate date];
    }
    NSDateFormatter *dateFormatter1 = [self millisecondDateFormattter];
    NSDateFormatter *dateFormatter2 = [self secondDateFormattter];
    NSDateFormatter *dateFormatter3 = [self millisecondDateFormattterWithT];
    NSDateFormatter *dateFormatter4 = [self millisecondDateFormattterWithT1];
    NSDate *aDate = [dateFormatter1 dateFromString:messageTime];
    if (!aDate) {
        aDate = [dateFormatter2 dateFromString:messageTime];
    }
    if (!aDate) {
        aDate = [dateFormatter3 dateFromString:messageTime];
    }
    if (!aDate) {
        aDate = [dateFormatter4 dateFromString:messageTime];
    }
    if (!aDate) {
        aDate = [NSDate date];
    }
    
    return aDate;
}


#pragma mark - DateFormattter

/**
 *  秒的NSDateFormatter
 *
 *  @return formate
 */
+ (NSDateFormatter *)secondDateFormattter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    });
    return dateFormatter;
}

/**
 *  毫秒的NSDateFormatter
 *
 *  @return formate
 */
+ (NSDateFormatter *)millisecondDateFormattter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    });
    return dateFormatter;
}

/**
 *  毫秒的NSDateFormatter
 *
 *  @return formate
 */
+ (NSDateFormatter *)new_millisecondDateFormattter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)millisecondDateFormattterWithT {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    });
    return dateFormatter;
}
+ (NSDateFormatter *)millisecondDateFormattterWithT1 {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    });
    return dateFormatter;
}

//+ (NSString *)returnHistorySessionTimeWithDate:(NSDate *)date {
//    NSString *timeString;
//    if ([date isToday]) {
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else if ([date isYesterday]){
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        timeString = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
////        timeString = @"昨天";
//    } else if ([date isThisYear]){
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"M月d日"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else{
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    }
//
//    return timeString;
//}

//+ (NSString *)returnSessionTimeWithDate:(NSDate *)date{
//    NSString *timeString;
//    if ([date isToday]) {
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else if ([date isYesterday]){
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        timeString = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
//    } else if ([date isThisYear]){
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM/dd HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else{
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    }
//
//    return timeString;
//}

/**
 *
 *  @param dateTime 时间转换成long long
 *
 *  @return 返回float 天数
 */
+ (float)getUpdataDayWithDate:(NSDate *)theDate{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[NSDate dateWithTimeInterval:1 sinceDate:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    //1428391592.7012141
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        
        if ([timeString intValue] < 1)
            timeString = @"刚刚";
        else
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    
    return cha/86400;
}

//传入 秒
+(NSString *)getHHMMSSFromSS:(NSInteger )seconds{

    if (seconds>=60*60) {//得到 xx:xx:xx
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        
        return format_time;
    } else {//得到  xx:xx
        
        NSString *str_minute = seconds/60>9? [NSString stringWithFormat:@"%ld",seconds/60]:[NSString stringWithFormat:@"0%ld",seconds/60];
        NSString *str_second = seconds%60>9? [NSString stringWithFormat:@"%ld",seconds%60]:[NSString stringWithFormat:@"0%ld",seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
        return format_time;
    }

}

+(NSString*) isTodayString:(NSString*) str
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[self getCurrentTimeDate]];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    NSString* today = [NSString stringWithFormat:@"%ld%ld%ld",year,month,day];
    NSString* yesterday = [NSString stringWithFormat:@"%ld%ld%ld",year,month,day-1];
    if ([today isEqualToString:str]) {
        return @"今天";
    }
    return str;
}
/**
 服务器时间格式，用于离线消息
 
 @param dateTime Date
 @return 时间字符串
 */
+(NSString *)getDateToServerString:(NSDate *)dateTime {
    
    NSString *dateString = nil;
    
    if (dateTime != nil) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        dateString = [format stringFromDate:dateTime];
    }
    return dateString;
}

/**
 获取多少天以前的时间
 
 @param count 天数
 @param date 起始时间
 @return  获取多少天以前的时间
 */
+ (NSDate *)getDaysAgo:(NSUInteger)count FromDate:(NSDate *)date {
    
    NSDate* theDate;
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    
    theDate = [date initWithTimeIntervalSinceNow: -oneDay*count];
    
    return theDate;
   
}

//+ (NSString *)returnSentReceiveRedPacketTimeWithDate:(NSDate *)date {
//    NSString *timeString;
//    if ([date isToday]) {
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else if ([date isYesterday]){
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        timeString = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
//        //        timeString = @"昨天";
//    } else if ([date isThisYear]){
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
//        timeString = [dateFormatter stringFromDate:date];
//    } else{
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        timeString = [dateFormatter stringFromDate:date];
//    }
//    
//    return timeString;
//}

//传入 秒
+(NSString *)getRedPacketHHMMSSFromSS:(NSInteger )seconds{
    
    if (seconds>=60*60) {//得到 xx:xx:xx
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
        
        return format_time;
    } else if(seconds>60){//得到  xx:xx
        
        NSString *str_minute = seconds/60>9? [NSString stringWithFormat:@"%ld",seconds/60]:[NSString stringWithFormat:@"0%ld",seconds/60];
        NSString *str_second = seconds%60>9? [NSString stringWithFormat:@"%ld",seconds%60]:[NSString stringWithFormat:@"0%ld",seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
        
        return format_time;
    }else{
        NSString *format_time = [NSString stringWithFormat:@"%ld秒",seconds];
        return format_time;
    }
    
}

@end
