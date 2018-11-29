//
//  NIFQueueableAnimationCompletionBlock.m
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "NIFQueueableAnimationCompletionBlock.h"
#import "NIFQueuableAnimationBase.h"
#import "NIFQueueableAnimation-Protocol.h"

@implementation NIFQueueableAnimationCompletionBlock

+ (instancetype)completionBlockWithCompletionBlock:(NIFCompletionBlock)completionBlock{
    return [[self alloc] initWithCompletionBlock:completionBlock];
}

- (instancetype)initWithCompletionBlock:(NIFCompletionBlock)completionBlock{
    if (self = [super init]) {
        self.completion = completionBlock;
    }
    return self;
}

- (void)invokeCompletionBlockWithFinished:(BOOL)finished processingMode:(NIFAnimationQueueProcessingMode)processingMode{
    if (processingMode == NIFAnimationQueueProcessingModeContinueBeforeCompletion) {
        [self.animation _didCompleteAnimationFinished:finished];
    }
    
    self.completion(finished);
    
    if (processingMode == NIFAnimationQueueProcessingModeContinueAfterCompletion) {
        [self.animation _didCompleteAnimationFinished:finished];
    }
}

@end
