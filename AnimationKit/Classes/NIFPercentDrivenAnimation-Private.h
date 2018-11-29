//
//  NIFPercentDrivenAnimation-Private.h
//  AnimationTest
//
//  Created by Terry Lewis on 17/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#ifndef NIFPercentDrivenAnimation_Private_h
#define NIFPercentDrivenAnimation_Private_h

@class NIFPercentDrivenAnimation;

@interface NIFPercentDrivenAnimation (Private)

- (CGFloat)_solveForInput:(CGFloat)input;
- (void)_reset;
- (void)_getEffectiveElapsedTime:(CGFloat *)elapsedTime finished:(BOOL *)finished;
- (void)_invokeCompletionWithFinished:(BOOL)finished;
- (void)_invokeApplierWithProgress:(CGFloat)progress;

@end

#endif /* NIFPercentDrivenAnimation_Private_h */
