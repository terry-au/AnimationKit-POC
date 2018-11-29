//
//  NIFBasicQueueableAnimation.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFBasicQueueableAnimation.h"

@implementation NIFBasicQueueableAnimation

+ (instancetype)animationWithDuration:(CGFloat)duration animations:(NIFAnimationBlock)animations{
    return [self animationWithDuration:duration animations:animations completion:nil];
}

+ (instancetype)animationWithDuration:(NSTimeInterval)duration animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    
    return [self animationWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone animations:animations completion:completion];
}

+ (instancetype)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    if (!animations) {
        return nil;
    }
    
    return [[self alloc] initWithDuration:duration
                                    delay:delay
                                  options:options
                               animations:animations
                               completion:completion];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    
    if (self = [super initWithAnimation:animations completion:completion]) {
        self.duration = duration;
        self.delay = delay;
        self.animationOptions = options;
    }
    return self;
}

- (void)invokeAnimationBlock{
    if (self.animation) {
//        self.animation();
        [UIView animateWithDuration:self.duration
                              delay:self.delay
                            options:self.animationOptions
                         animations:self.animation
                         completion:^(BOOL finished) {
                             [self invokeCompletionBlockWithFinished:finished];
                         }];
    }
}

@end
