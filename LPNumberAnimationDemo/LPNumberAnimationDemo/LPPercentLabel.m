//
//  LPPercentLabel.m
//  LPNumberAnimationDemo
//
//  Created by litt1e-p on 16/1/18.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "LPPercentLabel.h"

@interface LPPercentLabel()<LPPercentDelegate>

@property (nonatomic, strong) LPPercentLayer *layer;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, copy) NSString *key;

@end

@implementation LPPercentLabel

- (instancetype)initWithView:(UIView *)animateView
                         key:(NSString *)key
                        from:(CGFloat)fromValue
                          to:(CGFloat)toValue
                    duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        self.animateView = animateView;
        self.key = key;
        self.layer = [[LPPercentLayer alloc] init];
        self.layer.fromValue = fromValue;
        self.layer.toValue = toValue;
        self.layer.tweenDuration = duration;
        self.layer.tweenDelegate = self;
        [self.animateView.layer addSublayer:self.layer];
    }
    return self;
}

- (void)startAnimate
{
    [self.layer startAnimation];
}

- (void)layer:(LPPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue
{
    int percent = (int)toValue;
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    [self.animateView setValue:text forKey:self.key];
}

- (void)layerDidStopAnimation
{
    int percent = (int)self.layer.toValue;
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    [self.animateView setValue:text forKey:self.key];
    [self.layer removeFromSuperlayer];
}

@end

@interface LPPercentLayer()

@property (assign, nonatomic) CGFloat animatableProperty;
@property (assign, nonatomic) CGFloat delay;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

@end

@implementation LPPercentLayer
@dynamic animatableProperty;

static NSString * const kAnimatableProperty = @"animatableProperty";

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration
{
    self = [super init];
    if (self) {
        self.fromValue = fromValue;
        self.toValue   = toValue;
        self.duration  = duration;
    }
    return self;
}

- (void)startAnimation
{
    self.animatableProperty = self.toValue;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    
    if ([key isEqualToString:kAnimatableProperty]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if (![event isEqualToString:kAnimatableProperty]) {
        return [super animationForKey:event];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
    animation.timingFunction    = self.timingFunction;
    animation.fromValue         = [NSNumber numberWithFloat:self.fromValue];
    animation.toValue           = [NSNumber numberWithFloat:self.toValue];
    animation.duration          = self.tweenDuration;
    animation.beginTime         = CACurrentMediaTime() + self.delay;
    animation.delegate          = self;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.tweenDelegate layerDidStopAnimation];
}

- (void)display
{
    if (self.presentationLayer) {
        LPPercentLayer *layer = (LPPercentLayer *)self.presentationLayer;
        [self.tweenDelegate layer:self didSetAnimationPropertyTo:layer.animatableProperty];
    }
}

@end