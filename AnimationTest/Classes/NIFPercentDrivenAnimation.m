//
//  NIFPercentDrivenAnimation.m
//  AnimationTest
//
//  Created by Terry Lewis on 17/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFPercentDrivenAnimation.h"
#import "NIFPercentDrivenAnimationEngine.h"

@implementation NIFPercentDrivenAnimation

+ (void)animateWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion{
    NIFPercentDrivenAnimation *animation = [[NIFPercentDrivenAnimation alloc] init];
    animation.duration = duration;
    animation.timingFunction = timingFunction;
    animation.applier = applier;
    animation.completion = completion;
    [animation start];
}

+ (void)animateWithDuration:(CGFloat)duration curve:(NIFAnimationCurve)curve applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion{
    NIFMediaTimingFunction *timingFunction = [NIFMediaTimingFunction functionWithAnimationCurve:curve];
    [self animateWithDuration:duration timingFunction:timingFunction applier:applier completion:completion];
}

- (instancetype)init{
    if ([super init]) {
        _frameInterval = 1;
    }
	return self;
}

- (void)start{
    [[NIFPercentDrivenAnimationEngine sharedEngine] startAnimation:self];
}

- (void)stop{
    [[NIFPercentDrivenAnimationEngine sharedEngine] stopAnimation:self];
}

- (BOOL)isRunning{
    return [[NIFPercentDrivenAnimationEngine sharedEngine] isRunningAnimation:self];
}

- (void)setTimingFunctionFromAnimationCurve:(NIFAnimationCurve)animationCurve{
	NIFMediaTimingFunction *timingFunction = [NIFMediaTimingFunction functionWithAnimationCurve:animationCurve];
	self.timingFunction = timingFunction;
}

- (CGFloat)elapsedTime{
    return self.lastFireTime - self.startTime;
}

//This method will slow down the animation depending on the system's animation speed.
//UIAnimationDragCoefficient() is private, unfortunately.
//- (void)setDuration:(CGFloat)duration{
//    _duration = duration * UIAnimationDragCoefficient();
//}

- (void)setFrameInterval:(NSInteger)frameInterval{
    if (frameInterval <= 0) {
        [NSException raise:@"Invalid Frame Interval" format:@"Frame interval must be greater than zero"];
    }
    
    if (_frameInterval != frameInterval) {
        _frameInterval = frameInterval;
        [[NIFPercentDrivenAnimationEngine sharedEngine] updateAnimation:self];
    }
}

- (CGFloat)_solveForInput:(CGFloat)input{
    CGFloat result = 0.0f;
    static CGFloat oldResult = 0;
    if (self.timingFunction) {
        result = [self.timingFunction valueForX:input];
        NSLog(@"%f", result - oldResult);
//        NSLog(@"%f", input);
        oldResult = result;
//        NSLog(@"%f", result);
    }
    return result;
}

- (void)_reset{
    self.startTime = 0.0f;
    self.lastFireTime = 0.0f;
}

- (void)_getEffectiveElapsedTime:(CGFloat *)elapsedTime finished:(BOOL *)finished{
    if (elapsedTime) {
        *elapsedTime = self.elapsedTime;
    }
    
    if (finished) {
        *finished = self.elapsedTime > self.duration;
    }
}

- (void)_invokeCompletionWithFinished:(BOOL)finished{
    if (self.completion) {
        self.completion(finished);
    }
}

- (void)_invokeApplierWithProgress:(CGFloat)progress{
    if (self.applier) {
        self.applier(progress);
    }
}

@end