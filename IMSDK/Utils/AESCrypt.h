//
//  AESCrypt.h
//  mobile
//
//  Created by xk on 14-11-20.
//  Copyright (c) 2014年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+DTBase64.h"


@interface AESCrypt : NSObject

/*字符串AES加密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 64位
 */
+(NSString *) encryptUseAES:(NSString *)plainText key:(NSString *)key;


/*字符串AES解密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 64位
 */
+ (NSString *)decryptUseAES:(NSString*)cipherText key:(NSString *)key;


/*字符串AES加密，后再进行Base64加密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 64位
 */
+(NSString *) encryptUseAESAndBase64:(NSString *)plainText key:(NSString *)key;



@end
