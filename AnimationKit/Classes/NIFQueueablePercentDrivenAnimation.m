//
//  NIFQueueablePercentDrivenAnimation.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueueablePercentDrivenAnimation.h"
#import "NIFQueueableAnimationCompletionBlock.h"
#import "NIFAnimationQueue.h"
#import "NIFAnimationQueue-Private.h"
#import "NIFMediaTimingFunction.h"

@implementation NIFQueueablePercentDrivenAnimation{
    NIFQueueableAnimationCompletionBlock *_completionBlock;
}

@synthesize delay, queue;

+ (instancetype)animationWithDuration:(CGFloat)duration curve:(NIFAnimationCurve)curve animations:(NIFProgressBlock)animations completion:(NIFCompletionBlock)completion{
    NIFMediaTimingFunction *function = [NIFMediaTimingFunction functionWithAnimationCurve:curve];
    return [self animationWithDuration:duration timingFunction:function animations:animations completion:completion];
}

+ (instancetype)animationWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction animations:(NIFProgressBlock)animations completion:(NIFCompletionBlock)completion{
    return [[self alloc] initWithDuration:duration timingFunction:timingFunction animations:animations completion:completion];
}

- (instancetype)initWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction animations:(NIFProgressBlock)animations completion:(NIFCompletionBlock)completion{
    if (!animations) {
        return nil;
    }
    
    if (self = [super init]) {
        self.duration = duration;
        self.timingFunction = timingFunction;
        self.applier = animations;
        self.completion = completion;
    }
    
    return self;
}

- (void)invokeAnimationBlock{
    [self start];
}

- (void)setCompletion:(NIFCompletionBlock)completion{
    _completionBlock = [NIFQueueableAnimationCompletionBlock completionBlockWithCompletionBlock:completion];
    _completionBlock.animation = self;
}

- (void)_didCompleteAnimationFinished:(BOOL)finished{
    [self.queue _completeAnimation:self];
}

- (NIFCompletionBlock)completion{
    return ^(BOOL finished){
        [self invokeCompletionBlockWithFinished:finished];
    };
}

- (void)invokeCompletionBlockWithFinished:(BOOL)finished{
    if (_completionBlock) {
        [_completionBlock invokeCompletionBlockWithFinished:finished processingMode:self.queue.processingMode];
    }
}

@end
