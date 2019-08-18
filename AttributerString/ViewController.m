//
//  ViewController.m
//  AttributerString
//
//  Created by 张奥 on 2019/7/23.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "ViewController.h"
#import "YYText.h"
#import "YYImage.h"
#import "ShowStepView.h"
#import <Masonry.h>
#define SCREEN_Width [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<CAAnimationDelegate>
@property (nonatomic,strong) NSMutableArray *dataSources;
@property (nonatomic,strong)YYLabel *label;
@property (nonatomic,strong)UIView *animationView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *whiteView;
@property (nonatomic,assign)NSInteger whiteTiem;
@property (nonatomic,assign)BOOL isSecond;
@property (nonatomic,strong)NSTimer *particleTimer;

@property (nonatomic,strong) MASConstraint *width;
@property (nonatomic,strong) ShowStepView *stepView;
@end

@implementation ViewController

-(NSMutableArray*)dataSources{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.whiteTiem = 2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, 80, 80, 80);
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8.f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(180, 80, 100, 80);
    [button2 setTitle:@"点我展示" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor blueColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 8.f;
    button2.layer.masksToBounds = YES;
    [button2 addTarget:self action:@selector(clickButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    self.dataSources = [NSMutableArray arrayWithArray:@[@"张奥",@"嘻嘻",@"呵呵",@"哈哈",@"张大吉"]];
    
    NSTimer *T = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(addData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:T forMode:NSRunLoopCommonModes];
}
-(void)clickButton2{
    if (self.stepView) {
        [self.stepView removeFromSuperview];
    }
    ShowStepView *stepView = [[ShowStepView alloc] init];
    self.stepView = stepView;
    [self.view addSubview:stepView];
    [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(200);
        make.height.mas_equalTo(60);
       self.width = make.width.mas_equalTo(60);
    }];
    [stepView showLabel];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [stepView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.width.mas_equalTo(SCREEN_Width - 40);
        }];
        [self.view layoutIfNeeded];
    }];
    
}
-(void)addData{
    
    NSString *name = @"猫咪";
    int index = [self getRandomNumber:0 to:100];
    if (index % 3 == 0) {
        name = @"巫师";
    }
    [self.dataSources addObject:name];
}
-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}
-(void)clickButton{
    [self startAnimation];
}
-(void)startAnimation{
    if (self.dataSources.count > 0) {
        [self createAniamtionUIName:self.dataSources[0]];
        [self createParticleTimer];
        [self scrollAniamtionIsSecond:NO];
    }
}
-(void)animationDidStart:(CAAnimation *)anim{
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (!_isSecond) {
        [self whiteBlingAniamtion];
    }else{
        if (self.particleTimer) {
            [self.particleTimer invalidate];
            self.particleTimer = nil;
        }
        [self.dataSources removeObjectAtIndex:0];
        [self startAnimation];
    }
}


//滚动动画
-(void)scrollAniamtionIsSecond:(BOOL)isSecond{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"position";
    CGPoint center = self.bgView.center;
    _isSecond = isSecond;
    if (!isSecond) {
        NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y)];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake((SCREEN_Width/2.f)+10+40, center.y)];
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake((SCREEN_Width/2.f)+10, center.y)];
        keyAnimation.values = @[value1,value2,value3];
        keyAnimation.keyTimes = @[@0,@0.6,@0.8];
        self.bgView.frame = CGRectMake(10, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
        keyAnimation.duration = 1.4;
    }else{
        NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y)];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(-SCREEN_Width, center.y)];
        keyAnimation.values = @[value1,value2];
        keyAnimation.keyTimes = @[@0,@0.8];
        keyAnimation.duration = 0.8;
    }
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyAnimation.delegate=self;
    [self.bgView.layer addAnimation:keyAnimation forKey:@"scrollAnimation"];
}
//白色闪烁动画
-(void)whiteBlingAniamtion{
    self.whiteView.hidden = NO;
    if (self.whiteTiem == 0) {
        self.whiteTiem = 2;
        [self.whiteView.layer removeAllAnimations];
        [self.whiteView removeFromSuperview];
        [self scrollAniamtionIsSecond:YES];
        return;
    }
    [UIView animateWithDuration:1.0 animations:^{
        self.whiteView.frame = CGRectMake(200, self.whiteView.frame.origin.y, self.whiteView.frame.size.width, self.whiteView.frame.size.height);
        self.whiteTiem -- ;
    } completion:^(BOOL finished) {
        self.whiteView.hidden = YES;
        self.whiteView.frame = CGRectMake(30, 0, 30, 45);
//        sleep(1);
        [self whiteBlingAniamtion];
    }];
}
//给bgView添加虚线动画
-(void)addDashPhaseView:(UIView*)view{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = view.bounds;
    [shapLayer setFillColor:[UIColor clearColor].CGColor];
    [shapLayer setStrokeColor:[UIColor purpleColor].CGColor];
    [shapLayer setLineWidth:1.f];
    [shapLayer setLineCap:kCALineJoinRound];
    [shapLayer setLineDashPattern:[NSArray arrayWithObjects:@(6),@4, nil]];
    [shapLayer setPath:path.CGPath];
    [view.layer addSublayer:shapLayer];
    
    CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:60.f]];
    [dashAnimation setDuration:2.f];
    dashAnimation.cumulative = YES;
    [dashAnimation setRepeatCount:MAXFLOAT];
    dashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [shapLayer addAnimation:dashAnimation forKey:@"lineDashPhase"];
}
//粒子定时器
-(void)createParticleTimer{
    if (self.particleTimer) {
        [self.particleTimer invalidate];
        self.particleTimer = nil;
    }
    self.particleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(particleTimerStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.particleTimer forMode:NSRunLoopCommonModes];
}
//粒子动画
-(void)particleTimerStart{
    CGFloat startX = 0.0;
    for (int i=0; i<4; i++) {
        startX = startX + 45.f/4.f;
        UIView *snowView = [[UIView alloc] init];
        snowView.backgroundColor = [UIColor purpleColor];
        snowView.frame = CGRectMake(0, 0, 8, 2);
        snowView.center = CGPointMake(0, startX);
        [self.animationView addSubview:snowView];
        // 创建动画，移动粒子，动画结束后删除
        [UIView animateWithDuration:0.8 animations:^{
            // 改变位置
            snowView.center = CGPointMake(240, snowView.center.y);
        } completion:^(BOOL finished) {
            [snowView removeFromSuperview];
        }];
    }
}
//动画UI
-(void)createAniamtionUIName:(NSString*)nameStr{
    if (self.bgView) {
        [self.bgView.layer removeAllAnimations];
        [self.bgView removeFromSuperview];
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_Width, SCREEN_Height - 180, SCREEN_Width, 60)];
    bgView.backgroundColor = [UIColor clearColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(30, (bgView.frame.size.height - 45)/2.f, 250, 45)];
    animationView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.6];
    self.animationView = animationView;
    [bgView addSubview:animationView];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    whiteView.frame = CGRectMake(30, 0, 30, 45);
    self.whiteView = whiteView;
    whiteView.hidden = YES;
    [animationView addSubview:whiteView];
    
    [self createUIName:nameStr];
    UIImageView *avartImageView = [[UIImageView alloc] init];
    avartImageView.frame = CGRectMake(0, 0, 60, 60);
    avartImageView.backgroundColor = [UIColor whiteColor];
    avartImageView.layer.cornerRadius = 30.f;
    avartImageView.layer.masksToBounds = YES;
    avartImageView.image = [UIImage imageNamed:@"vb_applepay"];
    [bgView addSubview:avartImageView];
    
    //添加虚线动画
    [self addDashPhaseView:animationView];
    //渐隐
    [self addGradientMaskForFadeLengthView:animationView frame:CGRectMake(0, 0, animationView.frame.size.width, animationView.frame.size.height)];
}
//渐隐效果
- (void)addGradientMaskForFadeLengthView:(UIView*)bgView frame:(CGRect)rect{
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = rect;
    gradientMask.shouldRasterize = YES;
    gradientMask.rasterizationScale = 10;
    gradientMask.colors = @[(id)[UIColor purpleColor].CGColor,(id)[UIColor clearColor].CGColor];
    gradientMask.startPoint = CGPointMake(0.4, 0);
    gradientMask.endPoint = CGPointMake(1, 0);
    gradientMask.locations = @[@(0.4),@1];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    bgView.layer.mask = gradientMask;
    [CATransaction commit];
}
-(void)createUIName:(NSString*)nameStr{
    YYLabel *label = [[YYLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(30, 2.5, 250, 40);
    label.preferredMaxLayoutWidth = 250;
    label.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor whiteColor];
    self.label = label;
    [self.animationView addSubview:label];
    
    NSString *string = [NSString stringWithFormat:@"%@ 来啦~ 欢迎!",nameStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    attStr.yy_alignment = NSTextAlignmentJustified;
    UIImage *image = [UIImage imageNamed:@"level_27"];
    YYAnimatedImageView *imageView1 = [[YYAnimatedImageView alloc] initWithImage:image];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView1.bounds.size.width, imageView1.bounds.size.height) alignToFont:[UIFont systemFontOfSize:15.f] alignment:YYTextVerticalAlignmentCenter];
    [attStr appendAttributedString:attachText];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
    CGSize maxSize = CGSizeMake(250, MAXFLOAT);
    //计算文本宽高
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:attStr];
    CGFloat introWidth = layout.textBoundingSize.width;
    CGFloat introHeight = layout.textBoundingSize.height;
    self.label.frame = CGRectMake(self.label.frame.origin.x, (45.f - introHeight)/2.f, introWidth+10, introHeight);
    self.label.attributedText = attStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
