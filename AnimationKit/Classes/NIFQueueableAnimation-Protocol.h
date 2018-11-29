//
//  NIFQueueableAnimation-Protocol.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIFAnimationQueue;

@protocol NIFQueueableAnimation <NSObject>

@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat delay;
@property (nonatomic, retain) NIFAnimationQueue *queue;

- (void)start;
- (void)invokeCompletionBlockWithFinished:(BOOL)finished;
- (void)invokeAnimationBlock;
- (void)_didCompleteAnimationFinished:(BOOL)finished;

@end
