//
//  ViewController.m
//  LPNumberAnimationDemo
//
//  Created by litt1e-p on 16/1/18.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "ViewController.h"
#import "LPPercentLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *circleBaseView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, assign) NSInteger backgroundColorIndex;
@property (nonatomic, strong) NSArray *backgroundColors;

@end

@implementation ViewController

static NSString *const kBorderScaleAnimation = @"kBorderScaleAnimation";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat circleViewBorderWidth = 2.f;
    self.circleBaseView.layer.cornerRadius = 150 / 2;
//    self.circleBaseView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.circleBaseView.layer.borderWidth = circleViewBorderWidth;
    self.circleBaseView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.4];
    
    self.borderView = [[UIView alloc] init];
    self.borderView.frame = (CGRect){{0, 0}, {self.circleBaseView.frame.size.width + circleViewBorderWidth, self.circleBaseView.frame.size.height + circleViewBorderWidth}};
    self.borderView.center = self.circleBaseView.center;
    self.borderView.layer.cornerRadius = 150 /2;
    self.borderView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.2];
//    self.borderView.layer.borderColor = [UIColor colorWithWhite:0.972 alpha:1.000].CGColor;
//    self.borderView.layer.borderWidth = 1.f;
    [self.colorView addSubview:self.borderView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startAnimation];
}

- (void)startAnimation
{
    CGFloat fromNum           = 0.f;
    CGFloat toNum             = 90.f;
    NSTimeInterval duration   = 2.5;
    LPPercentLabel *percentLabel     = [[LPPercentLabel alloc] initWithView:self.progressLabel key:@"text" from:fromNum to:toNum duration:duration];
    self.backgroundColorIndex = 0;
    [self setUpBackgroundColorsWithEndProgress:toNum];
    [self startBackgroundColorAnimationWithDuration:duration delay:0];
    [percentLabel startAnimate];
    [self startBorderAnimationWithDuration:duration];
}

- (void)startBackgroundColorAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    [UIView animateWithDuration:duration / self.backgroundColors.count delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.colorView.backgroundColor = self.backgroundColors[self.backgroundColorIndex];
    } completion:^(BOOL finished) {
        if (self.backgroundColorIndex < self.backgroundColors.count - 1) {
            ++ self.backgroundColorIndex;
            [self startBackgroundColorAnimationWithDuration:duration delay:delay];
        }
    }];
}

- (void)setUpBackgroundColorsWithEndProgress:(CGFloat)endProgress
{
    NSMutableArray *colorsArray = [NSMutableArray array];
    if (endProgress <= 30) {
        [colorsArray addObject:(id)[UIColor redColor]];
    }
    if (endProgress > 30 && endProgress <= 80 ) {
        [colorsArray addObject:(id)[UIColor colorWithRed:1.000 green:0.613 blue:0.041 alpha:1.000]];
        [colorsArray addObject:(id)[UIColor colorWithRed:0.737 green:0.845 blue:0.042 alpha:1.000]];
    }
    if (endProgress > 80) {
        [colorsArray addObject:(id)[UIColor colorWithRed:1.000 green:0.288 blue:0.034 alpha:1.000]];
        [colorsArray addObject:(id)[UIColor colorWithRed:0.943 green:0.570 blue:0.000 alpha:1.000]];
        [colorsArray addObject:(id)[UIColor colorWithRed:0.686 green:0.909 blue:0.029 alpha:1.000]];
        [colorsArray addObject:(id)[UIColor colorWithRed:0.435 green:0.819 blue:0.000 alpha:1.000]];
    }
    self.backgroundColors = [colorsArray copy];
}

- (void)startBorderAnimationWithDuration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration          = duration / 4;
    animation.repeatCount       = MAXFLOAT;
    animation.autoreverses      = YES;
    animation.fromValue         = [NSNumber numberWithFloat:1.0];
    animation.toValue           = [NSNumber numberWithFloat:1.08];
    [self.borderView.layer addAnimation:animation forKey:kBorderScaleAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
