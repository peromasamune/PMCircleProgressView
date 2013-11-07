//
//  PMCircleProgressView.h
//  PMCircleProgressBar
//
//  Created by Taku Inoue on 2013/11/07.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PMCircleProgressViewAnimationBlock)(BOOL completed);

@interface PMCircleProgressView : UIView

// Public Properties
@property (nonatomic, assign) CGFloat innerPadding;
@property (nonatomic) UIColor *circleTintColor;

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated isResume:(BOOL)isResume block:(PMCircleProgressViewAnimationBlock)block;

@end
