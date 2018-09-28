# YSFPSStatus

在状态栏栏上显示FPS。(ps: `FPS(Frame Per Second)` 是一秒钟渲染多少帧 ， `FPS` 的值最佳为 `60` 左右，一般来说小于这个值就较为卡顿了。)

## 使用

### YSFPSStatus 直接使用

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

// 只在DEBUG模式下使用
#if defined(DEBUG)||defined(_DEBUG)
    [[YSFPSStatus sharedInstance] open];
#endif

//#if defined(DEBUG)||defined(_DEBUG)
//    [[YSFPSStatus sharedInstance] openWithHandler:^(NSInteger fpsValue) {
//        NSLog(@"fpsvalue %@",@(fpsValue));
//    }];
//#endif

    return YES;
}
```

![](https://github.com/kysonyangs/YSFPSStatus/blob/master/screenshot/on_window.png)

### YSFPSLabel 自定义使用
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...

#if defined(DEBUG)||defined(_DEBUG)
    YSFPSLabel *fpsLabel = [[YSFPSLabel alloc] initWithFrame:CGRectMake(10, 300, 60, 30)];
//    fpsLabel.fpsHandler = ^(NSInteger fpsValue) {
//        NSLog(@"fpsvalue %@",@(fpsValue));
//    };
    [self.window.rootViewController.view addSubview:fpsLabel];
#endif

    return YES;
}

![](https://github.com/kysonyangs/YSFPSStatus/blob/master/screenshot/on_view.png)
```