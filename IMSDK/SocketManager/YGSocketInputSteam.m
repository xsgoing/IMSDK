//
//  YGSocketInputSteam.m
//  mobile
//
//  Created by jiangxincai on 16/1/22.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import "YGSocketInputSteam.h"

@interface YGSocketInputSteam ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger length;

@end

@implementation YGSocketInputSteam

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
        _decodeData = [NSMutableData new];
        _length = 0;
    }
    return self;
}

#pragma mark - Read 

- (NSUInteger)getAvailabledLen{
    return [self.data length];
}

- (int32_t)read{
    int8_t v;
    [self.data getBytes:&v range:NSMakeRange(self.length,1)];
    self.length++;
    return ((int32_t)v & 0x0ff);
}

- (int8_t)readChar {
    int8_t v;
    [self.data getBytes:&v range:NSMakeRange(self.length,1)];
    self.length++;
    return (v & 0x0ff);
}

- (int16_t)readShort {
    int32_t ch1 = [self read];
    int32_t ch2 = [self read];
    if ((ch1 | ch2) < 0){
        @throw [NSException exceptionWithName:@"Exception" reason:@"EOFException" userInfo:nil];
    }
    return (int16_t)((ch1 << 8) + (ch2 << 0));
    
}

- (int32_t)readInt {
    int32_t ch1 = [self read];
    int32_t ch2 = [self read];
    int32_t ch3 = [self read];
    int32_t ch4 = [self read];
    if ((ch1 | ch2 | ch3 | ch4) < 0){
        @throw [NSException exceptionWithName:@"Exception" reason:@"EOFException" userInfo:nil];
    }
    return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4 << 0));
}

- (int64_t)readLong {
    int8_t ch[8];
    [self.data getBytes:&ch range:NSMakeRange(self.length,8)];
    self.length = self.length + 8;
    
    return (((int64_t)ch[0] << 56) +
            ((int64_t)(ch[1] & 255) << 48) +
            ((int64_t)(ch[2] & 255) << 40) +
            ((int64_t)(ch[3] & 255) << 32) +
            ((int64_t)(ch[4] & 255) << 24) +
            ((ch[5] & 255) << 16) +
            ((ch[6] & 255) <<  8) +
            ((ch[7] & 255) <<  0));
    
}

- (NSString *)readUTF {
    int32_t utfLength = [self readInt];
    NSData *d = [self.data subdataWithRange:NSMakeRange(self.length,utfLength)];
    NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    self.length = self.length + utfLength;
    return str;
}

- (NSData *)readDataWithLength:(int)len{
    NSData *d =[self.data subdataWithRange:NSMakeRange(self.length, len)];
    self.length = self.length +len;
    return d;
}

- (NSData *)readLeftData{
    if ([self.data length] > self.length) {
        NSData *d = [self.data subdataWithRange:NSMakeRange(self.length, [self.data length])];
        self.length = [self.data length];
        return d;
    }
    return  nil;
}

#pragma mark - Parse
/**
 *  解密
 */
- (void)decodeOriginaData {
    NSData *tempData = [self.data subdataWithRange:NSMakeRange(10, self.data.length - 20)];
    [tempData enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
            uint8_t temp = ((uint8_t *)bytes)[i];
            temp = (i + byteRange.location)%2 ? temp - 5 : temp - 7 ;
            [self.decodeData appendBytes:&temp length:1];
        }
    }];
}

- (NSDictionary *)json {
    [self decodeOriginaData];
    NSError *error = nil;
//    double start = CACurrentMediaTime();
    // do something

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.decodeData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"解析失败%@",[[NSString alloc] initWithData:self.decodeData encoding:NSUTF8StringEncoding]);
    }
//    double end = (CACurrentMediaTime() - start) *1000;
//    NSLog(@"\n json use time: %f ms",end);
    return json;
}


@end
