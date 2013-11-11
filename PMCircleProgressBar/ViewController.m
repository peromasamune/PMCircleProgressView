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
@property (nonatomic) float progress;

-(void)startAnimationButtonDidPush:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.progressBar = [[PMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
    self.progressBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
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
    
    if (self.progress > 1.f) {
        self.progress = 0.f;
    }
    
    self.progress += 0.1f;
    [self.progressBar setProgress:self.progress duration:1.0 block:^(BOOL completed) {
        NSLog(@"%s Animation Completed.",__func__);
    }];
}

@end
