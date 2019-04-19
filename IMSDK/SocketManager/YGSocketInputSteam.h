//
//  YGSocketInputSteam.h
//  mobile
//
//  Created by jiangxincai on 16/1/22.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGSocketInputSteam : NSObject

@property (nonatomic, strong) NSMutableData *decodeData;

- (instancetype)initWithData:(NSData *)data;
- (void)decodeOriginaData;
- (NSDictionary *)json;

@end
