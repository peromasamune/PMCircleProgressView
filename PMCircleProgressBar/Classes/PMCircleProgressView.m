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

#define DEGREES_TO_RADIANS(degrees) ((M_PI * (degrees - 90))/180)
#define PROGRES_TO_RADIANS(progress)((M_PI * (360 * progress - 90))/180)

@interface PMCircleProgressView(){
    CAShapeLayer *innerCircleLayer;
}

//Private properties
@property (nonatomic, assign) CGFloat progress, preProgress; // 0 ~ 1

@end

@implementation PMCircleProgressView

@synthesize innerPadding = innerPadding_;
@synthesize progress = progress_;
@synthesize preProgress = preProgress_;

#pragma mark -- Initializer --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Default Params
        self.innerPadding = kPMCircleProgressInnerRadiusDefault;
        self.circleTintColor = PMCircleProgressTintColorDefault;
        self.progress = 0.f;
        self.preProgress = 0.f;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -- Class methods --

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated isResume:(BOOL)isResume block:(PMCircleProgressViewAnimationBlock)block{
    if (!isResume) {
        preProgress_ = 0.f;
    }
    
    //progress_ = progress;
    
    //[self setNeedsDisplay];
    //[self layoutInnerCircle];
    
    double frameRate = 0.0;
    for (int i=0; i < 30; i++) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(frameRate * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setNeedsDisplay];
            progress_ += progress / 30;
        });
        frameRate += 0.1;
    }
}

#pragma mark -- Draw --

- (void)drawRect:(CGRect)rect
{
    // General params
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2 - self.innerPadding - 5;
    //CGFloat innerRadius = radius - innerPadding_;
    
    // Back circle
    UIBezierPath *backCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                  radius:radius
                                                              startAngle:DEGREES_TO_RADIANS(0.f)
                                                                endAngle:DEGREES_TO_RADIANS(360.f)
                                                               clockwise:YES];
    [self.circleTintColor setStroke];
    backCirclePath.lineWidth = innerPadding_;
    [backCirclePath stroke];
    
    // Draw back circle shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, backCirclePath.CGPath);
    CGContextSetLineWidth(context, innerPadding_);
    CGContextSetShadowWithColor(context, CGSizeMake(5.0, 5.0), 3.0, [UIColor colorWithWhite:0.000 alpha:0.3].CGColor);
    CGContextStrokePath(context);
    
    // Inner circle
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius/2+10
                                                               startAngle:PROGRES_TO_RADIANS(preProgress_)
                                                                 endAngle:PROGRES_TO_RADIANS(progress_)
                                                                clockwise:YES];
    [self.circleTintColor setStroke];
    innerCirclePath.lineWidth = radius - 20;
    [innerCirclePath stroke];
}

-(void)layoutInnerCircle{
    
    if (innerCircleLayer) {
        [innerCircleLayer removeFromSuperlayer];
    }
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2 - self.innerPadding - 5;
    
    // Inner circle
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius/2
                                                               startAngle:PROGRES_TO_RADIANS(preProgress_)
                                                                 endAngle:PROGRES_TO_RADIANS(progress_)
                                                                clockwise:YES];
    
    innerCircleLayer = [CAShapeLayer layer];
    innerCircleLayer.path = innerCirclePath.CGPath;
    innerCircleLayer.strokeColor = self.circleTintColor.CGColor;
    innerCircleLayer.lineWidth = radius;
    innerCircleLayer.strokeEnd = 0.f;
    
    [self.layer addSublayer:innerCircleLayer];
    
    [UIView animateWithDuration:3.0 animations:^{
        //innerCircleLayer.strokeEnd = 1.f;
    }];
}

@end
