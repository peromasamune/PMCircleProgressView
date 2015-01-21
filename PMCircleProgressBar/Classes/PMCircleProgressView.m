//
//  PMCircleProgressView.m
//  PMCircleProgressBar
//
//  Created by Taku Inoue on 2013/11/07.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import "PMCircleProgressView.h"

#define kPMCircleProgressInnerRadiusDefault 0
#define PMCircleProgressTintColorDefault [UIColor colorWithRed:0.008 green:0.741 blue:0.604 alpha:1.000];
#define PMCircleProgressBackgroundTintColorDefault [UIColor lightGrayColor];

#define DEGREES_TO_RADIANS(degrees) ((M_PI * (degrees - 90))/180)
#define PROGRES_TO_RADIANS(progress)((M_PI * (360 * progress - 90))/180)

@interface PMCircleProgressView(){
}

//Private properties
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic) CAShapeLayer *innerCircleLayer;
@property (nonatomic, copy) PMCircleProgressViewAnimationBlock block;

@end

@implementation PMCircleProgressView

#pragma mark -- Initializer --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // Default Params
        _innerPadding = kPMCircleProgressInnerRadiusDefault;
        _circleTintColor = PMCircleProgressTintColorDefault;
        _isShowInnerShadow = NO;
        _isShowBackShadow = NO;
        _circleAlpha = 1.0;
        _progress = 0.1;
        
        _percentageLabel = [[PMAnimationLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 20)];
        _percentageLabel.delegate = self;
        _percentageLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _percentageLabel.backgroundColor = [UIColor clearColor];
        _percentageLabel.textColor = [UIColor whiteColor];
        _percentageLabel.font = [UIFont boldSystemFontOfSize:22];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.text = @"0%";
        _percentageLabel.suffix = @"%";
        [self addSubview:self.percentageLabel];
    }
    return self;
}

#pragma mark -- Class methods --

- (void)setProgress:(float)progress duration:(NSTimeInterval)duration block:(PMCircleProgressViewAnimationBlock)block{
    
    _progress = progress;
    _duration = duration;
    _block = block;

    [self layoutInnerCircle];
    [self startCircleAnimation];
    [self bringSubviewToFront:self.percentageLabel];
}

-(void)setCircleTintColor:(UIColor *)circleTintColor{
    _circleTintColor = (circleTintColor) ? circleTintColor : PMCircleProgressTintColorDefault;

    if (self.innerCircleLayer) {
        self.innerCircleLayer.strokeColor = circleTintColor.CGColor;
    }
}

#pragma mark -- Private Methods --

-(void)changeAppearanceFormValue:(float)value{
//    if (value < 20.f) {
//        self.innerCircleLayer.strokeColor = [UIColor colorWithRed:0.949 green:0.275 blue:0.239 alpha:self.circleAlpha].CGColor;
//    }else if (value < 50.f){
//        self.innerCircleLayer.strokeColor = [UIColor colorWithRed:0.969 green:0.765 blue:0.004 alpha:self.circleAlpha].CGColor;
//    }else{
//        self.innerCircleLayer.strokeColor = [UIColor colorWithRed:0.008 green:0.741 blue:0.604 alpha:self.circleAlpha].CGColor;
//    }
}

#pragma mark -- Draw --

- (void)drawRect:(CGRect)rect
{
    // General params
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2 - 5;
    //CGFloat innerRadius = radius - innerPadding_;
    
    // Back circle
    UIBezierPath *backCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                  radius:(radius + _innerPadding)/2
                                                              startAngle:DEGREES_TO_RADIANS(0.f)
                                                                endAngle:DEGREES_TO_RADIANS(360.f)
                                                               clockwise:YES];
    [self.circleBackgroundTintColor setStroke];
    backCirclePath.lineWidth = radius - _innerPadding;
    [backCirclePath stroke];

    // Draw back circle shadow
    if (self.isShowBackShadow) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, backCirclePath.CGPath);
        CGContextSetLineWidth(context, radius);
        CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), 5.0, [UIColor colorWithWhite:0.000 alpha:0.5].CGColor);
        CGContextStrokePath(context);
    }
}

-(void)layoutInnerCircle{
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2 - 5;
    
    // Inner circle
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:(radius+self.innerPadding)/2
                                                               startAngle:PROGRES_TO_RADIANS(0.f)
                                                                 endAngle:PROGRES_TO_RADIANS(_progress)
                                                                clockwise:YES];
    
    if (self.innerCircleLayer == nil) {
        self.innerCircleLayer = [CAShapeLayer layer];
    }
    self.innerCircleLayer.path = innerCirclePath.CGPath;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.innerCircleLayer.strokeColor = self.circleTintColor.CGColor;
    self.innerCircleLayer.lineWidth = radius - self.innerPadding;
    if (self.isShowInnerShadow) {
        self.innerCircleLayer.shadowColor = [UIColor blackColor].CGColor;
        self.innerCircleLayer.shadowOffset = CGSizeMake(0.f, 0.f);
        self.innerCircleLayer.shadowOpacity = 0.5;
    }
    
    [self.layer addSublayer:self.innerCircleLayer];
}

-(void)startCircleAnimation{
    
    if (self.duration > 0) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = _duration;
        animation.repeatCount = 0;
        animation.removedOnCompletion = NO;
        animation.delegate = self;

        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        [self.innerCircleLayer addAnimation:animation forKey:@"circleAnimation"];
    }
    
    [self.percentageLabel animationFrom:0.f to:self.progress*100 withDuration:_duration];
}

#pragma mark -- CAAnimationDelegate --
-(void)animationDidStart:(CAAnimation *)anim{
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}

#pragma mark -- PMAnimationLabelDelegate
-(void)animationLabelValueDidChange:(long)value{
    [self changeAppearanceFormValue:value];
}

-(void)animationLabelDidFinishAnimation{
    if (self.block != nil) {
        self.block(YES);
    }
}

@end
