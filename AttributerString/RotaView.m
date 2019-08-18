//
//  RotaView.m
//  AttributerString
//
//  Created by zhangao on 2019/8/18.
//  Copyright © 2019 张奥. All rights reserved.
//

#import "RotaView.h"
#import <Masonry.h>
@interface RotaView()
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, assign) NSInteger rotaNumber;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, copy) NSArray *data1;
@end
@implementation RotaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.rotaNumber = 0;
//        self.backgroundColor = [UIColor blueColor];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_gunlun"]];
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self createScrollLabel];
        
    }
    return self;
}

-(void)createScrollLabel{
    NSArray *data1 = @[@"打了一闷棍",@"KO一拳",@"打了一巴掌",@"开个玩笑",@"吓了一跳",@"泼了一脸",@"踢了一脚",@"给了一锤子",@"不掉血哦",@"丢弃所有"];
    self.data1 = data1;
    UIScrollView *scrollView1 = [[UIScrollView alloc] init];
//    scrollView1.backgroundColor = [UIColor redColor];
    self.scrollView1 = scrollView1;
    scrollView1.contentSize = CGSizeMake(0, data1.count*self.frame.size.height);
    [self addSubview:scrollView1];
    [scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.centerY.equalTo(self.mas_centerY).with.offset(1);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(80);
    }];
    for (int i= 0; i<data1.count; i++) {
        NSString *str = data1[i];
        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor blueColor];
        label.frame = CGRectMake(0, i*28, 80, 28);
        label.text = str;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView1 addSubview:label];
    }
    
}

-(void)initTimer{
    [self stopTime];
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    self.time = time;
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
  
}

-(void)animation{
    self.rotaNumber ++;
    self.scrollView1.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.1 animations:^{
        self.scrollView1.contentOffset = CGPointMake(0, (self.data1.count-1)*28);
    } completion:^(BOOL finished) {
        if (self.rotaNumber == 10) {
            self.scrollView1.contentOffset = CGPointMake(0, (self.data1.count-6)* 28);
            [self stopTime];
        }
    }];
}

-(void)stopTime{
    if (self.time) {
        [self.time invalidate];
        self.time = nil;
    }
    self.rotaNumber = 0;
}
@end
