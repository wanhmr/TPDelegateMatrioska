//
//  ViewController.m
//  TPDelegateMatrioskaDemo
//
//  Created by Tpphha on 2017/7/22.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "ViewController.h"
#import "TPTestServer.h"

@interface ViewController () <TPTestServerDelegate>

@end

@implementation ViewController

- (void)server:(TPTestServer *)server didReceiveMsg:(NSString *)msg {
    NSLog(@"ViewController did receiveMsg: %@", msg);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[TPTestServer sharedServer] addDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
