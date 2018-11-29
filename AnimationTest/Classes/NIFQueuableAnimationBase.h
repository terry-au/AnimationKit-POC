//
//  NIFQueuedAnimation.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "NIFAnimationBlocks.h"
#import "NIFQueueableAnimation-Protocol.h"

@interface NIFQueuableAnimationBase : NSObject <NIFQueueableAnimation>

@property (nonatomic, copy) NIFAnimationBlock animation;

//setting the completion block wraps the completion block into a block with a callback, this callback notifies the queue when the animation has completed
@property (nonatomic, copy) NIFCompletionBlock completion;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAnimation:(NIFAnimationBlock)animation completion:(NIFCompletionBlock)completion NS_DESIGNATED_INITIALIZER;

- (void)setCompletion:(NIFCompletionBlock)completion;

@end
