//
//  NIFAnimationQueue-Private.h
//  AnimationTest
//
//  Created by Terry Lewis on 18/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#ifndef NIFAnimationQueue_Private_h
#define NIFAnimationQueue_Private_h

@class NIFQueueableAnimation;

@interface NIFAnimationQueue ()

- (void)_startNextAnimation;
- (void)_completeAnimation:(id<NIFQueueableAnimation>)animation;

@end


#endif /* NIFAnimationQueue_Private_h */
