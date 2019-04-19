//
//  YGSocketOutputSteam.m
//  mobile
//
//  Created by jiangxincai on 16/1/22.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "YGSocketOutputSteam.h"
#import "sys/_endian.h"
#import <CommonCrypto/CommonCrypto.h>

@interface YGSocketOutputSteam ()

@property (nonatomic, strong) NSData *originalData;//原始data
@property (nonatomic, strong) NSMutableData *codeData;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, assign) NSInteger length;

@end

@implementation YGSocketOutputSteam

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _originalData = data;
        _codeData = [NSMutableData new];
        _data = [NSMutableData new];
        _length = 0;
    }
    return self;
}

#pragma mark - Write

- (void)writeChar:(int8_t)v {
    int8_t ch[1];
    ch[0] = (v & 0x0ff);
    [self.data appendBytes:ch length:1];
    self.length++;
}


- (void)writeShort:(int16_t)v {
    int8_t ch[2];
    ch[0] = (htons(v) & 0x0ff00)>>8;
    ch[1] = (htons(v) & 0x0ff);
    [self.data appendBytes:ch length:2];
    self.length = self.length + 2;
}

- (void)writeNormalShort:(int16_t)v {
    int8_t ch[2];
    ch[0] = (v & 0x0ff00)>>8;
    ch[1] = (v & 0x0ff);
    [self.data appendBytes:ch length:2];
    self.length = self.length + 2;
}

- (void)writeInt:(int32_t)v {
    int8_t ch[4];
    for(int32_t i = 0;i<4;i++){
        ch[i] = ((htonl(v) >> ((3 - i)*8)) & 0x0ff);
    }
    [self.data appendBytes:ch length:4];
    self.length = self.length + 4;
}

- (void)writeLong:(int64_t)v {
    int8_t ch[8];
    for(int32_t i = 0;i<8;i++){
        ch[i] = ((htonll(v) >> ((7 - i)*8)) & 0x0ff);
    }
    [self.data appendBytes:ch length:8];
    self.length = self.length + 8;
}

- (void)writeUTF:(NSString *)v {
    NSData *d = [v dataUsingEncoding:NSUTF8StringEncoding];
    uint32_t len = (uint32_t)[d length];
    
    [self writeInt:len];
    [self.data appendData:d];
    self.length = self.length + len;
}

- (void)writeBytes:(NSData *)v {
    int32_t len = (int32_t)[v length];
    [self writeInt:len];
    [self.data appendData:v];
    
    self.length = self.length + len;
}

-(void)directWriteBytes:(NSData *)v {
    int32_t len = (int32_t)[v length];
    [self.data appendData:v];
    self.length = self.length + len;
}

- (void)writeDataCount {
    int8_t ch[4];
    for(int32_t i = 0;i<4;i++){
        ch[i] = ((self.length >> ((3 - i)*8)) & 0x0ff);
    }
    
    [self.data replaceBytesInRange:NSMakeRange(0, 4) withBytes:ch];
}

- (NSMutableData *)socketSendData {
    [self codeOriginaData];
    [self writeProtocolData];
    return self.data;
}

#pragma mark - 处理

/**
 *  遍历data 取出每个字节 对每个字节的bite双数位置加5 单数加7
 */
- (void)codeOriginaData {
    [self.originalData enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
            uint8_t temp = ((uint8_t *)bytes)[i];
            temp = (i + byteRange.location)%2 ? temp + 5 : temp + 7 ;
            [self.codeData appendBytes:&temp length:1];
        }
    }];
}

/**
 *  包头包尾各＋10字节
 */
- (void)writeProtocolData {
    //起始标识
    [self writeShort:0xFFFF];//2字节
    //长度
    [self writeInt:@(self.codeData.length).intValue];//4字节
    //总分包数
    [self writeShort:1];//2
    //顺序号
    [self writeShort:0];//2
    //消息内容
    [self directWriteBytes:self.codeData];
    //md5
    NSString *md5 = [self md5String:self.originalData];
    NSData *md5Data = [md5 dataUsingEncoding:NSUTF8StringEncoding];
    int16_t addInt = 0;
    for (NSInteger i = 0; i < md5.length; i++) {
        int8_t v = 0;
        [md5Data getBytes:&v range:NSMakeRange(i, 1)];
        addInt = addInt + v;
    }
    [self writeShort:addInt];//2字节
    //预留内容
    [self.data increaseLengthBy:6];
    //结束标识
    [self writeNormalShort:0xFFFE];//2字节
}

-(NSString*) md5String:(NSData*) data {
    const char *str = [data bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)data.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

@end
