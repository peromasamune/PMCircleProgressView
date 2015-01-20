//
//  PMCircleProgressView.h
//  PMCircleProgressBar
//
//  Created by Taku Inoue on 2013/11/07.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMAnimationLabel.h"

typedef void (^PMCircleProgressViewAnimationBlock)(BOOL completed);

@interface PMCircleProgressView : UIView <PMAnimationLabelDelegate>

// Public Properties
@property (nonatomic, assign) CGFloat innerPadding;
@property (nonatomic) UIColor *circleTintColor;
@property (nonatomic) UIColor *circleBackgroundTintColor;
@property (nonatomic, assign) BOOL isShowBackShadow,isShowInnerShadow;
@property (nonatomic) PMAnimationLabel *percentageLabel;
@property (nonatomic, assign) CGFloat circleAlpha;
@property (nonatomic, readonly) float progress; // 0 ~ 1

-(void)setProgress:(float)progress duration:(NSTimeInterval)duration block:(PMCircleProgressViewAnimationBlock)block;

@end
