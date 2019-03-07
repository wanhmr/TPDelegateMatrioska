//
//  TPDelegateMatrioska.h
//  TPDelegateMatrioska
//
//  Created by Tpphha on 22/07/17.
//  Copyright (c) 2017 Tpphha. All rights reserved.
//  Thanks https://github.com/lukabernardi/LBDelegateMatrioska

#import <Foundation/Foundation.h>

@interface NSInvocation (TPDelegateMatrioskaReturnType)
- (BOOL)methodReturnTypeIsVoid;
@end


@interface TPDelegateMatrioska : NSProxy 

@property (nonatomic, copy, readonly) NSArray *delegates;

- (instancetype)init;

- (instancetype)initWithDelegates:(NSArray *)delegates;

/**
 NOTE: return value is't a singleton instance
 */
+ (instancetype)defaultMatrioska;


- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (BOOL)containsDelegate:(id)aDelegate;
@end
