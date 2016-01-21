//
//  LPPercentLabel.h
//  LPNumberAnimationDemo
//
//  Created by litt1e-p on 16/1/18.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LPPercentLayer;

@interface LPPercentLabel : NSObject

@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;                                                                                                                          

- (instancetype)initWithView:(UIView *)animateView
                         key:(NSString *)key
                        from:(CGFloat)fromValue
                          to:(CGFloat)toValue
                    duration:(NSTimeInterval)duration;

- (void)startAnimate;

@end

//=========================================/

@protocol LPPercentDelegate <NSObject>

- (void)layer:(LPPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue;
- (void)layerDidStopAnimation;

@end

@interface LPPercentLayer : CALayer

@property (strong, nonatomic) id<LPPercentDelegate> tweenDelegate;
@property (assign, nonatomic) CGFloat fromValue;
@property (assign, nonatomic) CGFloat toValue;
@property (assign, nonatomic) NSTimeInterval tweenDuration;


- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;
- (void)startAnimation;

@end