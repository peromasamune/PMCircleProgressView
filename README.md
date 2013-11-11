# PMCircleProgressView

## 

Animated circle progressview

![Screen1](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen1.png?raw=true)

![Screen2](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen2.png?raw=true)

![Screen3](https://github.com/peromasamune/PMCircleProgressView/blob/master/screens/screen3.png?raw=true)


# How to use 
##  

Import headr file

```objective-c
\#import "PMCircleProgressView.h"
```

Create object

```objective-c
PMCircleProgressView *progressBar = [[PMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
    progressBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:progressBar];
```

Call animation method

```objective-c
[progressBar setProgress:1.0 duration:1.0 block:^(BOOL completed) {
        NSLog(@"%s Animation Completed.",__func__);
    }];
```

