//
//  NIFQueuedAnimation.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueuableAnimationBase.h"
#import <UIKit/UIKit.h>
#import "NIFAnimationQueue.h"
#import "NIFQueueableAnimationCompletionBlock.h"
#import "NIFAnimationQueue-Private.h"

@implementation NIFQueuableAnimationBase{
    NIFQueueableAnimationCompletionBlock *_completionBlock;
}

@synthesize delay, queue, duration;

- (instancetype)initWithAnimation:(NIFAnimationBlock)animation completion:(NIFCompletionBlock)completion{
    if (!animation) {
        return nil;
    }
    
    if (self = [super init]) {
        self.animation = animation;
        self.completion = completion;
    }
    
    return self;
}

- (void)invokeCompletionBlockWithFinished:(BOOL)finished{
    if (_completionBlock) {
        [_completionBlock invokeCompletionBlockWithFinished:finished processingMode:self.queue.processingMode];
    }
}

- (void)invokeAnimationBlock{
}

- (void)start{
    [self invokeAnimationBlock];
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

@end
