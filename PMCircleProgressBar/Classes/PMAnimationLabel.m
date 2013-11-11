//
//  PMAnimationLabel.m
//  PMCircleProgressBar
//
//  Created by Peromasamune on 2013/11/11.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import "PMAnimationLabel.h"

@interface PMAnimationLabel()
-(float)update:(float)t;

@property (nonatomic, assign) float startValue,endValue,rate,totaltime;
@property (nonatomic, assign) CFTimeInterval startTime;

@end

@implementation PMAnimationLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.startValue = 0.f;
        self.endValue = 0.f;
        self.rate = 2.f;
        self.suffix = @"";
    }
    return self;
}

#pragma mark -- Class Method --

-(void)animationFrom:(float)fromValue to:(float)toValue withDuration:(NSTimeInterval)duration{
    self.startValue = fromValue;
    self.endValue = toValue;
    self.totaltime = duration;
    
    self.text = [self getTextFromProgress:self.startValue];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    self.startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark -- Private Method --

-(void)updateValue:(CADisplayLink *)link{
    float dt = ([link timestamp] - self.startTime) / self.totaltime;
    if (dt >= 1.0) {
        self.text = [self getTextFromProgress:self.endValue];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.delegate animationLabelDidFinishAnimation];
        return;
    }
    
    //float current = [self update:dt*self.endValue];
    float current = (self.endValue - self.startValue) * dt + self.startValue;
    self.text = [self getTextFromProgress:current];
    [self.delegate animationLabelValueDidChange:current];
}

-(NSString *)getTextFromProgress:(CGFloat)progress{
    int percentage = (int)floor(progress * 100);
    return [NSString stringWithFormat:@"%i%@",percentage,self.suffix];
}

-(float)update:(float)t{
    int sign = 1;
    int r = (int) self.rate;
    if (r % 2 == 0) {
        sign = -1;
    }
    t *= 2;
    if (t < 1) {
        return 0.5f * powf(t, self.rate);
    }else{
        return sign * 0.5f * (powf(t-2, self.rate) + sign * 2);
    }
}

@end
