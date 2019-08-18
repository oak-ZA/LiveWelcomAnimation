//
//  CountDownLabel.m
//  AttributerString
//
//  Created by zhangao on 2019/8/18.
//  Copyright © 2019 张奥. All rights reserved.
//

#import "CountDownLabel.h"

@interface CountDownLabel()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_source_t GCDtimer;
@end
@implementation CountDownLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)startCountDown{
    
    [self initTimer];
}
-(void)initTimer{
    if (self.count == 0) {
        self.count = 3;
    }
    if (_timer) {
        [self stopTime];
    }
    [self countDown];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    self.GCDtimer = timer;
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (uint64_t)(1 * NSEC_PER_SEC), 0);
//    __weak typeof(self) weakSelf = self;
//    dispatch_source_set_event_handler(timer, ^{
//        [weakSelf countDown];
//    });
//    dispatch_resume(timer);
}

-(void)countDown{
    if (self.count > 0) {
        NSLog(@"-------%ld",self.count);
        self.text = [NSString stringWithFormat:@"%ld",self.count];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.removedOnCompletion = NO;
        NSValue *value1 = [NSNumber numberWithFloat:3.0f];
        NSValue *value2 = [NSNumber numberWithFloat:2.0f];
        NSValue *value3 = [NSNumber numberWithFloat:0.7f];
        NSValue *value4 = [NSNumber numberWithFloat:1.0f];
        animation.values = @[value1,value2,value3,value4];
        animation.duration = 0.4;
        [self.layer addAnimation:animation forKey:@"scalsTime"];
        _count --;
    }else{
        [self stopTime];
//        [self pause];
    }
}
-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self removeFromSuperview];
}

-(void)pause{
    if (self.GCDtimer) {
        dispatch_cancel(self.GCDtimer);
        self.GCDtimer = nil;
    }
    [self removeFromSuperview];
}
@end
