//
//  AESCrypt.m
//  mobile
//
//  Created by xk on 14-11-20.
//  Copyright (c) 2014年 1yyg. All rights reserved.
//

#import "AESCrypt.h"

#define  BufferSize  10240

@implementation AESCrypt

/*字符串加密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 128位
 */
+ (NSString *) encryptUseAES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[BufferSize];
    memset(buffer, 0, sizeof(buffer));
    Byte *iv = (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeAES128,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, BufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[self myHexadedimalString:data] uppercaseString];
    }
    return ciphertext;
}


/*字符串AES解密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 128位
 */
+ (NSString *)decryptUseAES:(NSString*)cipherText key:(NSString *)key
{
    NSData* cipherData =[self dataWithHexString:cipherText];
    
    unsigned char buffer[BufferSize];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesDecrypted = 0;
    Byte *iv = (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeAES128,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          BufferSize,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    return plainText;
    
}




/*字符串AES加密，后再进行Base64加密
 *参数
 *plainText :  AES加密明文
 *key        : 密钥 64位
 */
+(NSString *) encryptUseAESAndBase64:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = [self encryptUseAES:plainText key:key];
    
    ciphertext = [[ciphertext dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    return ciphertext;
}


// NSData与16进制字符串转换
+ (NSString *)myHexadedimalString:(NSData*)data {
    NSMutableString *string = [NSMutableString string];
    const unsigned char *bytes = [data bytes];
    NSUInteger length = [data length];
    for (NSUInteger i = 0; i < length; i++) {
        
        NSString * str = [NSString stringWithFormat:@"%02x", bytes[i]];
        
        if (str.length < 2 ) {
            [string appendFormat:@"0%@", str];
        }
        else
        {
            [string appendString:str];
        }
        
    }
    return string;
}



+ (NSData*) dataWithHexString: (NSString*) hexString
{
    NSMutableData* data = [NSMutableData dataWithCapacity: [hexString length] / 2];
    
    char* chars = (char*)[hexString UTF8String];
    
    unsigned char value;
    
    while(*chars != '\0')
    {
        if(*chars >= '0' && *chars <= '9')
        {
            value = (*chars - '0') << 4;
        }
        else if(*chars >= 'a' && *chars <= 'f')
        {
            value = (*chars - 'a' + 10) << 4;
        }
        else if(*chars >= 'A' && *chars <= 'F')
        {
            value = (*chars - 'A' + 10) << 4;
        }
        else
        {
            return nil;
        }
        
        chars++;
        
        if(*chars >= '0' && *chars <= '9')
        {
            value |= *chars - '0';
        }
        else if(*chars >= 'a' && *chars <= 'f')
        {
            value |= *chars - 'a' + 10;
        }
        else if(*chars >= 'A' && *chars <= 'F')
        {
            value |= *chars - 'A' + 10;
        }
        else
        {
            return nil;
        }
        
        [data appendBytes: &value length: sizeof(value)];
        
        chars++;
    }
    
    return data;
}



@end
