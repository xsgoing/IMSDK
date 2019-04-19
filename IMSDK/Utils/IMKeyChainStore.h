//
//  YGKeyChainStore.h
//  LswKey
//
//  Created by TreeWrite on 16/7/19.
//  Copyright © 2016年 TreeWrite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMKeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
