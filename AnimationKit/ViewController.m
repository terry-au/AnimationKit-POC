//
//  ViewController.m
//  AnimationTest
//
//  Created by Terry Lewis on 16/03/2016.
//  Copyright © 2016 Terry Lewis. All rights reserved.
//

#import "ViewController.h"
#import "NIFPercentDrivenAnimation.h"
#import "NIFAnimationQueue.h"
#import "NIFBasicQueueableAnimation.h"
#import "NIFSpringQueueableAnimation.h"
#import "NIFQueueablePercentDrivenAnimation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    redView.center = self.view.center;
    redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:redView];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    myLabel.center = self.view.center;
    [self.view addSubview:myLabel];
    
    NSString *desiredString = @"The quick brown fox jumps over the lazy .";
    
    [NIFPercentDrivenAnimation animateWithDuration:5.0 curve:NIFAnimationCurveLinear applier:^(CGFloat progress) {
        NSUInteger maxIndex = desiredString.length * progress;
        NSString *interpolatedString = [desiredString substringToIndex:maxIndex];
        myLabel.text = interpolatedString;
    } completion:nil];
    
    NIFAnimationQueue *queue = [[NIFAnimationQueue alloc] init];
    queue.processingMode = NIFAnimationQueueProcessingModeContinueAfterCompletion;
    
    NIFBasicQueueableAnimation *animaaa = [NIFBasicQueueableAnimation animationWithDuration:1 animations:^{
        redView.transform = CGAffineTransformMakeScale(3, 3);
    } completion:^(BOOL completion) {
        NSLog(@"Completed");
    }];
    
    [queue enqueueAnimation:animaaa];
    
    
    
    NIFBasicQueueableAnimation *animaaa2 = [NIFBasicQueueableAnimation animationWithDuration:1 animations:^{
        redView.backgroundColor = [UIColor purpleColor];
    } completion:^(BOOL completion) {
        NSLog(@"Completed2");
    }];
    
    [queue enqueueAnimation:animaaa2];
    
    NIFSpringQueueableAnimation *spring1 =
    [NIFSpringQueueableAnimation animationWithDuration:1
                                                 delay:0
                                usingSpringWithDamping:0.3
                                 initialSpringVelocity:0.5
                                               options:0
                                            animations:^{
                                                
                                                [NIFPercentDrivenAnimation animateWithDuration:0.3 curve:NIFAnimationCurveLinear applier:^(CGFloat progress) {
                                                    redView.layer.cornerRadius = progress * 8;
                                                } completion:nil];
                                                redView.transform = CGAffineTransformScale(redView.transform, 2, 2);
                                                CGRect currF = redView.frame;
                                                CGRectApplyAffineTransform(currF, CGAffineTransformScale(redView.transform, 2, 2));
                                                
                                            } completion:^(BOOL completion) {
                                                NSLog(@"Spring finished");
                                            }];
    
    [queue enqueueAnimation:spring1];
    
    [queue startAnimationsWithCompletionBlock:^(BOOL completion) {
        NSLog(@"Completed queue");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
