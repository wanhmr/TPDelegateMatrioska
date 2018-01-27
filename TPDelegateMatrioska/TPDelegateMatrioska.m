//
//  TPDelegateMatrioska.m
//  TPDelegateMatrioska
//
//  Created by Tpphha on 22/07/17.
//  Copyright (c) 2017 Tpphha. All rights reserved.
//  Thanks https://github.com/lukabernardi/LBDelegateMatrioska


#import "TPDelegateMatrioska.h"

@implementation NSInvocation (TPDelegateMatrioskaReturnType)

- (BOOL)methodReturnTypeIsVoid
{
    return (([self.methodSignature methodReturnLength] == 0) ? YES : NO);
}

@end


@interface TPDelegateMatrioska ()
@property (nonatomic, strong) NSPointerArray *mutableDelegates;
@property(nonatomic, strong) NSRecursiveLock *mute;
@end


@implementation TPDelegateMatrioska

- (instancetype)init {
    _mutableDelegates = [NSPointerArray weakObjectsPointerArray];
    _mute = [[NSRecursiveLock alloc] init];
    return self;
}

- (instancetype)initWithDelegates:(NSArray *)delegates {
    self = [self init];
    for (id delegate in delegates) {
        [_mutableDelegates addPointer:(void *)delegate];
    }
    return self;
}

+ (instancetype)defaultMatrioska {
    return [[self alloc] init];
}


- (void)lock {
    [_mute lock];
}

- (void)unlock {
    [_mute unlock];
}

#pragma mark - Public interface

- (NSArray *)delegates
{
    [self lock];
    NSArray *delegates = [_mutableDelegates allObjects];
    [self unlock];
    return delegates;
}


- (void)addDelegate:(id)aDelegate
{
    NSParameterAssert(aDelegate);
    
    [self lock];
    [_mutableDelegates addPointer:(void *)aDelegate];
    [self unlock];
}

- (void)removeDelegate:(id)aDelegate
{
    NSParameterAssert(aDelegate);
    
    [self lock];
    NSUInteger index = 0;
    for (id delegate in _mutableDelegates) {
        if (delegate == aDelegate) {
            [_mutableDelegates removePointerAtIndex:index];
            break;
        }
        index++;
    }
    [self unlock];
}



- (BOOL)containsDelegate:(id)aDelegate {
    NSParameterAssert(aDelegate);
    BOOL result = NO;
    [self lock];
    for (id delegate in self.mutableDelegates) {
        if (delegate == aDelegate) {
            result = YES;
            break;
        }
    }
    [self unlock];
    return result;
}


#pragma mark - NSProxy


- (void)forwardInvocation:(NSInvocation *)invocation
{
    // If the invoked method return void I can safely call all the delegates
    // otherwise I just invoke it on the first delegate that
    // respond to the given selector
    if ([invocation methodReturnTypeIsVoid]) {
        [self lock];
        for (id delegate in self.mutableDelegates) {
            if ([delegate respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:delegate];
            }
        }
        [self unlock];
    } else {
        id firstResponder = [self p_firstResponderToSelector:invocation.selector];
        [invocation invokeWithTarget:firstResponder];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    id firstResponder = [self p_firstResponderToSelector:sel];
    if (firstResponder) {
        return [firstResponder methodSignatureForSelector:sel];
    }
    // https://github.com/facebookarchive/AsyncDisplayKit/pull/1562
    // Unfortunately, in order to get this object to work properly, the use of a method which creates an NSMethodSignature
    // from a C string. -methodSignatureForSelector is called when a compiled definition for the selector cannot be found.
    // This is the place where we have to create our own dud NSMethodSignature. This is necessary because if this method
    // returns nil, a selector not found exception is raised. The string argument to -signatureWithObjCTypes: outlines
    // the return type and arguments to the message. To return a dud NSMethodSignature, pretty much any signature will
    // suffice. Since the -forwardInvocation call will do nothing if the delegate does not respond to the selector,
    // the dud NSMethodSignature simply gets us around the exception.
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];;
}

#pragma mark - NSObject

- (BOOL)respondsToSelector:(SEL)aSelector
{
    id firstResponder = [self p_firstResponderToSelector:aSelector];
    return (firstResponder ? YES : NO);
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    id firstConformed = [self p_firstConformedToProtocol:aProtocol];
    return (firstConformed ? YES : NO);
}

#pragma mark - Private

- (id)p_firstResponderToSelector:(SEL)aSelector
{
    id returnValue = nil;
    [self lock];
    for (id delegate in self.mutableDelegates) {
        if ([delegate respondsToSelector:aSelector]) {
            returnValue = delegate;
            break;
        }
    }
    [self unlock];
    return returnValue;
}

- (id)p_firstConformedToProtocol:(Protocol *)protocol
{
    id returnValue = nil;
    [self lock];
    for (id delegate in self.mutableDelegates) {
        if ([delegate conformsToProtocol:protocol]) {
            returnValue = delegate;
            break;
        }
    }
    [self unlock];
    return returnValue;
}

@end
