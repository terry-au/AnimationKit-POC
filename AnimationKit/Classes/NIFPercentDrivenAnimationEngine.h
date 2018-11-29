//
//  NIFPercentDrivenAnimationEngine.h
//  AnimationTest
//
//  Created by Terry Lewis on 17/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CADisplayLink;
@class NIFPercentDrivenAnimation;

@interface NIFPercentDrivenAnimationEngine : NSObject{
    NSMutableSet *_animations, *_finishedAnimations;
    CADisplayLink *_displayLink;
}

+ (instancetype)sharedEngine;

- (instancetype)init;
- (BOOL)isRunningAnimation:(NIFPercentDrivenAnimation *)animation;
- (void)stopAnimation:(NIFPercentDrivenAnimation *)animation;
- (void)updateAnimation:(NIFPercentDrivenAnimation *)animation;
- (void)startAnimation:(NIFPercentDrivenAnimation *)animation;

@end
