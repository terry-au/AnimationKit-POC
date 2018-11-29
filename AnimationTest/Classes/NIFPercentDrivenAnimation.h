//
//  NIFPercentDrivenAnimation.h
//  AnimationTest
//
//  Created by Terry Lewis on 16/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "NIFMediaTimingFunction.h"
#import "NIFAnimationBlocks.h"

@class NIFMediaTimingFunction;


@interface NIFPercentDrivenAnimation : NSObject

+ (void)animateWithDuration:(CGFloat)duration timingFunction:(NIFMediaTimingFunction *)timingFunction applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion;

+ (void)animateWithDuration:(CGFloat)duration curve:(NIFAnimationCurve)curve applier:(NIFProgressBlock)applier completion:(NIFCompletionBlock)completion;

@property (nonatomic) CGFloat lastFireTime;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) NSInteger frameInterval;
@property (copy, nonatomic) NIFCompletionBlock completion;
@property (copy, nonatomic) NIFProgressBlock applier;
@property (retain, nonatomic) NIFMediaTimingFunction *timingFunction;
@property (nonatomic) CGFloat duration;
@property (readonly, nonatomic) CGFloat elapsedTime;

- (instancetype)init;

- (void)start;
- (void)stop;
- (BOOL)isRunning;

- (void)setTimingFunctionFromAnimationCurve:(NIFAnimationCurve)animationCurve;

//explicity declare block-setters, this allows Xcode to automatically generate a block signature when hitting the enter key when code-autocomplete is enabled.
- (void)setApplier:(NIFProgressBlock)applier;
- (void)setCompletion:(NIFCompletionBlock)completion;

@end

#import "NIFPercentDrivenAnimation-Private.h"