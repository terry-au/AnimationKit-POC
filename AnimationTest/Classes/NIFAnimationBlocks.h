//
//  NIFAnimationBlocks.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#ifndef NIFAnimationBlocks_h
#define NIFAnimationBlocks_h

#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger, NIFAnimationQueueProcessingMode){
    NIFAnimationQueueProcessingModeContinueBeforeCompletion,
    NIFAnimationQueueProcessingModeContinueAfterCompletion
};

typedef void (^NIFProgressBlock) (CGFloat progress);
typedef void (^NIFCompletionBlock) (BOOL completion);
typedef void (^NIFAnimationBlock) (void);


#endif /* NIFAnimationBlocks_h */
