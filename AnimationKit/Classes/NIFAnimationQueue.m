//
//  NIFAnimationQueue.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFAnimationQueue.h"
#import "NIFQueuableAnimationBase.h"

@implementation NIFAnimationQueue{
    BOOL _stopped;
}

- (instancetype)init{
    if (self = [super init]) {
        _stopped = YES;
        _paused = NO;
        _animations = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (void)enqueueAnimation:(id<NIFQueueableAnimation>)animation{
    if (animation) {
        animation.queue = self;
        [_animations addObject:animation];
    }
    NSLog(@"%i", _stopped);
    if ([self _stopped] == NO && !self.currentAnimation) {
        [self _startNextAnimation];
    }
}

- (void)_completeAnimation:(id<NIFQueueableAnimation>)animation{
    [_animations removeObject:animation];
    [self _startNextAnimation];
}

- (void)start{
    [self startAnimationsWithCompletionBlock:nil];
}

- (void)startAnimationsWithCompletionBlock:(NIFCompletionBlock)completionBlock{
    _paused = NO;
    _stopped = NO;
    self.queueCompletionBlock = completionBlock;
    [self _startNextAnimation];
}

- (void)cancel{
    [self stopWithFinished:NO];
}

- (void)pause{
    _paused = YES;
}

- (BOOL)_stopped{
    return _paused == _stopped == NO;
}

- (void)stopWithFinished:(BOOL)finished{
    _stopped = YES;
    if (self.queueCompletionBlock) {
        self.queueCompletionBlock(finished);
    }
}

- (void)_startNextAnimation{
    if ([self _stopped] == NO && _animations.count) {
        NIFQueuableAnimationBase *animation = [_animations firstObject];
        self.currentAnimation = animation;
        [animation start];
    }else{
        self.currentAnimation = nil;
        if (self.stopQueueOnFinish) {
            [self stopWithFinished:YES];
        }
        [self stopWithFinished:YES];
    }
}

@end
