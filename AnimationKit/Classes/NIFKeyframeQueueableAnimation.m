//
//  NIFKeyframeQueueableAnimtion.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFKeyframeQueueableAnimation.h"

@implementation NIFKeyframeQueueableAnimation

+ (instancetype)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewKeyframeAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    return [[self alloc] initWithDuration:duration delay:delay options:options animations:animations completion:completion];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewKeyframeAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    if (self = [super initWithAnimation:animations completion:completion]) {
        self.duration = duration;
        self.delay = delay;
        self.keyframeAnimationOptions = options;
    }
    return self;
}

- (void)invokeAnimationBlock{
    [UIView animateKeyframesWithDuration:self.duration
                                   delay:self.delay
                                 options:self.keyframeAnimationOptions
                              animations:self.animation
                              completion:self.completion];
}

@end
