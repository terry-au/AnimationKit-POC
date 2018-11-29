//
//  NIFPercentDrivenAnimationEngine.m
//  AnimationTest
//
//  Created by Terry Lewis on 17/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFPercentDrivenAnimationEngine.h"
#import "NIFPercentDrivenAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface NIFPercentDrivenAnimationEngine ()

- (void)_onDisplayLink:(CADisplayLink *)displayLink;
- (void)_tearDownDisplayLink;
- (void)_ensureDisplayLink;
- (void)_updateDisplayLink;

@end

@implementation NIFPercentDrivenAnimationEngine

+ (instancetype)sharedEngine{
    static NIFPercentDrivenAnimationEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[self alloc] init];
    });
    return sharedEngine;
}

- (instancetype)init{
    if (self = [super init]) {
        _animations = [[NSMutableSet alloc] init];
        _finishedAnimations = [[NSMutableSet alloc] init];
    }
    return self;
}

- (BOOL)isRunningAnimation:(NIFPercentDrivenAnimation *)animation{
    return [_animations containsObject:animation];
}

- (void)stopAnimation:(NIFPercentDrivenAnimation *)animation{
    if ([_animations containsObject:animation]) {
        [animation _invokeCompletionWithFinished:NO];
        [_animations removeObject:animation];
        [self _updateDisplayLink];
    }
    
}

- (void)updateAnimation:(NIFPercentDrivenAnimation *)animation{
    if ([_animations containsObject:animation]) {
        [self _updateDisplayLink];
    }
}

- (void)startAnimation:(NIFPercentDrivenAnimation *)animation{
//    if the duration is the smallest floating point value above 0 or below, the animation is considered complete.
    CGFloat epsilon;
#if defined(__LP64__) && __LP64__
    epsilon = DBL_EPSILON;
#else
    epsilon = FLT_EPSILON;
#endif
    
    if (animation.duration >= epsilon) {
        [animation _reset];
        
        CFTimeInterval currentTime = CACurrentMediaTime();
        [animation setStartTime:currentTime];
        [animation setLastFireTime:currentTime];
        
        [_animations addObject:animation];
        [self _updateDisplayLink];
    }else{
        [animation _invokeApplierWithProgress:1.0f];
        [animation _invokeCompletionWithFinished:YES];
    }
}

- (void)_onDisplayLink:(CADisplayLink *)displayLink{
    [_animations enumerateObjectsUsingBlock:^(NIFPercentDrivenAnimation  *_Nonnull animation, BOOL * _Nonnull stop) {
            [animation setLastFireTime:displayLink.timestamp];
            CGFloat elapsedTime;
            BOOL finished;
            [animation _getEffectiveElapsedTime:&elapsedTime finished:&finished];
            CGFloat duration = animation.duration;
            CGFloat linearProgress = MIN(MAX(elapsedTime / duration, 0.0f), 1.0f);
            CGFloat calculatedProgress = [animation _solveForInput:linearProgress];
            [animation _invokeApplierWithProgress:calculatedProgress];
            
            if (finished) {
                [_finishedAnimations addObject:animation];
            }
    }];
    
    if (_finishedAnimations.count) {
        [_animations minusSet:_finishedAnimations];
        [_finishedAnimations enumerateObjectsUsingBlock:^(NIFPercentDrivenAnimation  *_Nonnull animation, BOOL * _Nonnull stop) {
            [animation _invokeCompletionWithFinished:YES];
        }];
        [_finishedAnimations removeAllObjects];
        [self _updateDisplayLink];
    }
}

- (void)_tearDownDisplayLink{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)_ensureDisplayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_onDisplayLink:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)_updateDisplayLink{
    if ([_animations count]) {
        NSInteger determinedInterval = [_animations.anyObject frameInterval];
        for (NIFPercentDrivenAnimation *animation in _animations) {
            NSInteger currentInterval = animation.frameInterval;
            NSInteger minCurrentInterval = MIN(currentInterval, determinedInterval);
            
//            we need to obtain a lowest common frame rate for the given animation set.
//            consider the following:
//            animationA.frameInterval = 3;
//            animationB.frameInterval = 6;
//            common frame to update is every third.
//            animationC.frameInterval = 2;
//            common frame to update is every frame.
            if (minCurrentInterval) {
                while (determinedInterval % minCurrentInterval || currentInterval % minCurrentInterval){
                    if (!--minCurrentInterval){
                        determinedInterval = 1;
                        break;
                    }
                }
                determinedInterval = minCurrentInterval;
            }
            [self _ensureDisplayLink];
            [_displayLink setFrameInterval:determinedInterval];
        }
    }else{
        [self _tearDownDisplayLink];
    }
}

@end
