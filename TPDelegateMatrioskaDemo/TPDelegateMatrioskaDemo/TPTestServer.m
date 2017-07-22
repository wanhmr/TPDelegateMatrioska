//
//  TPTestServer.m
//  TPDelegateMatrioskaDemo
//
//  Created by Tpphha on 2017/7/22.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPTestServer.h"
#import <TPDelegateMatrioska.h>

@interface TPTestServer ()
@property (nonatomic, weak) id<TPTestServerDelegate> delegate;
@property (nonatomic, strong) TPDelegateMatrioska *matrioska;
@property (nonatomic, strong) NSTimer *msgTimer;
@end


@implementation TPTestServer

+ (instancetype)sharedServer {
    static TPTestServer *server;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[self alloc] init];
    });
    return server;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _matrioska = [[TPDelegateMatrioska alloc] initWithQOS:NSQualityOfServiceUserInitiated];
        _delegate =(id<TPTestServerDelegate>)_matrioska;
        _msgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(msgTimerUpdate) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)addDelegate:(id<TPTestServerDelegate>)aDelegate {
    [_matrioska addDelegate:aDelegate];
}


- (void)msgTimerUpdate {
    if ([self.delegate respondsToSelector:@selector(server:didReceiveMsg:)]) {
        [self.delegate server:self didReceiveMsg:[NSProcessInfo processInfo].globallyUniqueString];
    }
}

@end
