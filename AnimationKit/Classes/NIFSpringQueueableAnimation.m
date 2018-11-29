//
//  NIFSpringQueueableAnimation.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFSpringQueueableAnimation.h"
#import <UIKit/UIKit.h>

@implementation NIFSpringQueueableAnimation

+ (instancetype)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    return [[self alloc] initWithDuration:duration
                                    delay:delay
                   usingSpringWithDamping:dampingRatio
                    initialSpringVelocity:velocity
                                  options:options
                               animations:animations
                               completion:completion];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion{
    
    if (self = [super initWithAnimation:animations completion:completion]) {
        self.duration = duration;
        self.delay = delay;
        self.springDampening = dampingRatio;
        self.initialVelocity = velocity;
        self.animationOptions = options;
    }
    
    return self;
}

- (void)invokeAnimationBlock{
    [UIView animateWithDuration:self.duration
                          delay:self.delay
         usingSpringWithDamping:self.springDampening
          initialSpringVelocity:self.initialVelocity
                        options:self.animationOptions
                     animations:self.animation
                     completion:self.completion];
}

@end
