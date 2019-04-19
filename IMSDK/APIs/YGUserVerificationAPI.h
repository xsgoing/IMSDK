//
//  YGUserVerificationAPI.h
//  IM
//
//  Created by jiangxincai on 15/4/13.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGSuperAPI.h"

/**
 *  需要连接成功后获得session再验证,参数为NSArray,object[0]为用户名,object[1]为连接成功时获取的session
 */
@interface YGUserVerificationAPI : YGSuperAPI

@end
