//
//  YSFPSStatus.m
//  SuperBook
//
//  Created by Kyson on 2018/5/24.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSFPSStatus.h"

#define kFPSSize CGSizeMake(60, 20)
#define kStatusHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

#pragma mark -
@interface YSFPSWeakProxy : NSProxy
@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end

#pragma mark -
@implementation YSFPSStatus
@synthesize fpsLabel = _fpsLabel;

+ (YSFPSStatus *)sharedInstance {
    static YSFPSStatus *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YSFPSStatus alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
    }
    return self;
}

- (void)open {
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag==101) {
            return;
        }
    }
    
    [[((NSObject <UIApplicationDelegate> *)([UIApplication sharedApplication].delegate)) window].rootViewController.view addSubview:self.fpsLabel];
}

- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler{
    [[YSFPSStatus sharedInstance] open];
    self.fpsLabel.fpsHandler = handler;
}

- (void)close {
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag==101) {
            [label removeFromSuperview];
            return;
        }
    }
}

- (void)applicationDidBecomeActiveNotification {
    !self.fpsLabel ?: [self.fpsLabel paused:NO];
}

- (void)applicationWillResignActiveNotification {
    !self.fpsLabel ?: [self.fpsLabel paused:YES];
}

- (YSFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        CGFloat x = kStatusHeight > 20 ? ([[UIScreen mainScreen] bounds].size.width-kFPSSize.width)/2 : ([[UIScreen mainScreen] bounds].size.width-kFPSSize.width)/2+kFPSSize.width;
        CGFloat y = kStatusHeight > 20 ? kStatusHeight - 10 : kStatusHeight - 20;
        _fpsLabel = [[YSFPSLabel alloc] initWithFrame:CGRectMake(x, y, kFPSSize.width, kFPSSize.height)];
        _fpsLabel.tag = 101;
    }
    return _fpsLabel;
}

@end

#pragma mark -
@implementation YSFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 || frame.size.height == 0) {
        frame.size = kFPSSize;
    }
    self = [super initWithFrame:frame];
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    _link = [CADisplayLink displayLinkWithTarget:[YSFPSWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kFPSSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)] attributes:@{NSFontAttributeName: _font}];
    
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length - 4, 1)];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    
    self.attributedText = text;
    
    if (_fpsHandler) {
        _fpsHandler((int)round(fps));
    }
}

- (void)paused:(BOOL)paused {
    [_link setPaused:paused];
}

@end

#pragma mark -
@implementation YSFPSWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[YSFPSWeakProxy alloc] initWithTarget:target];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}
@end
