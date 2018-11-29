//
//  NIFMediaTimingFunction.h
//  AnimationTest
//
//  Created by Terry Lewis on 16/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, NIFAnimationCurve){
    NIFAnimationCurveEaseInEaseOut,
    NIFAnimationCurveEaseIn,
    NIFAnimationCurveEaseOut,
    NIFAnimationCurveLinear
};

@interface NIFMediaTimingFunction : NSObject

+ (NIFMediaTimingFunction *)functionWithAnimationCurve:(NIFAnimationCurve)curve;
+ (instancetype)functionWithName:(NSString *)name;

@property (nonatomic) CGFloat duration;

- (CGFloat)valueForX:(CGFloat)x;

@end
