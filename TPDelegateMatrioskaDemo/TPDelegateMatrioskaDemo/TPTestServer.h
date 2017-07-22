//
//  TPTestServer.h
//  TPDelegateMatrioskaDemo
//
//  Created by Tpphha on 2017/7/22.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPTestServer;

@protocol TPTestServerDelegate <NSObject>

- (void)server:(TPTestServer *)server didReceiveMsg:(NSString *)msg;

@end

@interface TPTestServer : NSObject
+ (instancetype)sharedServer;

- (void)addDelegate:(id<TPTestServerDelegate>)aDelegate;

@end
