//
//  NIFSpringQueueableAnimation.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueuableAnimationBase.h"

@interface NIFSpringQueueableAnimation : NIFQueuableAnimationBase

+ (instancetype)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion;

@property (nonatomic) CGFloat springDampening;
@property (nonatomic) CGFloat initialVelocity;
@property (nonatomic) UIViewAnimationOptions animationOptions;

@end
