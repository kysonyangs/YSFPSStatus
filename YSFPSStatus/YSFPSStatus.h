//
//  YSFPSStatus.h
//  SuperBook
//
//  Created by Kyson on 2018/5/24.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSFPSLabel;

@interface YSFPSStatus : NSObject

@property (nonatomic, strong, readonly) YSFPSLabel *fpsLabel;

+ (YSFPSStatus *)sharedInstance;

- (void)open;
- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler;
- (void)close;

@end

// FPS性能检测Label
@interface YSFPSLabel : UILabel

@property(nonatomic, copy) void (^fpsHandler)(NSInteger fpsValue);

// 是否暂停检测
- (void)paused:(BOOL)paused;

@end
