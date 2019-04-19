//
//  YGUUID.h
//  LswKey
//
//  Created by TreeWrite on 16/7/19.
//  Copyright © 2016年 TreeWrite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUUID : NSObject

+(NSString *)getUUID;


//获取设备型号
+ (NSString *)getCurrentDeviceModel;

+ (NSString *)getRequestNetWorkDeviceModel;

@end
