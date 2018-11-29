//
//  NIFBasicQueueableAnimation.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueuableAnimationBase.h"

@interface NIFBasicQueueableAnimation : NIFQueuableAnimationBase

+ (instancetype)animationWithDuration:(CGFloat)duration animations:(NIFAnimationBlock)animations;
+ (instancetype)animationWithDuration:(NSTimeInterval)duration animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion;
+ (instancetype)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(NIFAnimationBlock)animations completion:(NIFCompletionBlock)completion;

@property (nonatomic) UIViewAnimationOptions animationOptions;

@end
