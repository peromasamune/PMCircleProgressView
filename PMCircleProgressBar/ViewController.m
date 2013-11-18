//
//  ViewController.m
//  PMCircleProgressBar
//
//  Created by Taku Inoue on 2013/11/07.
//  Copyright (c) 2013 Peromasamune. All rights reserved.
//

#import "ViewController.h"
#import "PMCircleProgressView.h"

#define PROGRESS_WIDTH 200

@interface ViewController ()

@property (nonatomic) PMCircleProgressView *progressBar;

-(void)startAnimationButtonDidPush:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //PMCircleProgressView instance settings
    
    //Initialize and set frame
    self.progressBar = [[PMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
    self.progressBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    //Meter innter padding
    self.progressBar.innerPadding = 50;
    
    //Circle color
    self.progressBar.circleBackgroundTintColor = [UIColor whiteColor];
    self.progressBar.percentageLabel.textColor = [UIColor blackColor];
    
    //Circle shadow
    self.progressBar.isShowInnerShadow = YES;
    self.progressBar.isShowBackShadow = NO;
    
    [self.view addSubview:self.progressBar];
    
    UIButton *startAnimationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startAnimationButton.frame = CGRectMake(0, 0, 240, 40);
    startAnimationButton.center = CGPointMake(self.view.frame.size.width/2, 60);
    [startAnimationButton setTitle:@"start" forState:UIControlStateNormal];
    [startAnimationButton addTarget:self action:@selector(startAnimationButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startAnimationButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Button Actions --

-(void)startAnimationButtonDidPush:(id)sender{
    
    //Start progress animation
    [self.progressBar setProgress:0.8 duration:1.0 block:^(BOOL completed) {
        NSLog(@"%s Animation Completed.",__func__);
    }];
}

@end
