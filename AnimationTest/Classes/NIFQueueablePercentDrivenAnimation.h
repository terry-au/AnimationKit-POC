//
//  NIFQueueablePercentDrivenAnimation.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFPercentDrivenAnimation.h"
#import "NIFQueueableAnimation-Protocol.h"

@interface NIFQueueablePercentDrivenAnimation : NIFPercentDrivenAnimation <NIFQueueableAnimation>

+ (void)animateWithDuration:(CGFloat)duration curve:(NIFAnimationCurve)curve applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion NS_UNAVAILABLE;
+ (void)animateWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)animationWithDuration:(CGFloat)duration curve:(NIFAnimationCurve)curve animations:(NIFProgressBlock)animations completion:(NIFCompletionBlock)completion;
+ (instancetype)animationWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction animations:(NIFProgressBlock)animations completion:(NIFCompletionBlock)completion;

@end
