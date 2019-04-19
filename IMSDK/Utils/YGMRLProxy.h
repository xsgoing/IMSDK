//
//  YGMRLProxy.h
//  mobile
//
//  Created by 1yyg.com on 2017/3/15.
//  Copyright © 2017年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface YGMRLProxy : NSObject
{

}
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

+ (instancetype)sharedManager;
- (void)initWithMRL:(NSString*) mrl updSocket:(GCDAsyncUdpSocket*) socket;

- (void)initWithMRL:(NSString*) mrl ;

@end
