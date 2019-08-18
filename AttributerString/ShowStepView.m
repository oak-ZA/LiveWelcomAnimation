//
//  ShowStepView.m
//  AttributerString
//
//  Created by zhangao on 2019/8/18.
//  Copyright © 2019 张奥. All rights reserved.
//

#import "ShowStepView.h"
#import <Masonry.h>
@implementation ShowStepView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
 
    }
    return self;
}

-(void)showLabel{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"心动送礼开始";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
@end
