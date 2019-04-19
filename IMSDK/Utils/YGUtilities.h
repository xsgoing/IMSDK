//
//  Utilities.h
//  mobile
//
//  Created by xk on 14-11-19.
//  Copyright (c) 2014年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#import <CoreLocation/CoreLocation.h>

static const float recordMAXTime = 60.00;//录音最大时长
@interface CreateGroupInfo : NSObject

@property (nonatomic,assign) NSInteger groupNumber;
@property (nonatomic,assign) NSInteger memberNumber;

- (instancetype)initWithGroupNumber:(NSInteger)groupNumber MemberNumber:(NSInteger)memberNumber;
@end

@interface YGUtilities : NSObject

#define AppDelegateObj  ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UserModelObj    [YGUserModel sharedInstance]
#define UserDefaultsObj [NSUserDefaults standardUserDefaults]

#define UserModelObj        [YGUserModel sharedInstance]

#define UserDefaultsObj     [NSUserDefaults standardUserDefaults]

#define systemFont(size)        [UIFont systemFontOfSize:size]

#define boldSystemFont(size)    [UIFont boldSystemFontOfSize:size]

//16进制颜色
#define UIColorFromHex(s,a)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0 alpha:a]

//返回当前系统版本号
#define SYSTEM_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]
#define isIOS7              ([UIDevice currentDevice].systemVersion.floatValue < 8)

//返回当前设备名称
#define Dev_Name            [UIDevice currentDevice].name
//返回当前系统名称
#define Dev_IOSName         [UIDevice currentDevice].systemName

//判断字符串是否为空
#define STR_IS_NULL(str)    (str)?(str):@""

// 是否为空对象
#define MJBObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MJBStringIsEmpty(__string) ((__string.length == 0) || MJBObjectIsNil(__string))

// 字符串不为空
#define MJBStringIsNotEmpty(__string)  (!MJBStringIsEmpty(__string))

// 数组为空
#define MJBArrayIsEmpty(__array) ((MJBObjectIsNil(__array)) || (__array.count==0))

//导航栏高度
#define WD_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define WD_NavBarHeight 44.0
#define yTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define yNavigationHeight (WD_StatusBarHeight + WD_NavBarHeight) //整个导航栏高度


//高度0
#define GET_ZERO            0
// 屏幕高度
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
//屏幕分辨率宽度
#define SCREEN_WIDTHPX         SCREEN_WIDTH*[UIScreen mainScreen].scale
//屏幕分辨率高度
#define SCREEN_HEIGHTPX        SCREEN_HEIGHT*[UIScreen mainScreen].scale



//设置1像素分割线
#define ySINGLE_LINE_BOUNDS          (1 / [UIScreen mainScreen].scale)
#define ySINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

//=====================================================BY=======ZNN======================IM===================

//cell线宽度
#define YGCellLineHeight    (SCREEN_WIDTH > 375 ? 1/3.0f : 0.5f)

#define k_text_space        3 //群介绍 行 间距



#define showTime            52//从多少-2秒开始倒计时

//适配UIView
#define AdaptSetViewFrame(obj)      obj.frame = CGRectMake(CGRectGetMinX(obj.frame)*kLAYOUT_RATIO, CGRectGetMinY(obj.frame)*kLAYOUT_RATIO, CGRectGetWidth(obj.frame)*kLAYOUT_RATIO, CGRectGetHeight(obj.frame)*kLAYOUT_RATIO);

//==================================================================================================================

#define kLAYOUT_RATIO       SCREEN_WIDTH/375.f

#define yScreenSizeScale    SCREEN_WIDTH/375.f

#define yLAYOUT_RATIO(x)    (x*yScreenSizeScale)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define STRONG_SELF if (!weakSelf) return; \
__strong typeof(weakSelf) strongSelf = weakSelf

#define AdaptSetFrame(obj)          obj.frame = CGRectMake(CGRectGetMinX(obj.frame), CGRectGetMinY(obj.frame), SCREEN_WIDTH, CGRectGetHeight(obj.frame)*kLAYOUT_RATIO);

#define AdaptSetNewFrame(obj)       obj.frame = CGRectMake(CGRectGetMinX(obj.frame), CGRectGetMinY(obj.frame), SCREEN_WIDTH, CGRectGetHeight(obj.frame)*yScreenSizeScale);

#define AdaptSetVCViewFrame(obj)    obj.frame = CGRectMake(CGRectGetMinX(obj.frame), CGRectGetMinY(obj.frame), SCREEN_WIDTH, SCREEN_HEIGHT);

#define DEFINE_SINGLETON_FOR_HEADER(className)   + (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#pragma mark -
#pragma mark - 加密
+ (NSString *)md5:(NSString *)input;
//把字符串加密成Base64字符串
+(NSString *) ecodeResultJsonTextToBase64String:(NSString *)resultJsonText;
//把Base64加密字符串解密出来
+(NSString *) decodeResultJsonTextFromBase64String:(NSString *)resultJsonTextEncodeBase64String;


#pragma mark-
#pragma mark- time
+ (NSString *)currentTime;
+ (NSString *)currentYear;
+ (NSString *)currentMonth;
+ (NSString *)currentDay;


#pragma mark-
#pragma mark- 颜色
+ (UIColor *)ColorWithRGB:(int)colorValue;
+ (UIColor *)ColorWithString:(NSString *)s;


#pragma mark - 
#pragma mark - 消息提示

+ (UIAlertView *)alertWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id <UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

#pragma mark -
#pragma mark -  判断email、mobile 等
/*邮箱验证 */
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidatePwd:(NSString *)pwd;
/*手机号码验证*/
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateTelephone:(NSString *)telephone;
//判断是否为汉字
+ (BOOL)isChinese:(NSString *)str;
//判断姓名中含先生/小姐并且在第一个字使用老、大、小、啊、阿
+ (BOOL)isNameContainsInvalidateStr:(NSString *)str;
/*身份证信息验证*/
+ (BOOL)isValidateIDNum:(NSString *)num;
/*详细地址验证*/
+ (BOOL)isValidateAddress:(NSString *)str;


#pragma mark -
#pragma mark - 网络
//url转码
+ (NSString*)percentEscapedQueryStringValueFromString:(NSString*)string WithEncoding:(NSStringEncoding)encoding;
//url解码
+ (NSString *)urlDecodedString:(NSString *)str WithEncoding:(NSStringEncoding)encoding;


#pragma mark-
#pragma mark- 图片拉伸 裁剪 处理
+ (UIImage *)stretchImage:(NSString *)imageName width:(float)width height:(float)height;
+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize) size;
#pragma mark - 裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;
//设定ImgView圆角以及边框
+ (void)setImgViewCornerRadiusAndBorderColorAndBorderWidth:(UIImageView *)imgView;
//处理图片
+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*)f;
//由颜色获取图片
+ (UIImage*)createImageWithColor:(UIColor*)color;
//当前view创建图片
+ (UIImage*)createImageWithView:(UIView*)v;


#pragma mark-
#pragma mark- 图片本地缓存
//缓存图片到本地
+ (BOOL)saveImageToCacheDirWithImage:(UIImage *)image imageType:(NSString *)imageType pathName:(NSString *)pathName subPathName:(NSString *)subPathName;
//读取本地缓存图片
+ (UIImage*)loadImageCacheDataWithPathName:(NSString *)pathName subPathName:(NSString *)subPathName;
//删除本地缓存图片
+ (BOOL)deleteImgCacheWithPathName:(NSString *)pathName subPathName:(NSString *)subPathName;


#pragma mark-
#pragma mark- 设置登录 退出登录  下一步等按钮点击效果背景图
//默认白色
+ (void)setButtonImgAndHighlitedImgDefaultColorWith:(UIButton *)bt;
//默认白色 无边框
+ (void)setButtonImgAndHighlitedImgDefaultColorWithOutBorderWith:(UIButton *)bt;
//导航色
+ (void)setButtonImgAndHighlitedImgLikeNavbarColorWith:(UIButton *)bt;
//白色背景 不被选上
+ (void)setButtonUnselectImgAndHighlitedImgWhiteColorWith:(UIButton *)bt;
//灰色背景 不被选上
+ (void)setButtonImgAndHighlitedImgLikeGrayColorWith:(UIButton *)bt;
//深灰色背景 不被选上
+ (void)setButtonImgAndHighlitedImgLikeDarkGrayColorWith:(UIButton *)bt;
//指定图片  10.f拉伸
+ (void)setButtonImgWith:(UIButton *)bt nomalImage:(NSString *)nomalImage highlitedImage:(NSString *)highlitedImage;
//白色背景 不被选上  导航色边框
+ (void)setButtonUnselectImgAndHighlitedImgWhiteColorNavbarColorBorderWith:(UIButton *)bt;
//清除背景图片  背景色透明
+ (void)setButtonClearUnselectImgAndHighlitedImgWhiteColorWith:(UIButton *)bt;
//红色按钮
+ (void)setButtonImgAndHighlitedImgRedColorWith:(UIButton *)bt;
//灰色按钮
+ (void)setButtonImgAndHighlitedImgLightGrayColorWith:(UIButton *)bt;


#pragma mark -
#pragma mark - string
//计算String的Size  固定宽度
+ (CGSize)getSizeWithText:(NSString *)text textFontSize:(CGFloat)textFontSize textWidth:(CGFloat)textWidth;
//计算String的Size 固定高度
+ (CGSize)getSizeWithText:(NSString *)text textFontSize:(CGFloat)textFontSize textHeight:(CGFloat)textHeight;
//设置AttributedString
+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr:(NSString *)needSetStr color:(UIColor *)color textSize:(CGFloat)textSize forwardSearch:(BOOL)forwardSearch lineSpacing:(CGFloat)lineSpacing;
//设置AttributedString 带背景色
+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr:(NSString *)needSetStr color:(UIColor *)color textSize:(CGFloat)textSize backroundColor:(UIColor *)bgColor;
//设置AttributedString  needSetStr1  needSetStr2
+ (NSMutableAttributedString *)setLabelAttributedTextWithInitStr:(NSString *)initStr needSetStr1:(NSString *)needSetStr1 needSetStr2:(NSString *)needSetStr2 color1:(UIColor *)color1 color2:(UIColor *)color2 textSize1:(CGFloat)textSize1 textSize2:(CGFloat)textSize2;
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
//获取字符串字节数
+ (int)getStringBytesLengthWithStr:(NSString *)str;

/**
 适配模糊

 @param view
 */
+(void)setSolveUIWidgetFuzzy:(UIView *)view;

/**
 设置字体大小

 @param size 5为标准的字体大小

 @return
 */
+ (UIFont *)setFontSizeWith:(CGFloat)size;

/**
 设置字体大小  加粗
 
 @param size 5为标准的字体大小
 
 @return
 */
+ (UIFont *)setBoldFontSizeWith:(CGFloat)size;

#pragma mark-
#pragma mark- other
//设置tableview分割线
+ (void)setTableViewSeparatorInsetWithTableView:(UITableView *)tb;
+ (void)setTableViewCellSeparatorInsetWithTableViewCell:(UITableViewCell *)tbCell;
//设置view边框线
+ (void)setViewCornerRadiusAndBorderColorAndBorderWidthWith:(UIView *)pView;
//获取app版本
+ (int)getLocalAppVersion;
/**
 *  主线程跳转方法，判断了再主线程就不切换线程
 *
 *  @param block
 */
void dispatch_main_async(dispatch_block_t block);


/**
 获取请求头中的User-Agent

 @return
 */
+ (NSString *)getUserAgent;


//===============randId==========
+ (NSArray *)randomStringArray;
+ (NSString *)randomID;
+ (UIViewController *)presentingVC;
+ (UIViewController *)keyWindowViewControllerWithClass:(Class)viewControllerClass;
+ (UIViewController *)viewController:(UIViewController *)viewController withClass:(Class)viewControllerClass;




#pragma mark - 获取距离
/**
 *  获取两点之间的距离
 */
+ (float) getLocation:(CLLocation*)firstloction selfLoction:(CLLocation *)sectionLocation;
+ (void)setSearchBarInfo:(UISearchBar *)searchBar;
+ (void)setNewSearchBarInfo:(UISearchBar *)searchBar;
+ (void)setFriendSearchBarInfo:(UISearchBar *)searchBar;
+ (void)setSessionsSearchBarInfo:(UISearchBar *)searchBar;
+ (void)getWithNum:(NSInteger)num GradeImageAndName:(void (^)(NSString *gradeImage, NSString *gradeName))block;


/**
 获取当前用户可建群数量和群成员数量

 @param level 用户等级
 @return 
 */
+ (CreateGroupInfo *)getGroupCreateInfoWithLevel:(NSInteger)level;


/**
 根据群人数获取可设置的管理员数量

 @param max 群人数
 @return 可设管理员数量
 */
+ (NSInteger)getAdminsNumberCanSetWithGroupMemberMax:(NSInteger)max;



+ (int)jugdeCurrentEvironment;
+ (CGFloat)pixelAlignForFloat:(CGFloat)position;



+ (BOOL) isNumberAndLetter:(NSString*) password;
+(void) checkUpdate:(UIView*) view delegate:(id) delegate;
+(int)convertContainsHanToInt:(NSString*)strTemp;
@end
