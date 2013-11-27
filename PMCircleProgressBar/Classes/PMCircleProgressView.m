//
//  PMCircleProgressView.m
//  PMCircleProgressBar
//
//  Created by Taku Inoue on 2013/11/07.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import "PMCircleProgressView.h"

#define kPMCircleProgressInnerRadiusDefault 5
#define PMCircleProgressTintColorDefault [UIColor blueColor];
#define PMCircleProgressBackgroundTintColorDefault [UIColor lightGrayColor];

#define DEGREES_TO_RADIANS(degrees) ((M_PI * (degrees - 90))/180)
#define PROGRES_TO_RADIANS(progress)((M_PI * (360 * progress - 90))/180)

@interface PMCircleProgressView(){
}

//Private properties
@property (nonatomic, assign) float progress; // 0 ~ 1
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic) CAShapeLayer *innerCircleLayer;
@property (nonatomic, copy) PMCircleProgressViewAnimationBlock block;

@end

@implementation PMCircleProgressView

@synthesize innerPadding = innerPadding_;
@synthesize progress = progress_;
@synthesize duration = duration_;

#pragma mark -- Initializer --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Default Params
        self.innerPadding = kPMCircleProgressInnerRadiusDefault;
        self.circleTintColor = PMCircleProgressTintColorDefault;
        self.progress = 0.f;
        self.isShowInnerShadow = NO;
        self.isShowBackShadow = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.percentageLabel = [[PMAnimationLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 20)];
        self.percentageLabel.delegate = self;
        self.percentageLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.percentageLabel.backgroundColor = [UIColor clearColor];
        self.percentageLabel.textColor = [UIColor whiteColor];
        self.percentageLabel.font = [UIFont boldSystemFontOfSize:22];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        self.percentageLabel.text = @"0%";
        self.percentageLabel.suffix = @"%";
        [self addSubview:self.percentageLabel];
    }
    return self;
}

#pragma mark -- Class methods --

- (void)setProgress:(float)progress duration:(NSTimeInterval)duration block:(PMCircleProgressViewAnimationBlock)block{
    
    progress_ = progress;
    duration_ = duration;
    self.block = block;

    [self layoutInnerCircle];
    [self startCircleAnimation];
    [self bringSubviewToFront:self.percentageLabel];
}

#pragma mark -- Private Methods --

-(void)changeAppearanceFormValue:(float)value{
    
    if (value < 20.f) {
        self.innerCircleLayer.strokeColor = [UIColor redColor].CGColor;
    }else if (value < 50.f){
        self.innerCircleLayer.strokeColor = [UIColor yellowColor].CGColor;
    }else{
        self.innerCircleLayer.strokeColor = [UIColor greenColor].CGColor;
    }
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
                                                                  radius:radius/2
                                                              startAngle:DEGREES_TO_RADIANS(0.f)
                                                                endAngle:DEGREES_TO_RADIANS(360.f)
                                                               clockwise:YES];
    [self.circleBackgroundTintColor setStroke];
    backCirclePath.lineWidth = radius;
    [backCirclePath stroke];
    
    // Draw back circle shadow
    if (self.isShowBackShadow) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, backCirclePath.CGPath);
        CGContextSetLineWidth(context, radius);
        CGContextSetShadowWithColor(context, CGSizeMake(1.0, 1.0), 5.0, [UIColor colorWithWhite:0.000 alpha:0.5].CGColor);
        CGContextStrokePath(context);
    }
    
    // Inner circle
//    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
//                                                                   radius:radius/2+10
//                                                               startAngle:PROGRES_TO_RADIANS(preProgress_)
//                                                                 endAngle:PROGRES_TO_RADIANS(progress_)
//                                                                clockwise:YES];
//    [self.circleTintColor setStroke];
//    innerCirclePath.lineWidth = radius - 20;
//    [innerCirclePath stroke];
}

-(void)layoutInnerCircle{
    
//    if (self.innerCircleLayer) {
//        [self.innerCircleLayer removeFromSuperlayer];
//        self.innerCircleLayer = nil;
//    }
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2 - 5;
    
    // Inner circle
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:(radius+self.innerPadding)/2
                                                               startAngle:PROGRES_TO_RADIANS(0.f)
                                                                 endAngle:PROGRES_TO_RADIANS(progress_)
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
        self.innerCircleLayer.shadowOffset = CGSizeMake(5.f, 5.f);
        self.innerCircleLayer.shadowOpacity = 0.5;
    }
    
    [self.layer addSublayer:self.innerCircleLayer];
}

-(void)startCircleAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration_;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.innerCircleLayer addAnimation:animation forKey:@"circleAnimation"];
    
    [self.percentageLabel animationFrom:0.f to:self.progress*100 withDuration:duration_];
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
