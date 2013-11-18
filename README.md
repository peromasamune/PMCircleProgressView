# PMCircleProgressView

## 

Animated circle progressview

![Screen1](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen1.png?raw=true)

# How to use 
##  

Import headr file

```objective-c
#import "PMCircleProgressView.h"
```

Create object

![Screen3](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen3.png?raw=true)

```objective-c

// Basic settings
PMCircleProgressView *progressBar = [[PMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
progressBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
[self.view addSubview:progressBar];
```

![Screen4](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen4.png?raw=true)

```objective-c

// Advanced settings
PMCircleProgressView *progressBar = [[PMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
progressBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
//Meter innter padding
progressBar.innerPadding = 50;
    
//Circle color
progressBar.circleBackgroundTintColor = [UIColor whiteColor];
progressBar.percentageLabel.textColor = [UIColor blackColor];
    
//Circle shadow
progressBar.isShowInnerShadow = YES;
progressBar.isShowBackShadow = NO;
    
[self.view addSubview:self.progressBar];
```

Call animation method

```objective-c
[progressBar setProgress:1.0 duration:1.0 block:^(BOOL completed) {
    NSLog(@"%s Animation Completed.",__func__);
}];
```

