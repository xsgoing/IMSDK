//
//  YGSocketOutputSteam.h
//  mobile
//
//  Created by jiangxincai on 16/1/22.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGSocketOutputSteam : NSObject

- (instancetype)initWithData:(NSData *)data;
- (NSMutableData *)socketSendData;

@end
