//
//  NIFQueueableAnimationCompletionBlock.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueuableAnimationBase.h"
#import "NIFAnimationBlocks.h"

@class NIFQueuableAnimationBase, NIFQueueableAnimation;

@interface NIFQueueableAnimationCompletionBlock : NSObject

@property (nonatomic, copy) NIFCompletionBlock completion;
@property (nonatomic, retain) id<NIFQueueableAnimation> animation;

+ (instancetype)completionBlockWithCompletionBlock:(NIFCompletionBlock)completionBlock;

- (void)invokeCompletionBlockWithFinished:(BOOL)finished processingMode:(NIFAnimationQueueProcessingMode)processingMode;

@end
