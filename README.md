# AnimationKit POC
This was a fairly successful experiment in implementing an animation engine for iOS which could allow non-animatable properties (UIAnimation) to be animated.
The main selling feature is percent driven animations, which effectively leaves interpolation in the hands of the developer.
This is quite simple, as the animation block provides the current animation's progress as a float 0.0-1.0.

AnimationKit was going to be a fully featured framework – much of the "heavy lifting" is already done, it's just lacking documentation.
The solution itself is quite well optimised, such that it will only dispatch animation updates on common frames, rather than every screen refresh.

## Why would I use this?
It can allow for pretty neat things.
You could, for example, animate a corner radius – this is typically not animatable via UIAnimation, although it can be achieved with CABasicAnimation.
AnimationKit is much nicer, here's an example:

Let's animate the corner radius to 12.0 over 5 seconds.
```
UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
myView.center = self.view.center;
myView.backgroundColor = UIColor.redColor;
[self.view addSubview:myView];

[NIFPercentDrivenAnimation animateWithDuration:5.0 curve:NIFAnimationCurveLinear applier:^(CGFloat progress) {
    myView.layer.cornerRadius = progress * 12;
} completion:nil];
```

Now, let's try to animate typing of text:

```
UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
myLabel.center = self.view.center;
[self.view addSubview:myLabel];

NSString *desiredString = @"The quick brown fox jumps over the lazy .";

[NIFPercentDrivenAnimation animateWithDuration:5.0 curve:NIFAnimationCurveLinear applier:^(CGFloat progress) {
    NSUInteger maxIndex = desiredString.length * progress;
    NSString *interpolatedString = [desiredString substringToIndex:maxIndex];
    myLabel.text = interpolatedString;
} completion:nil];
```

Using this single API greatly simplifies things.
Coupled with queuing functionality and the spring-based animations and some really cool effects can be achieved.