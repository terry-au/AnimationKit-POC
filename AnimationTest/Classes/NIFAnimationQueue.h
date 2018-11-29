//
//  NIFAnimationQueue.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIFAnimationBlocks.h"
#import "NIFQueueableAnimation-Protocol.h"

typedef NS_ENUM(NSInteger, NIFAnimationCompletionBlockExecutionMode){
    NIFAnimationCompletionBlockExecutionModeOnce,
    NIFAnimationCompletionBlockExecutionModeAlways
};

@class NIFQueueableAnimation;

@interface NIFAnimationQueue : NSObject

@property (nonatomic, readonly) NSMutableOrderedSet *animations;


/**
 *  Starts the animation queue, a completion block may be supplied that will
 *  complete when the final animation executes, or, if configured, when the 
 *  queue is cancelled whilst executeCompletionBlockOnCancel is YES.
 *
 *  @param completionBlock The block to be executed when all animations have been completed.
 */
- (void)startAnimationsWithCompletionBlock:(NIFCompletionBlock)completionBlock;

/**
 *  Cancels the animation queue's execution. This will call the queue's completion block
 *  if executeCompletionBlockOnCancel is YES and queueCompletionBlock exists.
 */
- (void)cancel;

/**
 *  Pauses the animation queue. This will not pause any active animations.
 *  Instead; it will pause the queue after the current animation (if any) has
 *  been completed.
 */
- (void)pause;

/**
 *  Enqueues an animation. Animations are added to the end of the queue.
 *
 *  @param animation The animation to be added to the queue.
 */
- (void)enqueueAnimation:(id<NIFQueueableAnimation>)animation;


/**
 *  The pause state of the queue.
 *
 *  YES if the queue is paused, NO if the queue is not.
 */
@property (nonatomic, readonly) BOOL paused;

/**
 *  Returns the currently executing animation.
 */
@property (nonatomic, weak) id<NIFQueueableAnimation> currentAnimation;

/**
 *  The queue processing mode determines when a new animation should begin.
 *  This can be before or after the animation's completion block.
 *
 *  The default is NIFAnimationQueueProcessingModeContinueAfterCompletion (after)
 */
@property (nonatomic) NIFAnimationQueueProcessingMode processingMode;

/**
 *  The way in which the completion block is managed by the queue.
 *
 *  If set to NIFAnimationCompletionBlockExecutionModeOnce the completion block will be
 *  cleared once it has been executed.
 *
 *  If set to NIFAnimationCompletionBlockExecutionModeAlways the completion block will be
 *  executed whenever the queue completes, including when animations are added to an active
 *  but idling queue.
 */
@property (nonatomic) NIFAnimationCompletionBlockExecutionMode completionBlockExecutionMode;

/**
 *  Queue completion block. This block is called when all of the pending animations
 *  have been completed.
 */
@property (nonatomic, copy) NIFCompletionBlock queueCompletionBlock;

/**
 *  YES if the queue should be stopped when all of the pending animations have
 *  completed. Useful when enqueueing a new animation should automatically execute it
 *
 *  Default is YES
 */
@property (nonatomic, readonly) BOOL stopQueueOnFinish;

/**
 *  Whether the completion block should be executed when the queue is cancelled.
 *
 *  Default is NO
 */
@property (nonatomic, readonly) BOOL executeCompletionBlockOnCancel;

@end
