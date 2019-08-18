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
}

-(void)countDown{
    if (self.count > 0) {
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
    }
}
-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self removeFromSuperview];
}
@end
