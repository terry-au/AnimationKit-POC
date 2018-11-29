//
//  NIFMediaTimingFunction.m
//  AnimationTest
//
//  Created by Terry Lewis on 16/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFMediaTimingFunction.h"

@implementation NIFMediaTimingFunction{
    CGFloat ax, bx, cx;
    CGFloat ay, by, cy;
    CGPoint _point1, _point2;
}

static CGPoint cappedPoint(CGPoint point){
    CGPoint result;
    result.x = MAX(MIN(point.x, 1.0f), 0.0f);
    result.y = MAX(MIN(point.y, 1.0f), 0.0f);
    return result;
}

+ (NIFMediaTimingFunction *)functionWithAnimationCurve:(NIFAnimationCurve)curve{
    NIFMediaTimingFunction *function = nil;
    if (curve <= 3) {
        NSString *curveIdentfier = nil;
        switch (curve) {
            case 0:
                curveIdentfier = kCAMediaTimingFunctionEaseInEaseOut;
                break;
            case 1:
                curveIdentfier = kCAMediaTimingFunctionEaseIn;
                break;
            case 2:
                curveIdentfier = kCAMediaTimingFunctionEaseOut;
                break;
            case 3:
                curveIdentfier = kCAMediaTimingFunctionLinear;
                break;
        }
        function = [NIFMediaTimingFunction functionWithName:curveIdentfier];
    }
    return function;
}

+ (instancetype)functionWithName:(NSString *)name{
    CGPoint point1, point2;
    
    if ([name isEqualToString:kCAMediaTimingFunctionLinear]) {
        point1 = CGPointMake(0, 0);
        point2 = CGPointMake(1, 1);
    }else if ([name isEqualToString:kCAMediaTimingFunctionEaseIn]) {
        point1 = CGPointMake(0.42, 0);
        point2 = CGPointMake(1, 1);
    }else if ([name isEqualToString:kCAMediaTimingFunctionEaseOut]) {
        point1 = CGPointMake(0, 0);
        point2 = CGPointMake(0.58, 1);
    }else if ([name isEqualToString:kCAMediaTimingFunctionEaseInEaseOut]) {
        point1 = CGPointMake(0.42, 0);
        point2 = CGPointMake(0.58, 1);
    }else if ([name isEqualToString:kCAMediaTimingFunctionDefault]) {
        
        CAMediaTimingFunction *tempFunction = [CAMediaTimingFunction functionWithName:name];
        float coordsA[2];
        float coordsB[2];
        [tempFunction getControlPointAtIndex:1 values:coordsA];
        [tempFunction getControlPointAtIndex:2 values:coordsB];
        point1 = CGPointMake(coordsA[0], coordsA[1]);
        point2 = CGPointMake(coordsB[0], coordsB[1]);
    }
    
    
    NIFMediaTimingFunction *function = [[NIFMediaTimingFunction alloc] initWithControlPoints:point1 point2:point2];
//    NIFMediaTimingFunction *function = [[NIFMediaTimingFunction alloc] initWithControlPoints:1 :1 :1 :1];
    
    return function;
}

- (instancetype)initWithControlPoints:(CGPoint)point1 point2:(CGPoint)point2{
    if (self = [super init]) {
        _point1 = cappedPoint(point1);
        _point2 = cappedPoint(point2);
        self.duration = 1.0f;
        [self setupPointsPolynomial];
    }
    return self;
}

- (void)setDuration:(CGFloat)duration{
    _duration = MAX(0.0f, duration);
}

/**
 *
 *  From: http://opensource.apple.com/source/WebCore/WebCore-955.66/page/animation/AnimationBase.cpp
 *  From: http://opensource.apple.com/source/WebCore/WebCore-955.66/platform/graphics/UnitBezier.h
 *
 */

/*
 * Copyright (C) 2007, 2008, 2009 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1.  Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 * 2.  Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 * 3.  Neither the name of Apple Computer, Inc. ("Apple") nor the names of
 *     its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE AND ITS CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL APPLE OR ITS CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

- (CGFloat)epsilon{
    return 1.0 / (200.0 * self.duration);
}

- (CGFloat)valueForX:(CGFloat)x{
    CGFloat epsilon = [self epsilon];
    CGFloat xSolved = [self solveCurveX:x epsilon:epsilon];
    CGFloat y = [self sampleCurveY:xSolved];
    return y;
}

- (void)setupPointsPolynomial{
    cx = 3.0 * _point1.x;
    bx = 3.0 * (_point2.x - _point1.x) - cx;
    ax = 1.0 - cx -bx;
    
    cy = 3.0 * _point1.y;
    by = 3.0 * (_point2.y - _point1.y) - cy;
    ay = 1.0 - cy - by;
}

- (CGFloat)sampleCurveX:(CGFloat)t
{
    // `ax t^3 + bx t^2 + cx t' expanded using Horner's rule.
    return ((ax * t + bx) * t + cx) * t;
}

- (CGFloat)sampleCurveY:(CGFloat)t
{
    return ((ay * t + by) * t + cy) * t;
}

- (CGFloat)sampleCurveDerivativeX:(CGFloat)t
{
    return (3.0 * ax * t + 2.0 * bx) * t + cx;
}

// Given an x value, find a parametric value it came from.
- (CGFloat)solveCurveX:(CGFloat)x epsilon:(CGFloat)epsilon
{
    CGFloat t0;
    CGFloat t1;
    CGFloat t2;
    CGFloat x2;
    CGFloat d2;
    int i;
    
    // First try a few iterations of Newton's method -- normally very fast.
    for (t2 = x, i = 0; i < 8; i++) {
        x2 = [self sampleCurveX:t2] - x;
        if (fabs(x2) < epsilon) {
            return t2;
        }
        d2 = [self sampleCurveDerivativeX:t2];
        if (fabs(d2) < 1e-6) {
            break;
        }
        t2 = t2 - x2 / d2;
    }
    
    // Fall back to the bisection method for reliability.
    t0 = 0.0;
    t1 = 1.0;
    t2 = x;
    
    if (t2 < t0) {
        return t0;
    }
    if (t2 > t1) {
        return t1;
    }
    
    while (t0 < t1) {
        x2 = [self sampleCurveX:t2];
        if (fabs(x2 - x) < epsilon) {
            return t2;
        }
        if (x > x2) {
            t0 = t2;
        } else {
            t1 = t2;
        }
        t2 = (t1 - t0) * 0.5f + t0;
    }
    
    // Failure.
    return t2;
}

- (CGFloat)solve:(CGFloat)x epsilon:(CGFloat)epsilon
{
    return [self sampleCurveY:[self solveCurveX:x epsilon:epsilon]];
}

@end
