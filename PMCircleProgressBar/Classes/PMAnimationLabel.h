//
//  PMAnimationLabel.h
//  PMCircleProgressBar
//
//  Created by Peromasamune on 2013/11/11.
//  Copyright (c) 2013年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMAnimationLabelDelegate;
@interface PMAnimationLabel : UILabel

-(void)animationFrom:(long)fromValue to:(long)toValue withDuration:(NSTimeInterval)duration;

@property (nonatomic) NSString *suffix;
@property (nonatomic, assign) id<PMAnimationLabelDelegate> delegate;

@end

@protocol PMAnimationLabelDelegate <NSObject>
@optional
-(void)animationLabelValueDidChange:(long)value;
-(void)animationLabelDidFinishAnimation;
@end
