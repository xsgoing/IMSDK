//
//  Utilities.m
//  mobile
//
//  Created by xk on 14-11-19.
//  Copyright (c) 2014年 1yyg. All rights reserved.
//

#import "YGUtilities.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+DTBase64.h"
#import "YGTimeUtils.h"
#import "IMReachabilityManager.h"

@implementation CreateGroupInfo

- (instancetype)initWithGroupNumber:(NSInteger)groupNumber MemberNumber:(NSInteger)memberNumber {
    
    self = [super init];
    if (self) {
        
        _groupNumber = groupNumber;
        _memberNumber = memberNumber;
    }
    return self;
}

@end

NSArray *utilitiesWi;
NSArray *utilitiesValideCode;
@implementation YGUtilities

#pragma mark -
#pragma mark - 加密
+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


//把字符串加密成Base64字符串
+(NSString *) ecodeResultJsonTextToBase64String:(NSString *)resultJsonText
{
    NSString *resultJsonTextEncodeBase64String;
    if (resultJsonText && [resultJsonText length] > 0) {
        //加密
        //先把 字符串  str 转成 NSData类型
        NSData *resultJsonTextData=[resultJsonText dataUsingEncoding:NSUTF8StringEncoding];
        //把加密后的NSData转成base64编码
        resultJsonTextEncodeBase64String = [resultJsonTextData base64EncodedString];
        
    }
    
    return resultJsonTextEncodeBase64String;
}



//把Base64加密字符串解密出来
+(NSString *) decodeResultJsonTextFromBase64String:(NSString *)resultJsonTextEncodeBase64String
{
    NSString *resultJsonTextDecodeBase64String;
    
    if (resultJsonTextEncodeBase64String && [resultJsonTextEncodeBase64String length] > 0) {
        //把base64字符串编译成NSData
        NSData *resultJsonTextEncodeBase64StringData = [NSData dataFromBase64String:resultJsonTextEncodeBase64String];
        //把NSData转成字符串
        resultJsonTextDecodeBase64String = [[NSString alloc] initWithData:resultJsonTextEncodeBase64StringData encoding:NSUTF8StringEncoding];
    }
    
    return resultJsonTextDecodeBase64String;
}



#pragma mark-
#pragma mark-time
+ (NSString *)currentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)currentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"] firstObject];
}
+ (NSString *)currentMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:1];
}
+ (NSString *)currentDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:2];
}


#pragma mark-
#pragma mark-颜色

+ (UIColor *)ColorWithRGB:(int)colorValue
{
    int b = colorValue & 0xff;
    int g = (colorValue >> 8) & 0xff;
    int r = (colorValue >> 16) & 0xff;
    int a = (colorValue >> 24) & 0xff;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

+ (UIColor *)ColorWithString:(NSString *)s
{
    if (s == nil || [s isEqualToString:@""]) {
        return [UIColor clearColor];
    }
    uint temp = 0;
    if ([s hasPrefix:@"#"]) {
        [[NSScanner scannerWithString:[s substringFromIndex:1]] scanHexInt:&temp];
        temp = temp | 0xff000000;
    }
    return [YGUtilities ColorWithRGB:temp];
}


#pragma mark -
#pragma mark - 消息提示
+ (UIAlertView *)alertWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:delegate
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:otherButtonTitles, nil];
    [alertView show];
    
    return alertView;
}

#pragma mark - 邮箱验证、手机号码验证、车牌号验证、身份证验证
/*邮箱验证*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)isValidatePwd:(NSString *)pwd
{
    NSString *pwdRegex = @"^(?![A-z]+$)(?!\\d+$)(?![\\W_]+$)^.{8,20}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}

/*手机号码验证 */
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    if (mobile.length != 11)
    {
        return NO;
    }
    else
    {
        if ([[mobile substringToIndex:1] isEqualToString:@"1"])
        {
            NSScanner* scan = [NSScanner scannerWithString:mobile];
            int val;
            return[scan scanInt:&val] && [scan isAtEnd];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isValidateTelephone:(NSString *)telephone
{
    /**
     * 手机号码
     * 移动 : 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通 : 130,131,132,152,155,156,185,186
     * 电信 : 133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动 : China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通 : China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信 : China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号 : 010,020,021,022,023,024,025,027,028,029
     27         * 号码 : 七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telephone] == YES)
        || ([regextestcm evaluateWithObject:telephone] == YES)
        || ([regextestct evaluateWithObject:telephone] == YES)
        || ([regextestcu evaluateWithObject:telephone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断是否为汉字
+ (BOOL)isChinese:(NSString *)str
{
//    BOOL result = YES;
//    if (str) {
//        for (int i = 0; i < str.length; i++) {
//            NSRange range=NSMakeRange(i,1);
//            NSString *subString=[str substringWithRange:range];
//            const char *cString=[subString UTF8String];
//            if (strlen(cString) != 3) {
//                result = NO;
//            }
//        }
//    }
//    

    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

+ (BOOL) isNumberAndLetter:(NSString*) password
{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}
//判断姓名中含先生/小姐并且在第一个字使用老、大、小、啊、阿
+ (BOOL)isNameContainsInvalidateStr:(NSString *)str
{
    BOOL result = NO;
    
    NSRange range=NSMakeRange(0,1);
    NSString *firstString=[str substringWithRange:range];
    if ([firstString isEqualToString:@"老"] || [firstString isEqualToString:@"大"] || [firstString isEqualToString:@"小"] || [firstString isEqualToString:@"啊"] || [firstString isEqualToString:@"阿"]) {
        result = YES;
    }else {
        if ([str containsString:@"先生"] || [str containsString:@"小姐"] || [str containsString:@"女士"]) {
            result = YES;
        }
    }
    
    
    return result;
}

/*身份证信息验证*/
+ (BOOL)isValidateIDNum:(NSString *)num
{
    if (num.length > 17) {
        return [YGUtilities IdCardValidate:num];
    }
    return NO;
}

/*详细地址验证*/
+ (BOOL)isValidateAddress:(NSString *)str
{
    NSString *strRegex = @"^[a-zA-Z0-9#_\(\\)\\-\\s\u4e00-\u9fa5]{3,30}$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [strTest evaluateWithObject:str];
}

//身份证校验
+ (BOOL)IdCardValidate:(NSString *)idCard
{
    utilitiesWi = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1"];    // 加权因子
    utilitiesValideCode = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];            // 身份证验证位值.10代表X
    
    NSMutableString *initStr = [NSMutableString stringWithString:idCard];
    
    //去掉字符串头尾空格
    if ([[initStr substringToIndex:0] isEqualToString:@" "]) {
        [initStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    if (initStr.length > 1) {
        if ([[initStr substringFromIndex:initStr.length-1] isEqualToString:@" "]) {
            [initStr replaceCharactersInRange:NSMakeRange(initStr.length-1, 1) withString:@""];
        }
    }
    
    
    if (initStr.length == 15) {
        return [YGUtilities isValidityBrithBy15IdCard:initStr];       //进行15位身份证的验证
    } else if (initStr.length == 18) {
        NSMutableArray *a_idCard = [NSMutableArray array];// = [initStr componentsSeparatedByString:@""];                // 得到身份证数组
        for (int i = 0; i < initStr.length; i++) {
            [a_idCard addObject:[initStr substringWithRange:NSMakeRange(i, 1)]];
        }
        
        if ([YGUtilities isValidityBrithBy18IdCard:initStr] && [YGUtilities isTrueValidateCodeBy18IdCard:a_idCard]) {   //进行18位身份证的基本验证和第18位的验证
            return YES;
        } else {
            return NO;
        }
    }else {
        return NO;
    }

    return NO;

}
///**
// * 判断身份证号码为18位时最后的验证位是否正确
// * @param a_idCard 身份证号码数组
// * @return
// */
+ (BOOL)isTrueValidateCodeBy18IdCard:(NSMutableArray *)a_idCard
{
    int sum = 0;                             // 声明加权求和变量
    if ([a_idCard[17] isEqualToString:@"x"] || [a_idCard[17] isEqualToString:@"X"]) {
        a_idCard[17] = @"10";                    // 将最后位为x的验证码替换为10方便后续操作
    }
    for (int i = 0; i < 17; i++) {
        sum += [utilitiesWi[i] intValue] * [a_idCard[i] intValue];            // 加权求和
    }
    
    int valCodePosition = sum % 11;                // 得到验证码所位置
    if ([a_idCard[17] isEqualToString:utilitiesValideCode[valCodePosition]]) {
        return YES;
    } else {
        return NO;
    }
}


///**
// * 验证18位数身份证号码中的生日是否是有效生日
// * @param idCard 18位书身份证字符串
// * @return
// */
+ (BOOL)isValidityBrithBy18IdCard:(NSString *)idCard18
{
    NSString* year = [NSString stringWithFormat:@"%@",[idCard18 substringWithRange:NSMakeRange(6, 4)]];//idCard15.substring(6, 10);
    NSString* month = [idCard18 substringWithRange:NSMakeRange(10, 2)];//idCard15.substring10, 12);
    NSString* day = [idCard18 substringWithRange:NSMakeRange(12, 2)];//idCard15.substring(12, 14);
    
    
    NSDate *temp_date = [YGTimeUtils getStringToDateWithOutHMS:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
    NSArray *arr = [[YGTimeUtils getDateToStringWithOutHMS:temp_date] componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        if (![[arr firstObject] isEqualToString:year] || ![[arr objectAtIndex:1] isEqualToString:month] || ![[arr lastObject] isEqualToString:day]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}

///**
// * 验证15位数身份证号码中的生日是否是有效生日
// * @param idCard15 15位书身份证字符串
// * @return
// */
+ (BOOL)isValidityBrithBy15IdCard:(NSString *)idCard15
{
    NSString* year = [NSString stringWithFormat:@"19%@",[idCard15 substringWithRange:NSMakeRange(6, 2)]];//idCard15.substring(6, 8);
    NSString* month = [idCard15 substringWithRange:NSMakeRange(8, 2)];//idCard15.substring(8, 10);
    NSString* day = [idCard15 substringWithRange:NSMakeRange(10, 2)];//idCard15.substring(10, 12);
    

    NSDate *temp_date = [YGTimeUtils getStringToDateWithOutHMS:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
    NSArray *arr = [[YGTimeUtils getDateToStringWithOutHMS:temp_date] componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        if (![[arr firstObject] isEqualToString:year] || ![[arr objectAtIndex:1] isEqualToString:month] || ![[arr lastObject] isEqualToString:day]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
    
}

//url转码
static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
+ (NSString*)percentEscapedQueryStringValueFromString:(NSString*)string WithEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}
//url解码
+ (NSString *)urlDecodedString:(NSString *)str WithEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
}

#pragma mark -
#pragma mark - 图片拉伸
+(UIImage *)stretchImage:(NSString *)imageName width:(float)width height:(float)height
{
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    UIImage *chableImage = [sourceImage  stretchableImageWithLeftCapWidth:width topCapHeight:height];
    return chableImage;
}

#pragma mark - 裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉

+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size

{
    
    CGSize originalsize = [originalImage size];
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    
    if (originalsize.width<size.width && originalsize.height<size.height)
        
    {
        
        return originalImage;
        
    }
    
    
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    
    else if(originalsize.width>size.width && originalsize.height>size.height)
        
    {
        
        CGFloat rate = 1.0;
        
        CGFloat widthRate = originalsize.width/size.width;
        
        CGFloat heightRate = originalsize.height/size.height;
        
        
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        
        
        CGImageRef imageRef = nil;
        
        
        
        if (heightRate>widthRate)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
            
        }
        
        else
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
            
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    
    else if(originalsize.height>size.height || originalsize.width>size.width)
        
    {
        
        CGImageRef imageRef = nil;
        
        
        
        if(originalsize.height>size.height)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
            
        }
        
        else if (originalsize.width>size.width)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
            
        }
        
        
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        
        
        　 　　CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图为标准长宽的，不做处理
    
    else
        
    {
        
        return originalImage;
        
    }
    
    
    
}

//图片缩放到指定大小尺寸
+(UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//处理图片
+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = (GLuint)CGImageGetWidth(inImageRef);
    GLuint h = (GLuint)CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    
    //双层循环按照长宽的像素个数迭代每个像素点
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha=(unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, f);
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            //将数组的索引指向下四个元素
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h* 4;
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
    
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    
    if (imageRef) {
        CFRelease(imageRef);
    }
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}
//由颜色获取图片
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//当前view创建图片
+ (UIImage*)createImageWithView:(UIView*)v
{
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//缓存图片到本地
+ (BOOL)saveImageToCacheDirWithImage:(UIImage *)image imageType:(NSString *)imageType pathName:(NSString *)pathName subPathName:(NSString *)subPathName
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = arr[0];
    NSString *imgPath = [path stringByAppendingPathComponent:pathName];
    if (subPathName) {
        imgPath = [imgPath stringByAppendingPathComponent:subPathName];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imgPath error:nil];
    
    
    bool isSaved = false;
    if ([[imageType lowercaseString] isEqualToString:@"png"]) {
        isSaved = [UIImagePNGRepresentation(image) writeToFile:imgPath options:NSAtomicWrite error:nil];
    }else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"]) {
        isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imgPath options:NSAtomicWrite error:nil];
    }else{
        //NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
    }
    return isSaved;
}



//删除本地缓存图片
+ (BOOL)deleteImgCacheWithPathName:(NSString *)pathName subPathName:(NSString *)subPathName
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = arr[0];
    NSString *imgPath = [path stringByAppendingPathComponent:pathName];
    if (subPathName) {
        imgPath = [imgPath stringByAppendingPathComponent:subPathName];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imgPath];
    bool isDeleted = false;
    if (existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:imgPath error:nil];
    }
    
    return isDeleted;
}
#pragma mark-
#pragma mark-设置登录 退出登录  下一步等按钮点击效果背景图
//默认白色
+ (void)setButtonImgAndHighlitedImgDefaultColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_white_unselect" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_gray_select" width:10.f height:10.f] forState:UIControlStateHighlighted];
}
//默认白色 无边框
+ (void)setButtonImgAndHighlitedImgDefaultColorWithOutBorderWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_white_noborder" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_gray_noborder" width:10.f height:10.f] forState:UIControlStateHighlighted];
    
}
//导航色
+ (void)setButtonImgAndHighlitedImgLikeNavbarColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_recharge_unselect" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_navbg_select" width:10.f height:10.f] forState:UIControlStateHighlighted];
}

//白色背景 不被选上
+ (void)setButtonUnselectImgAndHighlitedImgWhiteColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_white_unselect" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_white_unselect" width:10.f height:10.f] forState:UIControlStateHighlighted];
}
//灰色背景 不被选上
+ (void)setButtonImgAndHighlitedImgLikeGrayColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_gray_bg" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_gray_bg" width:10.f height:10.f] forState:UIControlStateHighlighted];
}
//深灰色背景 不被选上
+ (void)setButtonImgAndHighlitedImgLikeDarkGrayColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_dark_gray_select" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_dark_gray_select" width:10.f height:10.f] forState:UIControlStateHighlighted];
}
//指定图片  10.f拉伸
+ (void)setButtonImgWith:(UIButton *)bt nomalImage:(NSString *)nomalImage highlitedImage:(NSString *)highlitedImage
{
    [bt setBackgroundImage:[YGUtilities stretchImage:nomalImage width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:highlitedImage width:10.f height:10.f] forState:UIControlStateHighlighted];
}
//白色背景 不被选上  导航色边框
+ (void)setButtonUnselectImgAndHighlitedImgWhiteColorNavbarColorBorderWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_navbg_unselect" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_navbg_unselect" width:10.f height:10.f] forState:UIControlStateHighlighted];
}

//清除背景图片  背景色透明
+ (void)setButtonClearUnselectImgAndHighlitedImgWhiteColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:nil forState:UIControlStateNormal];
    [bt setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    bt.backgroundColor = [UIColor clearColor];
}

//红色按钮
+ (void)setButtonImgAndHighlitedImgRedColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_red_unselect" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_red_select" width:10.f height:10.f] forState:UIControlStateHighlighted];
}

//灰色按钮
+ (void)setButtonImgAndHighlitedImgLightGrayColorWith:(UIButton *)bt
{
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_bt_gray_select" width:10.f height:10.f] forState:UIControlStateNormal];
    [bt setBackgroundImage:[YGUtilities stretchImage:@"common_gray_bg" width:10.f height:10.f] forState:UIControlStateHighlighted];
}


#pragma mark -
#pragma mark - string
//计算String的Size  固定宽度
+ (CGSize)getSizeWithText:(NSString *)text textFontSize:(CGFloat)textFontSize textWidth:(CGFloat)textWidth
{
    CGSize size = CGSizeMake(0, 0);
    
    if ([text isKindOfClass:[NSString class]] && text) {
        size = [text boundingRectWithSize:CGSizeMake(textWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[YGUtilities setFontSizeWith:textFontSize],NSFontAttributeName,nil] context:nil].size;
    }
    
    
    return size;
}
//计算String的Size  固定高度
+ (CGSize)getSizeWithText:(NSString *)text textFontSize:(CGFloat)textFontSize textHeight:(CGFloat)textHeight
{
    CGSize size = CGSizeMake(0, 0);
    
    if ([text isKindOfClass:[NSString class]] && text) {        
        size = [text boundingRectWithSize:CGSizeMake(1000, yLAYOUT_RATIO(textHeight)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[YGUtilities setFontSizeWith:textFontSize],NSFontAttributeName,nil] context:nil].size;
    }
    
    
    return size;
}
//设置AttributedString  needSetStr
+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr:(NSString *)needSetStr color:(UIColor *)color textSize:(CGFloat)textSize forwardSearch:(BOOL)forwardSearch lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:initStr];
    
    if (lineSpacing > 0.1) {
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = lineSpacing;
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, initStr.length)];
    }
    
    NSRange range;
    if (forwardSearch) {
        range = [initStr rangeOfString:needSetStr];
    }else{
        range = [initStr rangeOfString:needSetStr options:NSBackwardsSearch];
    }
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    [str addAttribute:NSFontAttributeName value:[YGUtilities setFontSizeWith:textSize] range:range];
    
    return str;
}

+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr:(NSString *)needSetStr color:(UIColor *)color textSize:(CGFloat)textSize backroundColor:(UIColor *)bgColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:initStr];
    NSRange range = [initStr rangeOfString:needSetStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSBackgroundColorAttributeName value:bgColor range:range];
    
    [str addAttribute:NSFontAttributeName value:[YGUtilities setFontSizeWith:textSize] range:range];
    
    return str;
}

//设置AttributedString  needSetStr1  needSetStr2
+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr1:(NSString *)needSetStr1 needSetStr2:(NSString *)needSetStr2 color1:(UIColor *)color1 color2:(UIColor *)color2 textSize1:(CGFloat)textSize1 textSize2:(CGFloat)textSize2
{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:initStr];
    
    NSRange range1 = [initStr rangeOfString:needSetStr1];
    NSRange range2 = [initStr rangeOfString:needSetStr2 options:NSBackwardsSearch];
    
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [str addAttribute:NSFontAttributeName value:[YGUtilities setFontSizeWith:textSize1] range:range1];
    
    [str addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    [str addAttribute:NSFontAttributeName value:[YGUtilities setFontSizeWith:textSize2] range:range2];
    
    return str;
}

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

//获取字符串字节数
+ (int)getStringBytesLengthWithStr:(NSString *)str
{
    
    int asciiLength = 0;
    for (NSUInteger i = 0; i < str.length; i++) {
        unichar uc = [str characterAtIndex: i];
        asciiLength += (uc >=0x4E00 && uc <=0x9FFF) ? 2 : 1;
    }
    
    return asciiLength;
}

+(void)setSolveUIWidgetFuzzy:(UIView *)view
{
    CGRect frame = view.frame;
    float x = floor(frame.origin.x);
    float y = floor(frame.origin.y);
    float w = floor(frame.size.width)+1;
    float h = floor(frame.size.height)+1;
    
    view.frame = CGRectMake(x, y, w, h);
}


+ (UIFont *)setFontSizeWith:(CGFloat)size
{
    if (yScreenSizeScale > 1)
    {
        return systemFont(size+2);
    }
    else if (yScreenSizeScale == 1)
    {
        return systemFont(size+1);
    }
    else
    {
        return systemFont(size);
    }
}

/**
 设置字体大小  加粗
 
 @param size 5为标准的字体大小
 
 @return
 */
+ (UIFont *)setBoldFontSizeWith:(CGFloat)size
{
    if (yScreenSizeScale > 1)
    {
        return boldSystemFont(size+2);
    }
    else if (yScreenSizeScale == 1)
    {
        return boldSystemFont(size+1);
    }
    else
    {
        return boldSystemFont(size);
    }
}


#pragma mark -
#pragma mark - other

//设置tableview分割线
+ (void)setTableViewSeparatorInsetWithTableView:(UITableView *)tb
{
    if ([tb respondsToSelector:@selector(setSeparatorInset:)]) {
        [tb setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tb respondsToSelector:@selector(setLayoutMargins:)]) {
        [tb setLayoutMargins:UIEdgeInsetsZero];
    }
}
+ (void)setTableViewCellSeparatorInsetWithTableViewCell:(UITableViewCell *)tbCell
{
    if ([tbCell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tbCell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tbCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tbCell setLayoutMargins:UIEdgeInsetsZero];
    }
}






#pragma mark - 
#pragma mark - private

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}
// 返回一个使用RGBA通道的位图上下文
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow	= (int)(pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount	= (int)(bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}
//修改RGB的值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f){
    int redV=*red;
    int greenV=*green;
    int blueV=*blue;
    int alphaV=*alpha;
    
    *red=f[0]*redV+f[1]*greenV+f[2]*blueV+f[3]*alphaV+f[4];
    *green=f[0+5]*redV+f[1+5]*greenV+f[2+5]*blueV+f[3+5]*alphaV+f[4+5];
    *blue=f[0+5*2]*redV+f[1+5*2]*greenV+f[2+5*2]*blueV+f[3+5*2]*alphaV+f[4+5*2];
    *alpha=f[0+5*3]*redV+f[1+5*3]*greenV+f[2+5*3]*blueV+f[3+5*3]*alphaV+f[4+5*3];
    if (*red>255) {
        *red=255;
    }
    if(*red<0){
        *red=0;
    }
    if (*green>255) {
        *green=255;
    }
    if (*green<0) {
        *green=0;
    }
    if (*blue>255) {
        *blue=255;
    }
    if (*blue<0) {
        *blue=0;
    }
    if (*alpha>255) {
        *alpha=255;
    }
    if (*alpha<0) {
        *alpha=0;
    }
}



//获取app版本
+ (int)getLocalAppVersion
{
    int systemVersion = 0;
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    for (NSString *str in [versionStr componentsSeparatedByString:@"."]) {
        systemVersion = systemVersion*10 + str.intValue;
    }
    
    return systemVersion;
}




#pragma mark - -----IM
+ (UIViewController *)presentingVC {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *result = window.rootViewController;
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
        if ([result isKindOfClass:[UITabBarController class]]) {
            result = [((UITabBarController *)result).viewControllers objectAtIndex:((UITabBarController *)result).selectedIndex];
        }
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController *)result).viewControllers objectAtIndex:((UITabBarController *)result).selectedIndex];
    }
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (UIViewController *)keyWindowViewControllerWithClass:(Class)viewControllerClass {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *result = [YGUtilities viewController:window.rootViewController withClass:viewControllerClass];
    return result;
}

+ (UIViewController *)viewController:(UIViewController *)viewController withClass:(Class)viewControllerClass {
    if ([viewController isKindOfClass:viewControllerClass]) {
        return viewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        for (UIViewController *tempVC in navigationController.viewControllers) {
            UIViewController *returnVC = [YGUtilities viewController:tempVC withClass:viewControllerClass];
            if (returnVC) {
                return returnVC;
            }
        }
    }
    
    return nil;
}

#pragma mark - 获取等级名称和图片名称
/**
 *根据等级获取等级图标名和等级名
 */
+ (void)getWithNum:(NSInteger)num GradeImageAndName:(void (^)(NSString *gradeImage, NSString *gradeName))block{
    switch (num) {
        case 1:
            block(@"degree1",@"云购小将");
            break;
            
        case 2:
            block(@"degree2",@"云购少将");
            break;
            
        case 3:
            block(@"degree3",@"云购中将");
            break;
            
        case 4:
            block(@"degree4",@"云购上将");
            break;
            
        case 5:
            block(@"degree5",@"云购大将");
            break;
            
        case 6:
            block(@"degree6",@"云购将军");
            break;
            
        default:
            block(@"degree1",@"云购小将");
            break;
    }
}




/**
 根据群人数获取可设置的管理员数量
 
 @param max 群人数
 @return 可设管理员数量
 */

+ (NSInteger)getAdminsNumberCanSetWithGroupMemberMax:(NSInteger)max {
    
    return 3;
//    switch (max) {
//        case 50:
//            return 0;
//            break;
//        case 100:
//        case 200:
//        case 300:
//            return max/5;
//            break;
//        case 500:
//            return 6;
//            break;
//        case 2000:
//            return 10;
//            break;
//        default:
//            return 0;
//            break;
//    }
}
#pragma mark - 获取距离
/**
 *  获取两点之间的距离
 */

/*
+ (float) getLocation:(CLLocation*)firstloction selfLoction:(CLLocation *)sectionLocation{
    
    if (!firstloction.coordinate.latitude || !firstloction.coordinate.longitude || !sectionLocation.coordinate.longitude || !sectionLocation.coordinate.latitude) {
        return CGFLOAT_MIN;
    }
    
    //第一个坐标
    //    CLLocation *selfLocation = [YGTCPUserManager sharedManager].locationPoint;
    //第二个坐标
    CLLocation *before = [[CLLocation alloc] initWithLatitude:firstloction.coordinate.latitude longitude:firstloction.coordinate.longitude];
    //计算距离
    CLLocationDistance meters = [sectionLocation distanceFromLocation:before];
    
    if (meters < 1 ) {
        return CGFLOAT_MIN;
    }
    
    return meters;
}
*/

#pragma mark - RandomID

+ (NSArray *)randomStringArray {
    static NSArray *stringArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    });
    return stringArray;
}

+ (NSString *)randomID {
    NSMutableString *string = [NSMutableString new];
    NSArray *stringArray = [self randomStringArray];
    for (int i = 0; i < 8; i++) {
        NSInteger b = arc4random_uniform(62);
        [string appendString:stringArray[b]] ;
    }
    return string;
}


void dispatch_main_async(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 获取请求头中的User-Agent
 
 @return @“iOS/5.3 (手机型号; APP版本号; 系统版本号; 手机时间)”
 */
+ (NSString *)getUserAgent
{
    NSString *userAgent = nil;/*[NSString stringWithFormat:@"iOS/5.3 (%@; %@; %@; %@)", [YGUUID getRequestNetWorkDeviceModel], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] systemVersion], [YGTimeUtils getCurrentTime]];*/
    return userAgent;
}







#pragma mark - 获取距离
/**
 *  获取两点之间的距离
 */

+ (float) getLocation:(CLLocation*)firstloction selfLoction:(CLLocation *)sectionLocation{
    
    if (!firstloction.coordinate.latitude || !firstloction.coordinate.longitude || !sectionLocation.coordinate.longitude || !sectionLocation.coordinate.latitude) {
        return CGFLOAT_MIN;
    }
    
    //第一个坐标
    //    CLLocation *selfLocation = [YGTCPUserManager sharedManager].locationPoint;
    //第二个坐标
    CLLocation *before = [[CLLocation alloc] initWithLatitude:firstloction.coordinate.latitude longitude:firstloction.coordinate.longitude];
    //计算距离
    CLLocationDistance meters = [sectionLocation distanceFromLocation:before];
    
    if (meters < 1 ) {
        return CGFLOAT_MIN;
    }
    
    return meters;
}









+ (CGFloat)screenScale {
    static CGFloat _scale = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scale = [UIScreen mainScreen].scale;
    });
    
    return _scale;
}
+ (CGFloat)pixelAlignForFloat:(CGFloat)position {
    CGFloat scale = [YGUtilities screenScale];
    return round(position * scale) / scale;
}


//判断当前网络
+ (AFNetworkReachabilityStatus)jugdeCurrentNet {
    return  [[IMReachabilityManager sharedManager] networkReachabilityStatus];
}



+(int)convertContainsHanToInt:(NSString*)strTemp
{
    int strlength = 0;
    char* p = (char*)[strTemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strTemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

@end
